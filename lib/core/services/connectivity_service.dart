import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _connectionController;

  factory ConnectivityService() => _instance;

  ConnectivityService._internal();

  Stream<bool> get connectionStream {
    _connectionController?.close();
    _connectionController = StreamController<bool>.broadcast();

    _connectivity.onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      _connectionController?.add(hasConnection);
    });

    return _connectionController!.stream;
  }

  Future<bool> isConnected() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((r) => r != ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkConnection() async {
    return isConnected();
  }

  void dispose() {
    _connectionController?.close();
    _connectionController = null;
  }
}
