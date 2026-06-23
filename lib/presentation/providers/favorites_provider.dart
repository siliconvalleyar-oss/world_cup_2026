import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum FavoriteType { team, player, match }

class FavoriteItem {
  final String id;
  final FavoriteType type;
  final String name;
  final String? imageUrl;

  FavoriteItem({
    required this.id,
    required this.type,
    required this.name,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'name': name,
        'imageUrl': imageUrl,
      };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) => FavoriteItem(
        id: json['id'] as String,
        type: FavoriteType.values.byName(json['type'] as String),
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String?,
      );
}

class FavoritesState {
  final List<FavoriteItem> items;

  const FavoritesState({this.items = const []});

  FavoritesState copyWith({List<FavoriteItem>? items}) {
    return FavoritesState(items: items ?? this.items);
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  FavoritesNotifier() : super(const FavoritesState()) {
    _loadFromHive();
  }

  static const String _boxName = 'favorites';
  static const String _key = 'favorites_data';

  Future<void> _loadFromHive() async {
    try {
      final box = await Hive.openBox(_boxName);
      final data = box.get(_key) as String?;
      if (data != null) {
        final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
        final items = jsonList
            .map((e) => FavoriteItem.fromJson(e as Map<String, dynamic>))
            .toList();
        state = FavoritesState(items: items);
      }
    } catch (_) {}
  }

  Future<void> _saveToHive() async {
    try {
      final box = await Hive.openBox(_boxName);
      final jsonList = state.items.map((e) => e.toJson()).toList();
      await box.put(_key, jsonEncode(jsonList));
    } catch (_) {}
  }

  bool isFavorite(String id) {
    return state.items.any((item) => item.id == id);
  }

  Future<void> toggleFavorite(FavoriteItem item) async {
    if (isFavorite(item.id)) {
      state = state.copyWith(
        items: state.items.where((i) => i.id != item.id).toList(),
      );
    } else {
      state = state.copyWith(
        items: [...state.items, item],
      );
    }
    await _saveToHive();
  }

  List<FavoriteItem> getFavoriteTeams() {
    return state.items.where((i) => i.type == FavoriteType.team).toList();
  }

  List<FavoriteItem> getFavoritePlayers() {
    return state.items.where((i) => i.type == FavoriteType.player).toList();
  }

  List<FavoriteItem> getFavoriteMatches() {
    return state.items.where((i) => i.type == FavoriteType.match).toList();
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier();
});
