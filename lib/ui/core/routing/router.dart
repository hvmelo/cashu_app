import 'package:cashu_app/ui/core/navigation/navigation_shell.dart';
import 'package:cashu_app/ui/wallet/widgets/wallet_screen.dart';
import 'package:cashu_app/ui/mint/widgets/mint_screen.dart';
import 'package:cashu_app/ui/mint_manager/widgets/mint_manager_screen.dart';
import 'package:cashu_app/ui/settings/settings_screen.dart';
import 'package:cashu_app/ui/history/transaction_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final walletNavigatorKey = GlobalKey<NavigatorState>();
final mintManagerNavigatorKey = GlobalKey<NavigatorState>();
final transactionHistoryNavigatorKey = GlobalKey<NavigatorState>();
final settingsNavigatorKey = GlobalKey<NavigatorState>();

/// Top go_router entry point.
GoRouter router() => GoRouter(
      initialLocation: Routes.home,
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: [
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, shell) => CustomTransitionPage(
            key: state.pageKey,
            child: NavigationShell(navigationShell: shell),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
          branches: [
            StatefulShellBranch(
              navigatorKey: walletNavigatorKey,
              routes: [
                GoRoute(
                  path: Routes.home,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const WalletScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            _buildFadeInTransition(animation, child),
                  ),
                  routes: [
                    GoRoute(
                      path: Routes.mint,
                      pageBuilder: (context, state) => CustomTransitionPage(
                        child: const MintScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                _buildSlideLeftTransition(animation, child),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: mintManagerNavigatorKey,
              routes: [
                GoRoute(
                  path: Routes.manageMints,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const MintManagerScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            _buildFadeInTransition(animation, child),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: transactionHistoryNavigatorKey,
              routes: [
                GoRoute(
                  path: Routes.transactionHistory,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const TransactionHistoryScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            _buildFadeInTransition(animation, child),
                  ),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: settingsNavigatorKey,
              routes: [
                GoRoute(
                  path: Routes.settings,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    child: const SettingsScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) =>
                            _buildFadeInTransition(animation, child),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );

SlideTransition _buildSlideLeftTransition(
    Animation<double> animation, Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(animation),
    child: child,
  );
}

FadeTransition _buildFadeInTransition(
    Animation<double> animation, Widget child) {
  return FadeTransition(
    opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
    child: child,
  );
}
