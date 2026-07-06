import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Stream<bool> get connectivityStream;
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity connectivity;

  ConnectivityServiceImpl(this.connectivity);

  @override
  Stream<bool> get connectivityStream {
    return connectivity.onConnectivityChanged.map(
      (results) => results.any(
        (result) => result != ConnectivityResult.none,
      ),
    );
  }
}