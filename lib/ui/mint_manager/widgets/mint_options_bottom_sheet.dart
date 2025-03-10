import 'package:cashu_app/domain/models/user_mint.dart';
import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:cashu_app/utils/url_utils.dart';
import 'package:flutter/material.dart';

/// Bottom sheet for mint options
class MintOptionsBottomSheet extends StatelessWidget {
  final UserMint mint;
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
                          ? AppColors.actionColors['mint']!.withOpacity(0.15)
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
                          mint.nickName ?? UrlUtils.extractHost(mint.url),
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          mint.url,
                          style: context.textTheme.bodySmall?.copyWith(
                            color:
                                context.colorScheme.onSurface.withOpacity(0.6),
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
                context.l10n.manageMintScreenSetAsCurrentButton,
                AppColors.actionColors['mint']!,
                onSetAsCurrent,
              ),
            _buildOptionTile(
              context,
              Icons.edit_outlined,
              context.l10n.manageMintScreenEditButton,
              context.colorScheme.primary,
              onEdit,
            ),
            if (onDelete != null)
              _buildOptionTile(
                context,
                Icons.delete_outline,
                context.l10n.manageMintScreenDeleteButton,
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
          color: color.withOpacity(0.1),
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
