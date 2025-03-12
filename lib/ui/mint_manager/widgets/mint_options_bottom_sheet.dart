import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/mint_wrapper.dart';
import '../../../utils/url_utils.dart';
import '../../core/themes/colors.dart';

/// Bottom sheet for mint options
class MintOptionsBottomSheet extends StatelessWidget {
  final MintWrapper mint;
  final bool isCurrentMint;
  final VoidCallback? onSetAsCurrent;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const MintOptionsBottomSheet({
    super.key,
    required this.mint,
    required this.isCurrentMint,
    this.onSetAsCurrent,
    required this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final mintName = mint.nickName ?? UrlUtils.extractHost(mint.mint.url);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
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
                  child: Text(
                    mintName,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isCurrentMint
                          ? AppColors.actionColors['mint']
                          : context.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          if (!isCurrentMint) ...[
            ListTile(
              onTap: onSetAsCurrent,
              leading: Icon(
                Icons.check_circle_outline,
                color: AppColors.actionColors['mint'],
              ),
              title: Text(
                'Set as Current',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.actionColors['mint'],
                ),
              ),
            ),
          ],
          ListTile(
            onTap: onEdit,
            leading: Icon(
              Icons.edit_outlined,
              color: context.colorScheme.onSurface,
            ),
            title: Text(
              'Edit',
              style: context.textTheme.bodyMedium,
            ),
          ),
          if (!isCurrentMint) ...[
            ListTile(
              onTap: onDelete,
              leading: Icon(
                Icons.delete_outline,
                color: context.colorScheme.error,
              ),
              title: Text(
                'Delete',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
