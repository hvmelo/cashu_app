import 'package:cashu_app/core/core_providers.dart';
import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provides the shell for the app with bottom navigation
class NavigationShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationShell({
    super.key,
    required this.navigationShell,
  });

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightMode = ref.watch(themeNotifierProvider) == ThemeMode.light;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: context.colorScheme.outlineVariant,
            ),
          ),
          boxShadow: [
            if (isLightMode)
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 5,
                spreadRadius: 0,
                offset: const Offset(0, -3),
              ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
          backgroundColor: context.colorScheme.surface,
          indicatorColor: context.colorScheme.surfaceContainerHighest,
          elevation: 1,
          shadowColor: context.colorScheme.shadow,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            _buildNavigationDestination(
              context,
              Icons.account_balance_wallet_outlined,
              Icons.account_balance_wallet,
              context.l10n.navBarWallet,
            ),
            _buildNavigationDestination(
              context,
              Icons.account_balance_outlined,
              Icons.account_balance,
              context.l10n.navBarMints,
            ),
            _buildNavigationDestination(
              context,
              Icons.history_outlined,
              Icons.history,
              context.l10n.navBarHistory,
            ),
            _buildNavigationDestination(
              context,
              Icons.settings_outlined,
              Icons.settings,
              context.l10n.navBarSettings,
            ),
          ],
        ),
      ),
    );
  }

  NavigationDestination _buildNavigationDestination(
    BuildContext context,
    IconData unselectedIcon,
    IconData selectedIcon,
    String label,
  ) {
    return NavigationDestination(
      icon: Icon(
        unselectedIcon,
        color: context.colorScheme.onSurfaceVariant,
      ),
      selectedIcon: Icon(
        selectedIcon,
        color: context.colorScheme.onSurface,
      ),
      label: label,
    );
  }
}
