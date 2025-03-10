import 'package:cashu_app/domain/models/user_mint.dart';
import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/mint_manager/notifiers/mint_manager_notifier.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:cashu_app/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Dialog for editing a mint
class EditMintDialog extends HookConsumerWidget {
  final UserMint mint;

  const EditMintDialog({
    super.key,
    required this.mint,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nicknameController = useTextEditingController(text: mint.nickName);
    final isSubmitting = useState(false);
    final errorMessage = useState<String?>(null);

    Future<void> updateMint() async {
      isSubmitting.value = true;
      errorMessage.value = null;

      final nickname = nicknameController.text.trim().isNotEmpty
          ? nicknameController.text.trim()
          : null;

      final result = await ref
          .read(mintManagerNotifierProvider.notifier)
          .updateMintNickname(mint.url, nickname);

      isSubmitting.value = false;

      switch (result) {
        case Ok():
          if (context.mounted) {
            Navigator.pop(context);
          }
        case Error():
          errorMessage.value = result.error.toString();
      }
    }

    return AlertDialog(
      backgroundColor: context.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        context.l10n.manageMintScreenEditMintTitle,
        style: context.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.link),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    mint.url,
                    style: context.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: nicknameController,
            decoration: InputDecoration(
              labelText: context.l10n.addMintScreenNicknameLabel,
              hintText: context.l10n.addMintScreenNicknameHint,
              prefixIcon: const Icon(Icons.label_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => updateMint(),
          ),
          if (errorMessage.value != null) ...[
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
                      errorMessage.value!,
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.generalCancelButtonLabel),
        ),
        ElevatedButton(
          onPressed: isSubmitting.value ? null : updateMint,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.actionColors['mint'],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isSubmitting.value
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(context.l10n.manageMintScreenSaveButton),
        ),
      ],
    );
  }
}
