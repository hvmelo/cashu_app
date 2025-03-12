import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/mint_wrapper.dart';
import '../../../utils/url_utils.dart';
import '../../core/themes/colors.dart';
import '../../core/widgets/balance_chip.dart';

class MintCard extends StatelessWidget {
  final MintWrapper mint;
  final bool isCurrentMint;
  final VoidCallback onTap;
  final VoidCallback onOptionsPressed;

  const MintCard({
    super.key,
    required this.mint,
    required this.isCurrentMint,
    required this.onTap,
    required this.onOptionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final mintName = mint.nickName ?? UrlUtils.extractHost(mint.mint.url);
    final mintUrl = mint.mint.url;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with icon, name and status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mint icon
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

                // Mint name and status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              mintName,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isCurrentMint
                                    ? AppColors.actionColors['mint']
                                    : context.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrentMint)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.actionColors['mint']!
                                    .withAlpha(25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Current',
                                style: context.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.actionColors['mint'],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Full URL
                      Text(
                        mintUrl,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Balance chip (bottom row)
                      BalanceChip(
                        mintUrl: mint.mint.url,
                        isCurrentMint: isCurrentMint,
                      ),
                    ],
                  ),
                ),

                // Action button
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: onOptionsPressed,
                  tooltip: 'More options',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
