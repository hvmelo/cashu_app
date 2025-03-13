import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/types/types.dart';
import '../../../domain/models/mint.dart';
import '../../../domain/value_objects/value_objects.dart';
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
  });

  /// The mint to edit
  final Mint mint;

  /// Whether this mint is the current mint
  final bool isCurrentMint;

  /// Callback called when the mint is saved
  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editMintState = ref.watch(editMintNotifierProvider(mint));
    final notifier = ref.watch(editMintNotifierProvider(mint).notifier);

    // Handle success state
    ref.listen(
      editMintNotifierProvider(mint).selectAsync((state) => state.isSuccess),
      (previous, current) async {
        final isSuccess = await current;
        if (isSuccess) {
          // Show success message
          // Close the dialog
          if (context.mounted) {
            context.pop();

            AppSnackBar.showSuccess(
              context,
              message: context.l10n.editMintDialogMintUpdated,
            );

            // Call the appropriate callback
            // if (onSaved != null) {
            //   onSaved!();
            // }
          }
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
            _buildMintUrl(context, mintUrl: mint.url),
            const SizedBox(height: 30),
            // Nickname section (editable)
            _buildNickNameEdit(
              context,
              notifier: notifier,
              stateAsync: editMintState,
            ),
            const SizedBox(height: 24),
            // Bottom buttons
            _buildButtons(
              context,
              notifier: notifier,
              editMintState: editMintState,
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

  Widget _buildMintUrl(BuildContext context, {required MintUrl mintUrl}) {
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
            mintUrl.value,
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
    BuildContext context, {
    required EditMintNotifier notifier,
    required AsyncValue<EditMintState> stateAsync,
  }) {
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
          Form(
            autovalidateMode: switch (stateAsync) {
              AsyncData(value: final state) => state.showErrorMessages
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              _ => AutovalidateMode.disabled,
            },
            child: TextFormField(
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
              onChanged: notifier.nicknameChanged,
              validator: (_) {
                final state = stateAsync.unwrapPrevious().valueOrNull;
                if (state == null) {
                  return null;
                }
                final validationResult = state.validate();

                return switch (validationResult) {
                  Ok() => null,
                  Error(:final error) => switch (error) {
                      NicknameEmpty() => context.l10n.generalNicknameEmpty,
                      NicknameTooLong() =>
                        context.l10n.generalNicknameTooLong(20),
                      NicknameInvalidCharacters(:final validCharacters) =>
                        context.l10n.generalNicknameInvalidCharacters(
                          validCharacters,
                        ),
                      _ => context.l10n.generalUnknownError,
                    },
                };
              },
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(
    BuildContext context, {
    required EditMintNotifier notifier,
    required AsyncValue<EditMintState> editMintState,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DialogCancelButton(
          onPressed: () => context.pop(),
          text: context.l10n.generalCancelButtonLabel,
          textColor: context.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        DialogActionButton(
          onPressed: editMintState is AsyncLoading
              ? null
              : () => notifier.updateMintData(),
          text: context.l10n.generalSaveButtonLabel,
          isSubmitting: editMintState is AsyncLoading,
          backgroundColor: AppColors.actionColors['mint'],
          foregroundColor: Colors.white,
        ),
      ],
    );
  }
}
