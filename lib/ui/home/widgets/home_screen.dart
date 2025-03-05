import 'package:cashu_app/config/providers.dart';
import 'package:cashu_app/ui/home/widgets/balance_card.dart';
import 'package:cashu_app/ui/home/widgets/mint_info_card.dart';
import 'package:cashu_app/ui/home/widgets/recent_transactions/recent_transactions_widget.dart';
import 'package:cashu_app/ui/home/widgets/wallet_drawer.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cashu_app/ui/core/themes/colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);
    final balanceAsync = ref.watch(walletBalanceProvider);

    return Scaffold(
      appBar: AppBar(
        //title: Text(context.l10n.homeScreenTitle),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      drawer: WalletDrawer(wallet: walletAsync),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.colorScheme.surface,
                Color.alphaBlend(
                  context.colorScheme.surface.withAlpha(204), // 0.8 * 255 = 204
                  context.colorScheme.surface,
                ),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                BalanceCard(balanceAsync: balanceAsync),
                const SizedBox(height: 24),
                _buildActionButtons(context),
                const SizedBox(height: 24),
                MintInfoCard(wallet: walletAsync),
                const SizedBox(height: 24),
                const Expanded(
                  child: RecentTransactionsWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          icon: Icons.arrow_upward_rounded,
          label: context.l10n.homeScreenSend,
          onTap: () {
            // TODO: Implement send
          },
          color: AppColors.actionColors['send']!,
        ),
        _buildActionButton(
          context,
          icon: Icons.arrow_downward_rounded,
          label: context.l10n.homeScreenReceive,
          onTap: () {
            // TODO: Implement receive
          },
          color: AppColors.actionColors['receive']!,
        ),
        _buildActionButton(
          context,
          icon: Icons.qr_code_scanner_rounded,
          label: context.l10n.homeScreenScan,
          onTap: () {
            // TODO: Implement QR scan
          },
          color: AppColors.actionColors['scan']!,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withAlpha(26), // 0.1 * 255 = 26
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(51), // 0.2 * 255 = 51
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
