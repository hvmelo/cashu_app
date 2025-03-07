import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

// Global provider for the Wallet
@riverpod
Wallet? wallet(Ref ref) {
  return null;
}

// Provider for the wallet balance
@riverpod
Stream<BigInt> walletBalanceStream(Ref ref) {
  final wallet = ref.watch(walletProvider);
  if (wallet == null) {
    throw Exception('Wallet is not initialized');
  }
  return wallet.streamBalance();
}

// Provider for the mint URL
@riverpod
String? mintUrl(Ref ref) {
  final wallet = ref.watch(walletProvider);
  if (wallet == null) {
    return null;
  }
  return wallet.mintUrl;
}

// Provider for the mint stream
@riverpod
Stream<MintQuote> mintQuoteStream(Ref ref, BigInt amount) {
  final wallet = ref.watch(walletProvider);
  if (wallet == null) {
    throw Exception('Wallet is not initialized');
  }
  return wallet.mint(amount: amount);
}

// Provider to check if the wallet is ready
@riverpod
bool isWalletReady(Ref ref) {
  return ref.watch(walletProvider) != null;
}

// Notifier to control the app theme
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}
