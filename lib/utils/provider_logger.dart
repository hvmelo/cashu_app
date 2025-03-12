// ignore_for_file: avoid_print

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

class ProviderLogger extends ProviderObserver {
  final bool logAdded;
  final bool logDisposed;
  final bool logUpdated;
  final bool logFailed;
  final log = Logger('ProviderLogger');

  ProviderLogger({
    this.logAdded = true,
    this.logDisposed = true,
    this.logUpdated = false,
    this.logFailed = true,
  });

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (logAdded) {
      log.info('[🚀] Initialized: ${provider.name}');
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    if (logDisposed) {
      log.info('[🗑️] Disposed: ${provider.name}');
    }
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (logUpdated) {
      log.info(
          '[🔄] Updated: ${provider.name}: Old: ${previousValue?.toString()} New: ${newValue?.toString()}');
    }
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    if (logFailed) {
      log.severe('[❌] Provider ${provider.name} threw $error at $stackTrace');
    }
  }
}
