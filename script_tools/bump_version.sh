#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# ── Config ──────────────────────────────────────────────
PUBSPEC="pubspec.yaml"
VERSION_FILE="VERSION"
REMOTE="origin"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

# ── Colored helpers ─────────────────────────────────────
info()  { echo -e "\033[36m➜\033[0m $*"; }
ok()    { echo -e "\033[32m✔\033[0m $*"; }
err()   { echo -e "\033[31m✘\033[0m $*" >&2; exit 1; }

# ── 1. Get latest tag ──────────────────────────────────
LATEST_TAG="$(git tag --sort=-version:refname | head -1)" || true
if [[ -z "$LATEST_TAG" ]]; then
  LATEST_TAG="v0.0.0"
  info "No tags found — starting at $LATEST_TAG"
fi

# Parse major.minor.patch from tag (format: vX.Y.Z)
RAW="${LATEST_TAG#v}"
if [[ "$RAW" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  MAJOR="${BASH_REMATCH[1]}"
  MINOR="${BASH_REMATCH[2]}"
  PATCH="${BASH_REMATCH[3]}"
else
  err "Tag format not recognized: $LATEST_TAG (expected vX.Y.Z)"
fi

# ── 2. Get build number from pubspec.yaml ──────────────
if [[ ! -f "$PUBSPEC" ]]; then
  err "$PUBSPEC not found"
fi

PUBSPEC_VER="$(grep '^version: ' "$PUBSPEC" | sed 's/^version: *//')"
if [[ "$PUBSPEC_VER" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)$ ]]; then
  BUILD="${BASH_REMATCH[4]}"
else
  err "pubspec.yaml version format not recognized: $PUBSPEC_VER (expected X.Y.Z+B)"
fi

# ── 3. Check there are changes since last tag ────────
TAG_RANGE="${LATEST_TAG}..HEAD"
CHANGES=$(git log "$TAG_RANGE" --oneline 2>/dev/null || true)
if [[ -z "$CHANGES" ]]; then
  echo ""
  info "No changes since $LATEST_TAG — nothing to bump."
  exit 0
fi

# ── 4. Check for dirty tracked files ─────────────────
DIRTY="$(git status --porcelain --untracked-files=no)"
if [[ -n "$DIRTY" ]]; then
  echo "$DIRTY"
  err "Uncommitted changes on tracked files — commit or stash first"
fi

# ── 5. Increment patch (0→9 then rollover) ───────────
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
NEW_TAG="v${MAJOR}.${MINOR}.${PATCH}"

# ── 6. Check if tag already exists ───────────────────
if git rev-parse "$NEW_TAG" &>/dev/null; then
  err "Tag $NEW_TAG already exists"
fi

# ── 7. Update pubspec.yaml ───────────────────────────
sed -i "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC"
info "Updated $PUBSPEC → $NEW_VERSION"

# ── 8. Update VERSION file ──────────────────────────
echo "$NEW_TAG" > "$VERSION_FILE"
info "Updated $VERSION_FILE → $NEW_TAG"

# ── 9. Commit changes ────────────────────────────────
git add "$PUBSPEC" "$VERSION_FILE"
git commit -m "chore: bump version to $NEW_VERSION"
ok "Committed changes"

# ── 10. Tag (annotated) ──────────────────────────────
git tag -a "$NEW_TAG" -m "Version $NEW_VERSION"
ok "Tagged $NEW_TAG"

# ── 11. Push ──────────────────────────────────────────
info "Pushing to $REMOTE/$BRANCH ..."
git push "$REMOTE" "$BRANCH" --tags
ok "Pushed $BRANCH with tag $NEW_TAG"

echo ""
info "Done — $LATEST_TAG → $NEW_TAG"
