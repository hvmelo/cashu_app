import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/core/widgets/default_card.dart';
import 'package:cashu_app/ui/mint/notifier/mint_notifier.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/widgets/default_action_button.dart';

class AmountInputForm extends ConsumerWidget {
  final Function(int) onGenerateInvoice;

  const AmountInputForm({
    super.key,
    required this.onGenerateInvoice,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mintNotifierProvider);
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // // Simple instruction text
        // Padding(
        //   padding: const EdgeInsets.only(left: 8, bottom: 16),
        //   child: Text(
        //     context.l10n.mintScreenSubtitle,
        //     style: context.textTheme.titleMedium?.copyWith(
        //       fontWeight: FontWeight.w500,
        //       color: context.colorScheme.onSurface.withAlpha(100),
        //     ),
        //   ),
        // ),

        // Amount input card
        DefaultCard(
          title: context.l10n.mintScreenAmountInSatsLabel,
          child: Form(
            key: formKey,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              AppColors.actionColors['receive']!.withAlpha(30),
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
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle:
                                context.textTheme.headlineSmall?.copyWith(
                              color:
                                  context.colorScheme.onSurface.withAlpha(100),
                              fontWeight: FontWeight.bold,
                            ),
                            suffixText: 'sats',
                            suffixStyle:
                                context.textTheme.titleMedium?.copyWith(
                              color:
                                  context.colorScheme.onSurface.withAlpha(100),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.l10n.mintScreenAmountEmpty;
                            }
                            final amount = int.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return context.l10n.mintScreenAmountError;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                if (state.error != null) ...[
                  const SizedBox(height: 16),
                  DefaultCard(
                    backgroundColor: context.colorScheme.error.withAlpha(10),
                    padding: const EdgeInsets.all(12),
                    useBorder: false,
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: context.colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.error!,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Generate invoice button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DefaultActionButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        final amount = int.parse(amountController.text);
                        onGenerateInvoice(amount);
                      }
                    },
                    text: context.l10n.mintScreenCreateInvoice,
                    backgroundColor: AppColors.actionColors['receive'],
                    isFullWidth: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
