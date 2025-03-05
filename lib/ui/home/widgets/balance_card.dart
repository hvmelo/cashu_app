import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BalanceCard extends StatelessWidget {
  final AsyncValue<BigInt> balanceAsync;

  const BalanceCard({
    super.key,
    required this.balanceAsync,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : context.colorScheme.onPrimary;
    final fadedTextColor = isDarkMode
        ? Colors.white.withAlpha(178) // 0.7 * 255 = 178
        : context.colorScheme.onPrimary.withAlpha(178);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  AppColors.black,
                  Color(0xFF1A1A1A), // Slightly lighter black
                ]
              : [
                  context.colorScheme.primary,
                  context.colorScheme.primary.withAlpha(204), // 0.8 * 255 = 204
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: isDarkMode
            ? Border.all(
                color: Colors.white.withAlpha(51), // 0.2 * 255 = 51
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? AppColors.blackTransparent
                : context.colorScheme.primary.withAlpha(76), // 0.3 * 255 = 76
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Balance',
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
