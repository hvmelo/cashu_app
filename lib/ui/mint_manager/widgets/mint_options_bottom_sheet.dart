import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/mint.dart';

/// Bottom sheet for mint options
class MintOptionsBottomSheet extends StatelessWidget {
  final Mint mint;
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
    final mintName = mint.nickName?.value ?? mint.url.extractAuthority();

    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Compact header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    mintName,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),

          // Options as compact list items
          if (!isCurrentMint)
            _buildOptionItem(
              context,
              icon: Icons.check_circle_outline,
              label: 'Set as Current',
              onTap: onSetAsCurrent,
            ),

          _buildOptionItem(
            context,
            icon: Icons.drive_file_rename_outline,
            label: 'Edit',
            onTap: onEdit,
          ),

          if (!isCurrentMint)
            _buildOptionItem(
              context,
              icon: Icons.delete_outline,
              label: 'Delete',
              onTap: onDelete,
              isDestructive: true,
            ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? context.colorScheme.error
        : context.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
