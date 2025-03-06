import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider global para o Wallet
final walletProvider = StateProvider<Wallet?>((ref) => null);

// Provider para o saldo do wallet que depende do walletProvider
final walletBalanceProvider = FutureProvider<BigInt>((ref) async {
  final wallet = ref.watch(walletProvider);
  if (wallet == null) {
    throw Exception('Wallet is not initialized');
  }
  return wallet.balance();
});

// Provider para a URL do mint
final mintUrlProvider = Provider<String>((ref) {
  final wallet = ref.watch(walletProvider);
  if (wallet == null) {
    return 'Not connected';
  }
  return wallet.mintUrl;
});

// Provider para verificar se o wallet está pronto
final isWalletReadyProvider = Provider<bool>((ref) {
  return ref.watch(walletProvider) != null;
});

// Provider para gerenciar o tema do aplicativo
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// Notifier para controlar o tema
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}
