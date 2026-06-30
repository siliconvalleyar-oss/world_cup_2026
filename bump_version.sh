#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# ── Config ──────────────────────────────────────────────
PUBSPEC="pubspec.yaml"
REMOTE="origin"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

# ── Colored helpers ─────────────────────────────────────
info()  { echo -e "\033[36m➜\033[0m $*"; }
ok()    { echo -e "\033[32m✔\033[0m $*"; }
err()   { echo -e "\033[31m✘\033[0m $*" >&2; exit 1; }

# ── 1. Get latest tag (fallback to v0.0.0+0) ──────────
LATEST_TAG="$(git tag --sort=-version:refname | head -1)" || true
if [[ -z "$LATEST_TAG" ]]; then
  LATEST_TAG="v0.0.0+0"
  info "No tags found — starting at $LATEST_TAG"
fi

# Strip leading 'v'
RAW="${LATEST_TAG#v}"

# Parse major.minor.patch+build
if [[ "$RAW" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)$ ]]; then
  MAJOR="${BASH_REMATCH[1]}"
  MINOR="${BASH_REMATCH[2]}"
  PATCH="${BASH_REMATCH[3]}"
  BUILD="${BASH_REMATCH[4]}"
else
  err "Tag format not recognized: $LATEST_TAG (expected vX.Y.Z+B)"
fi

# ── 2. Check if there are changes since last tag ─────
TAG_RANGE="${LATEST_TAG}..HEAD"
CHANGES=$(git log "$TAG_RANGE" --oneline 2>/dev/null || true)
if [[ -z "$CHANGES" ]]; then
  echo ""
  info "No changes since $LATEST_TAG — nothing to bump."
  exit 0
fi

# ── 3. Check for dirty tracked files ────────────────
DIRTY="$(git status --porcelain --untracked-files=no)"
if [[ -n "$DIRTY" ]]; then
  echo "$DIRTY"
  err "Uncommitted changes on tracked files — commit or stash first"
fi

# ── 4. Increment patch (0→9 then rollover) ──────────
PATCH=$((PATCH + 1))
if (( PATCH > 9 )); then
  PATCH=0
  MINOR=$((MINOR + 1))
  if (( MINOR > 9 )); then
    MINOR=0
    MAJOR=$((MAJOR + 1))
  fi
fi
BUILD=$((BUILD + 1))

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}+${BUILD}"
NEW_TAG="v${NEW_VERSION}"

# ── 5. Check if already tagged ───────────────────────
if git rev-parse "$NEW_TAG" &>/dev/null; then
  err "Tag $NEW_TAG already exists"
fi

# ── 6. Update pubspec.yaml ────────────────────────────
if [[ -f "$PUBSPEC" ]]; then
  sed -i "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC"
  info "Updated $PUBSPEC → $NEW_VERSION"
else
  err "$PUBSPEC not found"
fi

# ── 7. Commit changes ─────────────────────────────────
git add "$PUBSPEC"
# Include this script if it's new/untracked
if [[ -f "bump_version.sh" ]] && ! git ls-files --error-unmatch bump_version.sh &>/dev/null 2>&1; then
  git add bump_version.sh
fi
git commit -m "chore: bump version to $NEW_VERSION"
ok "Committed changes"

# ── 8. Tag ────────────────────────────────────────────
git tag "$NEW_TAG"
ok "Tagged $NEW_TAG"

# ── 9. Push ───────────────────────────────────────────
info "Pushing to $REMOTE/$BRANCH ..."
git push "$REMOTE" "$BRANCH" --tags
ok "Pushed $BRANCH with tag $NEW_TAG"

echo ""
info "Done — bumped $LATEST_TAG → $NEW_TAG"
