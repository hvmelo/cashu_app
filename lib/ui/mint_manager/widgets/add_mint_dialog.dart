import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/mint_manager/notifiers/add_mint_notifier.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/widgets/widgets.dart';

/// Dialog for adding a new mint
class AddMintDialog extends ConsumerWidget {
  const AddMintDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addMintNotifierProvider);
    final notifier = ref.read(addMintNotifierProvider.notifier);

    // Reset the state when the dialog is shown
    ref.listen(addMintNotifierProvider.selectAsync((state) => state.isSuccess),
        (previous, current) async {
      final isSuccess = await current;
      if (isSuccess) {
        if (context.mounted) {
          context.pop();
          AppSnackBar.showSuccess(
            context,
            message: context.l10n.addMintScreenSuccess,
          );
        }
      }
    });

    return AlertDialog(
      backgroundColor: context.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        context.l10n.addMintScreenTitle,
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.addMintScreenDescription,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withAlpha(178),
              ),
            ),
            const SizedBox(height: 24),
            _buildUrlTextField(state, context, notifier),
            const SizedBox(height: 16),
            _buildNicknameTextField(state, context, notifier),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.generalCancelButtonLabel),
        ),
        ElevatedButton(
          onPressed: state.isLoading ? null : () => notifier.addMint(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.actionColors['mint'],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: state.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(context.l10n.addMintScreenAddButton),
        ),
      ],
    );
  }

  TextFormField _buildUrlTextField(AsyncValue<AddMintState> state,
      BuildContext context, AddMintNotifier notifier) {
    return TextFormField(
      initialValue: state.value?.url,
      decoration: InputDecoration(
        labelText: context.l10n.addMintScreenUrlLabel,
        hintText: 'https://mint.example.com',
        prefixIcon: const Icon(Icons.link),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.content_paste),
          onPressed: () async {
            final data = await Clipboard.getData(Clipboard.kTextPlain);
            if (data != null && data.text != null) {
              notifier.urlChanged(data.text!);
            }
          },
          tooltip: context.l10n.addMintScreenPasteFromClipboard,
        ),
      ),
      keyboardType: TextInputType.url,
      textInputAction: TextInputAction.next,
      onChanged: notifier.urlChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.addMintScreenErrorEmptyUrl;
        }
        return null;
      },
    );
  }

  TextFormField _buildNicknameTextField(AsyncValue<AddMintState> state,
      BuildContext context, AddMintNotifier notifier) {
    return TextFormField(
      initialValue: state.value?.nickname,
      decoration: InputDecoration(
        labelText: context.l10n.addMintScreenNicknameLabel,
        hintText: context.l10n.addMintScreenNicknameHint,
        prefixIcon: const Icon(Icons.label_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textInputAction: TextInputAction.done,
      onChanged: notifier.nicknameChanged,
    );
  }

  String _getErrorMessage(BuildContext context, AddMintScreenError error) {
    return switch (error) {
      EmptyUrlError() => context.l10n.addMintScreenErrorEmptyUrl,
      InvalidUrlError() => context.l10n.addMintScreenErrorInvalidUrl,
      UnknownError(:final message) => message,
    };
  }
}
