import 'package:cashu_app/utils/result.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cashu_providers.g.dart';

@riverpod
MultiMintWallet? multiMintWallet(Ref ref) {
  return null;
}

@riverpod
Stream<BigInt> multiMintWalletBalanceStream(Ref ref) {
  final multiWalletAsync = ref.watch(multiMintWalletProvider);
  if (multiWalletAsync == null) {
    throw Exception('MultiMintWallet not found');
  }
  return multiWalletAsync.streamBalance();
}

@riverpod
Future<List<Mint>> listWalletMints(Ref ref) async {
  final multiMintWallet = ref.watch(multiMintWalletProvider);
  if (multiMintWallet == null) {
    throw Exception('MultiMintWallet not found');
  }
  return multiMintWallet.listMints();
}

@riverpod
Future<Wallet> getWallet(Ref ref, String mintUrl) async {
  final multiMintWallet = ref.watch(multiMintWalletProvider);
  if (multiMintWallet == null) {
    throw Exception('MultiMintWallet not found');
  }
  final wallet = await multiMintWallet.createOrGetWallet(mintUrl: mintUrl);
  return wallet;
}

@riverpod
Stream<Result<BigInt>> getWalletBalance(Ref ref, String mintUrl) {
  final walletAsync = ref.watch(getWalletProvider(mintUrl));
  return walletAsync.when(
    data: (wallet) {
      return wallet.streamBalance().map((balance) => Result.ok(balance));
    },
    error: (error, stack) => Stream.value(Result.error(
      error,
      stackTrace: stack,
    )),
    loading: () => Stream.empty(),
  );
}

// Provider for the mint stream
@riverpod
Stream<Result<MintQuote>> mintQuoteStream(
  Ref ref,
  String mintUrl,
  BigInt amount,
) {
  final walletAsync = ref.watch(getWalletProvider(mintUrl));
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
