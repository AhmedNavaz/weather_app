import 'package:connectivity_plus/connectivity_plus.dart';

// An abstract class defining the contract for checking network connectivity.
abstract class NetworkInfo {
  Future<bool>? get isConnected;
}

// A concrete implementation of the NetworkInfo abstract class.
class NetworkInfoImpl implements NetworkInfo {
  // Connectivity instance used for checking network status.
  final Connectivity connectionChecker;

  NetworkInfoImpl({required this.connectionChecker});

  // Implementation of the isConnected getter method defined in the abstract class.
  @override
  Future<bool>? get isConnected async {
    // Check the current connectivity status.
    final connectivityResult = await connectionChecker.checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}
