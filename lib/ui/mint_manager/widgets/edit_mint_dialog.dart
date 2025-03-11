import 'package:cashu_app/utils/url_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/models/mint_wrapper.dart';
import '../../core/widgets/widgets.dart';
import '../../utils/extensions/build_context_x.dart';
import '../notifiers/edit_mint_notifier.dart';

/// A dialog for editing a mint's details
class EditMintDialog extends ConsumerWidget {
  /// Creates an [EditMintDialog].
  ///
  /// The [mint] parameter is required and specifies the mint to edit.
  const EditMintDialog({
    super.key,
    required this.mint,
    required this.isCurrentMint,
    this.onSaved,
    this.onDeleted,
  });

  /// The mint to edit
  final MintWrapper mint;

  /// Whether this mint is the current mint
  final bool isCurrentMint;

  /// Callback called when the mint is saved
  final VoidCallback? onSaved;

  /// Callback called when the mint is deleted
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editMintState = ref.watch(editMintNotifierProvider(mint));
    final notifier = ref.watch(editMintNotifierProvider(mint).notifier);

    // Handle success state
    ref.listen<EditMintState>(
      editMintNotifierProvider(mint),
      (previous, current) {
        if (!previous!.isSuccess && current.isSuccess) {
          // Show success message
          AppSnackBar.showSuccess(
            context,
            message: context.l10n.editMintDialogMintUpdated,
          );

          // Call the appropriate callback
          if (onSaved != null) {
            onSaved!();
          }

          // Close the dialog
          context.pop();
        }
      },
    );

    return Dialog(
      backgroundColor: context.colorScheme.surface,
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
            Text(
              context.l10n.editMintDialogTitle,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Mint URL (read-only)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.editMintDialogUrlLabel,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    mint.mint.url,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Nickname field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.editMintDialogNicknameLabel,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: context.l10n.editMintDialogNicknameHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                  ),
                  controller:
                      TextEditingController(text: editMintState.nickname),
                  onChanged: notifier.nicknameChanged,
                ),
              ],
            ),
            if (editMintState.error != null) ...[
              const SizedBox(height: 16),
              Text(
                editMintState.error!.message,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Set as current mint button (only if not already current)
                if (!isCurrentMint)
                  TextButton.icon(
                    onPressed: editMintState.isSubmitting
                        ? null
                        : notifier.setAsCurrentMint,
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(
                      context.l10n.editMintDialogSetAsCurrentButton,
                    ),
                  )
                else
                  const SizedBox(),
                // Delete button (only if not current)
                if (!isCurrentMint)
                  TextButton.icon(
                    onPressed: editMintState.isSubmitting
                        ? null
                        : () => _showDeleteConfirmation(context, notifier),
                    icon: const Icon(Icons.delete_outline),
                    label: Text(
                      context.l10n.generalDeleteButtonLabel,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: context.colorScheme.error,
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel button
                TextButton(
                  onPressed: editMintState.isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(context.l10n.generalCancelButtonLabel),
                ),
                const SizedBox(width: 16),
                // Save button
                ElevatedButton(
                  onPressed:
                      editMintState.isSubmitting ? null : notifier.saveMint,
                  child: editMintState.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(context.l10n.generalSaveButtonLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, EditMintNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.editMintDialogDeleteMintTitle),
        content: Text(
          context.l10n.editMintDialogDeleteMintConfirmation(
            mint.nickName ??
                mint.mint.info?.name ??
                UrlUtils.extractHost(mint.mint.url),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.l10n.generalCancelButtonLabel),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              notifier.deleteMint().then((_) {
                if (onDeleted != null) {
                  onDeleted!();
                }
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: context.colorScheme.error,
            ),
            child: Text(context.l10n.generalDeleteButtonLabel),
          ),
        ],
      ),
    );
  }
}
