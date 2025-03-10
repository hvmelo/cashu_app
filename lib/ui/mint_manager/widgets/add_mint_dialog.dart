import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/mint_manager/notifiers/add_mint_notifier.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Dialog for adding a new mint
class AddMintDialog extends ConsumerWidget {
  const AddMintDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addMintNotifierProvider);
    final notifier = ref.read(addMintNotifierProvider.notifier);

    // Reset the state when the dialog is shown
    ref.listen(addMintNotifierProvider, (previous, current) {
      if (!previous!.isSuccess && current.isSuccess) {
        Navigator.pop(context);
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
                color: context.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: state.url,
              decoration: InputDecoration(
                labelText: context.l10n.addMintScreenUrlLabel,
                hintText: 'https://mint.example.com',
                prefixIcon: const Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                errorText: state.urlError?.message,
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
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: state.nickname,
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
            ),
            if (state.error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.error!.message,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.generalCancelButtonLabel),
        ),
        ElevatedButton(
          onPressed: state.isSubmitting ? null : () => notifier.addMint(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.actionColors['mint'],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: state.isSubmitting
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
}
