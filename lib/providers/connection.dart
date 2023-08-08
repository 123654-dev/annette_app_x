import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionProvider {
  static bool _connection = false;
  static late StreamSubscription<ConnectivityResult> _subscription;

  static void init() {
    print("ConnectionProvider init");
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result);
      _connection = result != ConnectivityResult.none;
    });
  }

  static void dispose() {
    _subscription.cancel();
  }

  static bool hasConnection() => _connection;
}
