import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { connected, disconnected, unknown }

class ConnectivityState {
  final ConnectivityStatus status;
  final bool hasConnection;

  const ConnectivityState({
    this.status = ConnectivityStatus.unknown,
    this.hasConnection = true,
  });
}

class ConnectivityNotifier extends StateNotifier<ConnectivityState> {
  ConnectivityNotifier() : super(const ConnectivityState()) {
    _init();
  }

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  void _init() {
    _checkConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection =
          results.any((r) => r != ConnectivityResult.none);
      state = ConnectivityState(
        status: hasConnection
            ? ConnectivityStatus.connected
            : ConnectivityStatus.disconnected,
        hasConnection: hasConnection,
      );
    });
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      final hasConnection =
          results.any((r) => r != ConnectivityResult.none);
      state = ConnectivityState(
        status: hasConnection
            ? ConnectivityStatus.connected
            : ConnectivityStatus.disconnected,
        hasConnection: hasConnection,
      );
    } catch (_) {
      state = const ConnectivityState(
        status: ConnectivityStatus.unknown,
        hasConnection: true,
      );
    }
  }

  Future<void> checkConnectivity() async {
    await _checkConnectivity();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityState>((ref) {
  return ConnectivityNotifier();
});

final isConnectedProvider = Provider<bool>((ref) {
  return ref.watch(connectivityProvider).hasConnection;
});
