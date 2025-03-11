import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/core_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeNotifierProvider);
    final isDarkMode = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settingsScreenTitle),
        elevation: 0,
      ),
      backgroundColor: context.colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildSection(
              context,
              context.l10n.settingsScreenAppearanceTitle,
              [
                SwitchListTile(
                  secondary: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  ),
                  title: Text(isDarkMode ? 'Dark Mode' : 'Light Mode'),
                  value: isDarkMode,
                  onChanged: (value) {
                    ref.read(themeNotifierProvider.notifier).setThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light,
                        );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              context.l10n.settingsScreenAboutTitle,
              [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text('About'),
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: Text(context.l10n.settingsScreenVersionTitle),
                  subtitle: const Text('1.0.0'), // TODO: Get from package info
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/cashu_logo.png',
            height: 80,
            errorBuilder: (context, error, stackTrace) => const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white24,
              child: Icon(
                Icons.account_balance_wallet,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Cashu Wallet',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'eCash for everyone',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AboutDialog(
        applicationName: 'Cashu Wallet',
        applicationVersion: '1.0.0', // TODO: Get from package info
        applicationIcon: Image.asset(
          'assets/images/cashu_logo.png',
          height: 50,
        ),
        applicationLegalese: '© 2023 Cashu Wallet',
        children: [
          const SizedBox(height: 16),
          Text(
            'eCash for everyone',
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Cashu is a privacy-focused ecash protocol for Bitcoin that enables private transactions, offline payments, and Lightning Network integration.',
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
