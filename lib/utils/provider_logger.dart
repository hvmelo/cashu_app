// ignore_for_file: avoid_print

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

class ProviderLogger extends ProviderObserver {
  final bool logAll = true;
  final log = Logger('ProviderLogger');
  ProviderLogger();

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (logAll) {
      log.info('[🚀] Initialized: ${provider.name}');
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    if (logAll) {
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
    if (logAll) {
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
    log.severe('[❌] Provider ${provider.name} threw $error at $stackTrace');
  }
}
