import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/data_providers.dart';
import '../../core/themes/colors.dart';
import '../../core/widgets/cards/error_card.dart';
import '../../core/widgets/cards/loading_card.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(multiMintWalletBalanceStreamProvider);

    return switch (balanceAsync) {
      AsyncData(:final value) => _buildWidget(
          context,
          balance: value,
        ),
      AsyncError(:final error) => ErrorCard(
          message: context.l10n.currentMintCardErrorLoadingMintData,
          details: error.toString(),
          onRetry: () => ref.refresh(multiMintWalletBalanceStreamProvider),
        ),
      _ => const LoadingCard(),
    };
  }

  Container _buildWidget(
    BuildContext context, {
    required BigInt balance,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fadedTextColor = context.colorScheme.onSurface.withAlpha(178);
    final textColor = context.colorScheme.onSurface;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.colorScheme.surfaceContainerHighest,
            context.colorScheme.surfaceContainerHighest.withAlpha(204),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withAlpha(51) // 0.2 * 255 = 51
              : AppColors.black.withAlpha(51),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.walletScreenCurrentBalance,
            style: context.textTheme.bodyMedium?.copyWith(
              color: fadedTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                balance.toString(),
                style: context.textTheme.headlineLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'sats',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: fadedTextColor,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
