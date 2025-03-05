import 'package:cashu_app/config/providers.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WalletDrawer extends ConsumerWidget {
  final Wallet? wallet;

  const WalletDrawer({
    super.key,
    required this.wallet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);
    final isDarkMode = currentThemeMode == ThemeMode.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/cashu_logo.png',
                  height: 60,
                  errorBuilder: (context, error, stackTrace) =>
                      const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(
                      Icons.account_balance_wallet,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Cashu Wallet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
                Text(
                  'Ecash for everyone',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            selected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_outlined),
            title: const Text('Transaction History'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to transaction history
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to settings
            },
          ),
          const Divider(),
          SwitchListTile(
            secondary: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            title: Text(isDarkMode ? 'Dark Mode' : 'Light Mode'),
            value: isDarkMode,
            onChanged: (value) {
              ref.read(themeProvider.notifier).setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to about
            },
          ),
        ],
      ),
    );
  }
}
