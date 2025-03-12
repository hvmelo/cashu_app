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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isCurrentMint
                          ? AppColors.actionColors['mint']!.withAlpha(39)
                          : context.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.account_balance,
                      color: isCurrentMint
                          ? AppColors.actionColors['mint']
                          : context.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mint.nickName ??
                              mint.mint.info?.name ??
                              UrlUtils.extractHost(mint.mint.url),
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          mint.mint.url,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurface.withAlpha(153),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            if (onSetAsCurrent != null)
              _buildOptionTile(
                context,
                Icons.check_circle_outline,
                context.l10n.mintManagerScreenSetAsCurrentButton,
                AppColors.actionColors['mint']!,
                onSetAsCurrent,
              ),
            _buildOptionTile(
              context,
              Icons.edit_outlined,
              context.l10n.mintManagerScreenEditButton,
              context.colorScheme.primary,
              onEdit,
            ),
            if (onDelete != null)
              _buildOptionTile(
                context,
                Icons.delete_outline,
                context.l10n.mintManagerScreenDeleteButton,
                AppColors.red,
                onDelete,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          color: color == AppColors.red ? color : null,
        ),
      ),
      onTap: onTap,
    );
  }
}
