import 'dart:async';

import 'package:annette_app_x/providers/user_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionProvider {
  static bool _connection = false;
  static bool _downloadConnection = false;
  static late StreamSubscription<ConnectivityResult> _subscription;

  static void init() {
    print("ConnectionProvider init");
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print(result);
      _connection = result != ConnectivityResult.none;
      checkConnectionPreferences(result);
    });
  }

  static void checkConnectionPreferences(ConnectivityResult result) {
    _downloadConnection = UserSettings.useMobileData
        ? result != ConnectivityResult.none
        : result != ConnectivityResult.none &&
            result != ConnectivityResult.mobile;
  }

  static void dispose() {
    _subscription.cancel();
  }

  static bool hasDownloadConnection() => _downloadConnection;

  static bool hasConnection() => _connection;
}
