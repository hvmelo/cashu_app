import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:cashu_app/utils/result.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cashu_providers.g.dart';

@riverpod
MultiMintWallet? multiMintWallet(Ref ref) {
  return null;
}

@riverpod
Stream<BigInt> multiWalletBalanceStream(Ref ref) {
  final multiWalletAsync = ref.watch(multiMintWalletProvider);
  if (multiWalletAsync == null) {
    throw Exception('MultiWallet not found');
  }
  return multiWalletAsync.streamBalance();
}

@riverpod
Future<List<Mint>> availableMints(Ref ref) async {
  final multiWallet = ref.watch(multiMintWalletProvider);
  if (multiWallet == null) {
    throw Exception('MultiWallet not found');
  }
  return multiWallet.listMints();
}

@riverpod
Future<Wallet> wallet(Ref ref, String mintUrl) async {
  final multiWallet = ref.watch(multiMintWalletProvider);
  if (multiWallet == null) {
    throw Exception('MultiWallet not found');
  }
  final wallet = await multiWallet.createOrGetWallet(mintUrl: mintUrl);
  return wallet;
}

// @riverpod
// Stream<Result<BigInt>> walletBalanceStream(Ref ref, String mintUrl) {
//   final walletAsync = ref.watch(walletProvider(mintUrl));
//   return walletAsync.when(
//     data: (wallet) {
//       if (wallet == null) {
//         return Stream.value(
//             Result.error('Wallet not found', stackTrace: StackTrace.current));
//       }
//       return wallet.streamBalance().map((balance) => Result.ok(balance));
//     },
//     error: (error, stack) =>
//         Stream.value(Result.error(error, stackTrace: stack)),
//     loading: () => Stream.empty(),
//   );
// }

// Provider for the mint stream
@riverpod
Stream<Result<MintQuote>> mintQuoteStream(
  Ref ref,
  String mintUrl,
  BigInt amount,
) {
  final walletAsync = ref.watch(walletProvider(mintUrl));
  return walletAsync.when(
    data: (wallet) {
      return wallet.mint(amount: amount).map((quote) => Result.ok(quote));
    },
    error: (error, stack) => Stream.value(Result.error(
      error,
      stackTrace: stack,
    )),
    loading: () => Stream.empty(),
  );
}
