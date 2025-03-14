import 'package:cashu_app/ui/core/widgets/buttons/primary_action_button.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/types/types.dart';
import '../../core/themes/colors.dart';
import '../../core/widgets/widgets.dart';
import '../notifiers/mint_screen_notifier.dart';

class AmountInputForm extends HookWidget {
  final MintScreenNotifier mintScreenNotifier;
  final MintScreenEditingState state;

  const AmountInputForm({
    super.key,
    required this.mintScreenNotifier,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
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
                        mintScreenNotifier.amountChanged(value);
                      },
                      validator: (_) {
                        final validationResult = state.validate();
                        return switch (validationResult) {
                          Ok() => null,
                          Error(:final error) => switch (error) {
                              AmountTooLarge(:final maxAmount) => context.l10n
                                  .mintScreenAmountTooLarge(maxAmount),
                              AmountNegativeOrZero() =>
                                context.l10n.mintScreenAmountNegativeOrZero,
                              AmountInvalidFormat() =>
                                context.l10n.mintScreenAmountInvalidFormat,
                              UnknownError() =>
                                context.l10n.generalUnknownError,
                            },
                        };
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
                  mintScreenNotifier.generateInvoice();
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
