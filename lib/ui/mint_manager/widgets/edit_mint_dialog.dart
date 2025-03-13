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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            _buildNicknameEdit(
              context,
              ref,
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

  Widget _buildNicknameEdit(
    BuildContext context,
    WidgetRef ref,
  ) {
    final stateAsync = ref.watch(editMintNotifierProvider(mint));
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
            autovalidateMode: stateAsync.value?.showErrorMessages ?? false
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: context.l10n.editMintDialogNicknameHint,
                hintStyle: context.textTheme.bodySmall?.copyWith(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                errorMaxLines: 2,
                filled: true,
                fillColor: context.colorScheme.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                isDense: true,
              ),
              initialValue: stateAsync.value?.nickname ?? '',
              onChanged: ref
                  .read(editMintNotifierProvider(mint).notifier)
                  .nicknameChanged,
              validator: (_) {
                // Here we should get the most updated state
                final currentStateAsync =
                    ref.read(editMintNotifierProvider(mint));
                final state = currentStateAsync.unwrapPrevious().valueOrNull;
                if (state == null) {
                  return null;
                }
                final validationResult = state.validate();

                return switch (validationResult) {
                  Ok() => null,
                  Error(:final error) => _getL10nErrorMessage(context, error),
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
          onPressed: editMintState is AsyncLoading ? null : () => context.pop(),
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

  String _getL10nErrorMessage(BuildContext context, EditMintError error) {
    return switch (error) {
      EditMintNicknameEmptyError() => context.l10n.generalNicknameEmpty,
      EditMintNicknameTooLongError() => context.l10n.generalNicknameTooLong(20),
      EditMintNicknameInvalidError() =>
        context.l10n.generalNicknameInvalidCharacters,
      EditMintUnknownError() => context.l10n.generalUnknownError,
    };
  }
}
