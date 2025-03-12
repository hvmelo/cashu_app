import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'config/app_config.dart';
import 'core/core_providers.dart';
import 'main_development.dart' as development;
import 'ui/core/routing/router.dart';
import 'ui/core/l10n/gen_l10n/app_localizations.dart';
import 'ui/core/themes/theme.dart';
import 'ui/core/widgets/environment_banner.dart';

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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _router,
      builder: (context, child) {
        return EnvironmentBanner(child: child!);
      },
    );
  }
}
