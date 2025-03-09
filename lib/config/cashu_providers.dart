import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:cashu_app/utils/result.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cashu_providers.g.dart';

// Global variable to track database instance
WalletDatabase? _globalDbInstance;

// Function to close any existing database
Future<void> closeExistingDatabase() async {
  if (_globalDbInstance != null) {
    try {
      print('Closing existing database connection');
      _globalDbInstance!.dispose();
      _globalDbInstance = null;
    } catch (e) {
      print('Error closing database: $e');
    }
  }
}

@Riverpod(keepAlive: true)
Future<String> seed(Ref ref) async {
  final path = await getApplicationDocumentsDirectory();
  final seedFile = File('${path.path}/seed.txt');
  String seed;
  if (await seedFile.exists()) {
    seed = await seedFile.readAsString();
  } else {
    seed = generateHexSeed();
    await seedFile.writeAsString(seed);
  }
  return seed;
}

@Riverpod(keepAlive: true)
Future<WalletDatabase> walletDatabase(Ref ref) async {
  final path = await getApplicationDocumentsDirectory();
  final dbPath = '${path.path}/wallet.db';

  // Close any existing database first
  await closeExistingDatabase();

  // Create a new database instance
  try {
    print('Opening database at $dbPath');
    final db = WalletDatabase(path: dbPath);
    _globalDbInstance = db;

    // Register a lifecycle observer
    final observer = _DatabaseLifecycleObserver(db);

    return db;
  } catch (e) {
    print('Error opening database: $e');
    // Wait a moment and try again
    await Future.delayed(Duration(milliseconds: 500));
    final db = WalletDatabase(path: dbPath);
    _globalDbInstance = db;
    return db;
  }
}

@Riverpod(keepAlive: true)
Future<MultiMintWallet> multiWallet(Ref ref) async {
  final seed = await ref.watch(seedProvider.future);
  final walletDatabase = await ref.watch(walletDatabaseProvider.future);
  return MultiMintWallet.newFromHexSeed(
    unit: 'sat',
    seed: seed,
    localstore: walletDatabase,
  );
}

@Riverpod(keepAlive: true)
Stream<BigInt> multiWalletBalanceStream(Ref ref) {
  final log = Logger('MultiWalletBalanceStream');

  final multiWalletAsync = ref.watch(multiWalletProvider);
  return multiWalletAsync.when(
    data: (multiWallet) => multiWallet.streamBalance(),
    error: (error, stack) {
      log.severe('Error: $error', error, stack);
      return Stream.value(BigInt.zero);
    },
    loading: () => Stream.value(BigInt.zero),
  );
}

@Riverpod(keepAlive: true)
Future<List<Mint>> availableMints(Ref ref) async {
  final multiWallet = await ref.watch(multiWalletProvider.future);
  return multiWallet.listMints();
}

@Riverpod(keepAlive: true)
Future<Wallet?> wallet(Ref ref, String mintUrl) async {
  final multiWallet = await ref.watch(multiWalletProvider.future);

  final wallet = await multiWallet.getWallet(mintUrl: mintUrl);
  if (wallet == null) {
    final wallet = await multiWallet.createOrGetWallet(mintUrl: mintUrl);
    return wallet;
  }
  return wallet;
}

@Riverpod(keepAlive: true)
Stream<Result<BigInt>> walletBalanceStream(Ref ref, String mintUrl) {
  final walletAsync = ref.watch(walletProvider(mintUrl));
  return walletAsync.when(
    data: (wallet) {
      if (wallet == null) {
        return Stream.value(
            Result.error('Wallet not found', stackTrace: StackTrace.current));
      }
      return wallet.streamBalance().map((balance) => Result.ok(balance));
    },
    error: (error, stack) =>
        Stream.value(Result.error(error, stackTrace: stack)),
    loading: () => Stream.empty(),
  );
}

// Provider for the mint stream
@Riverpod(keepAlive: true)
Stream<Result<MintQuote>> mintQuoteStream(
  Ref ref,
  String mintUrl,
  BigInt amount,
) {
  final walletAsync = ref.watch(walletProvider(mintUrl));
  return walletAsync.when(
    data: (wallet) {
      if (wallet == null) {
        return Stream.value(Result.error(
          'Wallet not found',
          stackTrace: StackTrace.current,
        ));
      }
      return wallet.mint(amount: amount).map((quote) => Result.ok(quote));
    },
    error: (error, stack) => Stream.value(Result.error(
      error,
      stackTrace: stack,
    )),
    loading: () => Stream.empty(),
  );
}

// Lifecycle observer class
class _DatabaseLifecycleObserver with WidgetsBindingObserver {
  final WalletDatabase db;
  bool _isObserving = false;

  _DatabaseLifecycleObserver(this.db) {
    _startObserving();
  }

  void _startObserving() {
    if (!_isObserving) {
      WidgetsBinding.instance.addObserver(this);
      _isObserving = true;
      print('Started observing app lifecycle for database');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('App lifecycle state changed to: $state');
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      try {
        print('Closing database due to app lifecycle change');
        db.dispose();
      } catch (e) {
        print('Error closing database: $e');
      }
    }
  }

  void dispose() {
    if (_isObserving) {
      WidgetsBinding.instance.removeObserver(this);
      _isObserving = false;
    }
  }
}
