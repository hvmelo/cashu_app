import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/types/types.dart';
import '../../../domain/value_objects/value_objects.dart';
import '../../core/providers/mint_providers.dart';
import '../../core/themes/colors.dart';
import '../../core/widgets/buttons/buttons.dart';
import '../../core/widgets/widgets.dart';
import '../notifiers/add_mint_notifier.dart';

/// Dialog for adding a new mint
class AddMintDialog extends ConsumerWidget {
  const AddMintDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(addMintNotifierProvider);
    final notifier = ref.read(addMintNotifierProvider.notifier);

    // Reset the state when the dialog is shown
    ref.listen(addMintNotifierProvider, (previous, current) async {
      switch (current) {
        case AsyncData(:final value):
          if (value.isSuccess) {
            if (context.mounted) {
              context.pop();
              AppSnackBar.showSuccess(
                context,
                message: context.l10n.addMintScreenSuccess,
              );
            }
          }
      }
    });

    return DefaultDialog(
      title: context.l10n.addMintScreenTitle,
      icon: Icons.add_circle_outline,
      actions: _buildButtons(
        context,
        notifier: notifier,
        stateAsync: stateAsync,
      ),
      children: [
        Text(
          context.l10n.addMintScreenDescription,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(178),
          ),
        ),
        const SizedBox(height: 24),
        Form(
          autovalidateMode: stateAsync.value?.showErrorMessages == true
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              _buildMintUrlTextField(context, ref),
              const SizedBox(height: 16),
              _buildNicknameTextField(context, ref),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMintUrlTextField(
    BuildContext context,
    WidgetRef ref,
  ) {
    final stateAsync = ref.watch(addMintNotifierProvider);
    final notifier = ref.read(addMintNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.addMintScreenUrlLabel,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DefaultTextFormField(
            initialValue: stateAsync.value?.url,
            hintText: 'https://mint.example.com',
            suffix: IconButton(
              icon: const Icon(Icons.content_paste),
              onPressed: () async {
                final data = await Clipboard.getData(Clipboard.kTextPlain);
                if (data != null && data.text != null) {
                  notifier.urlChanged(data.text!);
                }
              },
              tooltip: context.l10n.addMintScreenPasteFromClipboard,
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            onChanged: notifier.urlChanged,
            showErrorMessages: stateAsync.value?.showErrorMessages ?? false,
            validator: (_) {
              final validationResult =
                  ref.read(addMintNotifierProvider.notifier).validateUrl();

              return switch (validationResult) {
                Ok() => null,
                Error(:final error) => switch (error) {
                    MintUrlEmpty() => context.l10n.generalMintUrlEmpty,
                    MintUrlInvalid() => context.l10n.generalMintUrlInvalid,
                  },
              };
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNicknameTextField(
    BuildContext context,
    WidgetRef ref,
  ) {
    final stateAsync = ref.watch(addMintNotifierProvider);
    final notifier = ref.read(addMintNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.addMintScreenNicknameLabel,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DefaultTextFormField(
            initialValue: stateAsync.value?.nickname,
            hintText: context.l10n.addMintScreenNicknameHint,
            textInputAction: TextInputAction.done,
            onChanged: notifier.nicknameChanged,
            showErrorMessages: stateAsync.value?.showErrorMessages ?? false,
            validator: (_) {
              final validationResult =
                  ref.read(addMintNotifierProvider.notifier).validateNickname();

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
        ],
      ),
    );
  }

  Widget _buildButtons(
    BuildContext context, {
    required AddMintNotifier notifier,
    required AsyncValue<AddMintState> stateAsync,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DialogCancelButton(
          onPressed: stateAsync.isLoading ? null : () => context.pop(),
          text: context.l10n.generalCancelButtonLabel,
          textColor: context.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        DialogActionButton(
          onPressed: stateAsync.isLoading ? null : () => notifier.addMint(),
          text: context.l10n.addMintScreenAddButton,
          isSubmitting: stateAsync.isLoading,
          backgroundColor: AppColors.actionColors['mint'],
          foregroundColor: Colors.white,
        ),
      ],
    );
  }
}
