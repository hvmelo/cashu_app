import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/models/mint_wrapper.dart';
import '../../core/themes/colors.dart';
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
            // Header with title
            _buildHeader(context),
            const SizedBox(height: 24),
            // URL section (read-only)
            _buildMintUrl(context),
            const SizedBox(height: 30),
            // Nickname section (editable)
            _buildNickNameEdit(context, editMintState, notifier),
            if (editMintState.error != null) ...[
              const SizedBox(height: 12),
              Text(
                editMintState.error!.message,
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Bottom buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DialogCancelButton(
                  onPressed: () => context.pop(),
                  text: context.l10n.generalCancelButtonLabel,
                  textColor: context.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                DialogActionButton(
                  onPressed: editMintState.isSubmitting
                      ? null
                      : () => notifier.saveMint(),
                  text: context.l10n.generalSaveButtonLabel,
                  isSubmitting: editMintState.isSubmitting,
                  backgroundColor: AppColors.actionColors['mint'],
                  foregroundColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.edit_outlined,
          color: context.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          context.l10n.editMintDialogTitle,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMintUrl(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.editMintDialogUrlLabel,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mint.mint.url,
            style: context.textTheme.bodyMedium?.copyWith(
              fontFamily: 'monospace',
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNickNameEdit(
    BuildContext context,
    EditMintState editMintState,
    EditMintNotifier notifier,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.editMintDialogNicknameLabel,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: context.l10n.editMintDialogNicknameHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: context.colorScheme.surfaceContainerHighest,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              isDense: true,
            ),
            controller: TextEditingController(text: editMintState.nickname),
            onChanged: notifier.nicknameChanged,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
