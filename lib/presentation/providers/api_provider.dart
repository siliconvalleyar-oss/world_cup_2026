import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:world_cup_2026/data/datasources/remote/thesportsdb_service.dart';

final theSportsDBServiceProvider = Provider<TheSportsDBService>((ref) {
  return TheSportsDBService();
});
