import 'package:cashu_app/ui/core/widgets/current_mint_card.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../core/themes/colors.dart';
import 'widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
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
      backgroundColor: context.colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement QR scan
        },
        backgroundColor: AppColors.actionColors['scan'],
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: AppColors.white,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                BalanceCard(),
                const SizedBox(height: 16),
                _buildActionGrid(context),
                const SizedBox(height: 24),
                const CurrentMintCard(),
                const SizedBox(height: 16),
                const RecentTransactionsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        // Send Button
        ActionCard(
          icon: Icons.arrow_upward_rounded,
          title: context.l10n.homeScreenEcashSend,
          subtitle: context.l10n.homeScreenEcashSendSubtitle,
          color: AppColors.actionColors['send']!,
          onTap: () {
            // TODO: Navigate to send screen
          },
        ),

        // Receive Button
        ActionCard(
          icon: Icons.arrow_downward_rounded,
          title: context.l10n.homeScreenEcashReceive,
          subtitle: context.l10n.homeScreenEcashReceiveSubtitle,
          color: AppColors.actionColors['receive']!,
          onTap: () {
            // TODO: Navigate to receive screen
          },
        ),

        // Mint Button
        ActionCard(
          icon: Icons.local_atm_rounded,
          title: context.l10n.homeScreenMintEcash,
          subtitle: context.l10n.homeScreenMintEcashSubtitle,
          color: AppColors.actionColors['mint']!,
          onTap: () {
            context.go(Routes.mint);
          },
        ),

        // Melt Button
        ActionCard(
          icon: Icons.currency_bitcoin,
          title: context.l10n.homeScreenEcashMelt,
          subtitle: context.l10n.homeScreenEcashMeltSubtitle,
          color: AppColors.actionColors['melt']!,
          onTap: () {
            // TODO: Navigate to melt screen
          },
        ),
      ],
    );
  }
}
