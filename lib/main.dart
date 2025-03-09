import 'package:cashu_app/config/app_providers.dart';
import 'package:cashu_app/ui/core/l10n/gen_l10n/app_localizations.dart';
import 'package:cashu_app/ui/core/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'main_development.dart' as development;
import 'routing/router.dart';

/// Default main method
Future<void> main() async {
  // Launch development config by default
  await development.main();
}

class MainApp extends ConsumerWidget {
  MainApp({super.key});

  final GoRouter _router = router();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
