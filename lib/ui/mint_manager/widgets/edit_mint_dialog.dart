import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/types/types.dart';
import '../../../domain/models/mint.dart';
import '../../../domain/value_objects/value_objects.dart';
import '../../core/themes/colors.dart';
import '../../core/widgets/buttons/buttons.dart';
import '../../core/widgets/widgets.dart';
import '../../utils/extensions/build_context_x.dart';
import '../notifiers/edit_mint_notifier.dart';

/// A dialog for editing a mint's details
class EditMintDialog extends HookConsumerWidget {
  /// Creates an [EditMintDialog].
  ///
  /// The [mint] parameter is required and specifies the mint to edit.
  const EditMintDialog({
    super.key,
    required this.mint,
  });

  /// The mint to edit
  final Mint mint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editMintState = ref.watch(editMintNotifierProvider(mint));
    final notifier = ref.read(editMintNotifierProvider(mint).notifier);

    final focusNode = useFocusNode();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
      return null;
    }, []);

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
          }
        }
      },
    );

    return DefaultDialog(
      title: context.l10n.editMintDialogTitle,
      icon: Icons.edit_outlined,
      actions: _buildButtons(
        context,
        notifier: notifier,
        editMintState: editMintState,
      ),
      children: [
        // URL section (read-only)
        _buildMintUrl(context, mintUrl: mint.url),
        const SizedBox(height: 30),
        // Nickname section (editable)
        _buildNicknameEdit(context, ref, focusNode),
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
    FocusNode focusNode,
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
            autovalidateMode: stateAsync.value?.showErrorMessages == true
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: DefaultTextFormField(
              hintText: context.l10n.editMintDialogNicknameHint,
              initialValue: stateAsync.value?.nickname ?? '',
              showErrorMessages: stateAsync.value?.showErrorMessages ?? false,
              focusNode: focusNode,
              onChanged: ref
                  .read(editMintNotifierProvider(mint).notifier)
                  .nicknameChanged,
              validator: (_) {
                final notifier =
                    ref.read(editMintNotifierProvider(mint).notifier);

                final validationResult = notifier.validateNickname();
                return switch (validationResult) {
                  Ok() => null,
                  Error(:final error) => switch (error) {
                      MintNicknameEmpty() => context.l10n.generalNicknameEmpty,
                      MintNicknameTooLong(:final maxLength) =>
                        context.l10n.generalNicknameTooLong(maxLength),
                      MintNicknameInvalidCharacters() =>
                        context.l10n.generalNicknameInvalidCharacters,
                    },
                };
              },
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
}
