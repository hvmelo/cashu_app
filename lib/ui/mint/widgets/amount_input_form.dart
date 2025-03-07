import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/core/widgets/default_card.dart';
import 'package:cashu_app/ui/mint/notifiers/mint_screen_notifier.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/widgets/app_buttons.dart';

class AmountInputForm extends HookConsumerWidget {
  const AmountInputForm({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mintScreenNotifierProvider);
    final notifier = ref.read(mintScreenNotifierProvider.notifier);

    final amountFocusNode = useFocusNode();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        amountFocusNode.requestFocus();
      });
      return null;
    }, []);

    return DefaultCard(
      title: context.l10n.mintScreenAmountInSatsLabel,
      child: Form(
        autovalidateMode: state.showErrorMessages
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Custom amount input field
            Container(
              decoration: BoxDecoration(
                color: context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.actionColors['receive']!.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.bolt,
                      color: AppColors.actionColors['receive'],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      focusNode: amountFocusNode,
                      onChanged: (value) {
                        notifier.amountChanged(value);
                      },
                      validator: (_) {
                        final error = ref
                            .read(mintScreenNotifierProvider.notifier)
                            .validate();
                        if (error != null) {
                          return switch (error) {
                            EmptyAmountError() =>
                              context.l10n.mintScreenAmountEmpty,
                            InvalidAmountError() =>
                              context.l10n.mintScreenAmountError,
                            UnknownError() => context.l10n.generalUnknownError,
                          };
                        }
                        return null;
                      },
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                        hintStyle: context.textTheme.headlineSmall?.copyWith(
                          color: context.colorScheme.onSurface.withAlpha(100),
                          fontWeight: FontWeight.bold,
                        ),
                        suffixText: 'sats',
                        suffixStyle: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.onSurface.withAlpha(100),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: PrimaryActionButton(
                onPressed: () {
                  ref
                      .read(mintScreenNotifierProvider.notifier)
                      .generateInvoice();
                },
                text: context.l10n.mintScreenCreateInvoice,
                backgroundColor: AppColors.actionColors['receive'],
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
