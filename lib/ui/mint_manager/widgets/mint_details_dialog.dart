import 'package:cashu_app/ui/core/themes/colors.dart' show AppColors;
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/data_providers.dart';
import '../../../core/types/result.dart';
import '../../../domain/models/mint_wrapper.dart';
import '../../../utils/url_utils.dart';
import '../../core/widgets/balance_chip.dart';

/// Dialog for displaying mint details
class MintDetailsDialog extends ConsumerWidget {
  final MintWrapper mint;
  final bool isCurrentMint;

  const MintDetailsDialog({
    super.key,
    required this.mint,
    required this.isCurrentMint,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(mintBalanceStreamProvider(mint.mint.url));
    final mintName = mint.nickName ?? UrlUtils.extractHost(mint.mint.url);

    final balance = switch (balanceAsync) {
      AsyncData(:final value) => switch (value) {
          Ok(:final value) => value,
          Error() => null,
        },
      _ => null,
    };

    return Dialog(
      backgroundColor: context.colorScheme.surfaceContainerHighest,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with mint name and icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isCurrentMint
                        ? AppColors.actionColors['mint']!.withAlpha(30)
                        : context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.account_balance_rounded,
                    color: isCurrentMint
                        ? AppColors.actionColors['mint']
                        : context.colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mintName,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCurrentMint
                              ? AppColors.actionColors['mint']
                              : context.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (balance != null)
                        BalanceChip(
                          mintUrl: mint.mint.url,
                          isCurrentMint: isCurrentMint,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // URL section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.colorScheme.outlineVariant.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'URL',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mint.mint.url,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.copy_rounded,
                          size: 18,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: mint.mint.url));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('URL copied to clipboard'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        visualDensity: VisualDensity.compact,
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(32, 32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Nickname section (if available)
            if (mint.nickName != null) ...[
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.colorScheme.outlineVariant.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nickname',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mint.nickName!,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Close button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.actionColors['mint'],
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
