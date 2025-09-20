import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  Future<bool> get isConnected async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
