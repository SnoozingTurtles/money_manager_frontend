import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';

class ConnectivitySingleton {
  static final ConnectivitySingleton _singleton = ConnectivitySingleton._internal();
  ConnectivitySingleton._internal();

  static ConnectivitySingleton getInstance() => _singleton;

  //this tracks the current connection status
  bool hasConnection = false;

  //this is how we'll subscribe to connection changes
  StreamController<bool> connectionChangeController = StreamController.broadcast();

  //flutter connectivity
  final Connectivity _connectivity = Connectivity();

  //hook into flutter_connectivity's stream to listen for changes
  //and check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
      debugPrint("Connectivity changed ${result.name}");
      if (result.name == 'none') {
        hasConnection = false;
        return;
      }
      await checkConnection();
    });
  }

  Stream<bool> get connectionChange => connectionChangeController.stream;

  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //if connection status is changed send out an update to all its listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    print("has connection $hasConnection");
    return hasConnection;
  }

  //clean up method to close stream controller and cancel subscriptions
  void dispose() {
    connectionChangeController.close();
  }
}
