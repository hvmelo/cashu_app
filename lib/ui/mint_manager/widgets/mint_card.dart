import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/mint.dart';
import '../../core/themes/colors.dart';
import '../../core/widgets/balance_chip.dart';

class MintCard extends StatelessWidget {
  final Mint mint;
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mint icon
            _buildMintIcon(context),
            const SizedBox(width: 16),

            // Mint name, status and balance
            Expanded(
              child: _buildCardContent(
                context,
                mint: mint,
              ),
            ),

            // Action button
            _buildOptionsMenuIcon(),
          ],
        ),
      ),
    );
  }

  Widget _buildMintIcon(BuildContext context) {
    return Container(
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
    );
  }

  Widget _buildCardContent(
    BuildContext context, {
    required Mint mint,
  }) {
    final mintName = mint.nickName?.value ?? mint.url.extractAuthority();

    return Column(
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.actionColors['mint']!.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  context.l10n.mintManagerScreenMintMintCardCurrentLabel,
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
          mint.url.value,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        // Balance chip
        BalanceChip(
          mintUrl: mint.url,
          isCurrentMint: isCurrentMint,
        ),
      ],
    );
  }

  Widget _buildOptionsMenuIcon() {
    return IconButton(
      icon: const Icon(Icons.more_vert, size: 20),
      onPressed: onOptionsPressed,
    );
  }
}
