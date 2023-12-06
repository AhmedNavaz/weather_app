import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class ConnectionNotifier with ChangeNotifier {
  ConnectionNotifier() {
    startMonitoring();
  }

  final Connectivity _connectivity = Connectivity();

  bool _isOnline = true;

  bool get isOnline => _isOnline;

  /// Will start monitoring the user network connection making
  /// sure to notify any connection changes.
  Future<void> startMonitoring() async {
    await initConnectivity();
    _connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await Future.delayed(const Duration(seconds: 1));
      if (result == ConnectivityResult.none) {
        _isOnline = false;
        notifyListeners();
      } else {
        await _updateConnectionStatus().then((bool isConnected) {
          _isOnline = isConnected;
          notifyListeners();
        });
      }
    });
  }

  /// Initialize connectivity function
  Future<void> initConnectivity() async {
    try {
      ConnectivityResult status = await _connectivity.checkConnectivity();
      if (status == ConnectivityResult.none) {
        _isOnline = false;
        notifyListeners();
      } else {
        _isOnline = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Check if the mobile has internet connection
  Future<bool> _updateConnectionStatus() async {
    try {
      List<InternetAddress> result =
          await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
