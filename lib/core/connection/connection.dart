import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

// A class that provides connectivity status updates to listeners.
class ConnectionNotifier with ChangeNotifier {
  ConnectionNotifier() {
    startMonitoring();
  }

  // Connectivity instance to check network status.
  final Connectivity _connectivity = Connectivity();

  bool _isOnline = true;

  // Getter method to retrieve the current online status.
  bool get isOnline => _isOnline;

  // Initiates the connectivity monitoring process.
  Future<void> startMonitoring() async {
    await initConnectivity();
    _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        // Introduce a delay to prevent false positives during quick network changes.
        await Future.delayed(const Duration(seconds: 1));
        if (result == ConnectivityResult.none) {
          _isOnline = false;
          notifyListeners();
        } else {
          // Check and update connection status if the device is not offline.
          await _updateConnectionStatus().then(
            (bool isConnected) {
              _isOnline = isConnected;
              if (_isOnline) {}
              notifyListeners();
            },
          );
        }
      },
    );
  }

  // Initializes the initial connectivity status.
  Future<void> initConnectivity() async {
    try {
      // Check the current connectivity status.
      ConnectivityResult status = await _connectivity.checkConnectivity();
      if (status == ConnectivityResult.none) {
        // Device is offline initially.
        _isOnline = false;
        notifyListeners();
      } else {
        // Device is online initially.
        _isOnline = true;
        notifyListeners();
      }
    } catch (e) {
      // Log and handle any exceptions that may occur during the process.
      debugPrint(e.toString());
    }
  }

  // Checks and updates the connection status by attempting to reach 'www.google.com'.
  Future<bool> _updateConnectionStatus() async {
    try {
      List<InternetAddress> result =
          await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // The device is successfully connected to the internet.
        return true;
      } else {
        // The device is not connected to the internet.
        return false;
      }
    } catch (e) {
      // Log and handle any exceptions that may occur during the process.
      debugPrint(e.toString());
      return false;
    }
  }
}
