import 'package:cashu_app/config/providers.dart';
import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(walletBalanceProvider);

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = context.colorScheme.onSurface;
    final fadedTextColor = context.colorScheme.onSurface.withAlpha(178);

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
            context.l10n.homeScreenCurrentBalance,
            style: context.textTheme.bodyMedium?.copyWith(
              color: fadedTextColor,
            ),
          ),
          const SizedBox(height: 8),
          balanceAsync.when(
            data: (balance) => Row(
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
            ),
            loading: () => CircularProgressIndicator(
              color: textColor,
            ),
            error: (error, stack) => Text(
              'Error loading balance',
              style: context.textTheme.bodyLarge?.copyWith(
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
