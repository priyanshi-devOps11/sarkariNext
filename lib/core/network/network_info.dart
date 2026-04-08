import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple connectivity check — upgrade to connectivity_plus later if needed
final networkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    // Basic implementation — always returns true for now
    // Replace with connectivity_plus package check later
    return true;
  }
}