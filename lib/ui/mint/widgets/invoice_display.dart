import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/core/widgets/app_qr_code.dart';
import 'package:cashu_app/ui/core/widgets/default_card.dart';
import 'package:cashu_app/ui/mint/notifiers/invoice_display_notifier.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InvoiceDisplay extends ConsumerWidget {
  final BigInt amount;
  final VoidCallback onClose;

  const InvoiceDisplay({
    super.key,
    required this.amount,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceDisplayNotifierProvider(amount));

    // ref.listen(invoiceDisplayNotifierProvider(amount), (previous, next) {
    //   if (next.isIssued) {
    //     Future.delayed(const Duration(seconds: 1), () {
    //       onClose();
    //     });
    //   }
    // });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simple amount display
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 24),
          child: Row(
            children: [
              Icon(
                Icons.bolt,
                color: AppColors.actionColors['receive'],
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '$amount sats',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.actionColors['receive'],
                ),
              ),
            ],
          ),
        ),

        // QR Code card
        Column(
          children: [
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (state.error != null)
              Center(child: Text(state.error.toString()))
            else
              // QR Code
              AppQrCode(
                data: state.invoice!,
                size: MediaQuery.of(context).size.width - 82,
                backgroundColor: context.colorScheme.surface,
                padding: const EdgeInsets.all(16),
                borderRadius: BorderRadius.circular(24),
                boxShadow: null,
              ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => _copyInvoiceToClipboard(
                        context,
                        state.invoice!,
                      ),
                      icon: const Icon(Icons.copy, size: 20),
                      label: Text(context.l10n.mintScreenCopyInvoice),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.actionColors['receive'],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, size: 20),
                    label: Text(context.l10n.mintScreenClose),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colorScheme.onSurface,
                      side: BorderSide(
                        color: context.colorScheme.outline,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _copyInvoiceToClipboard(BuildContext context, String invoice) {
    Clipboard.setData(ClipboardData(text: invoice));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.l10n.mintScreenInvoiceCopied),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: AppColors.actionColors['receive'],
      ),
    );
  }
}
