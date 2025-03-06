import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/core/widgets/app_qr_code.dart';
import 'package:cashu_app/ui/core/widgets/loading_overlay.dart';
import 'package:cashu_app/ui/mint/notifier/mint_notifier.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MintScreen extends HookConsumerWidget {
  const MintScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mintState = ref.watch(mintNotifierProvider);
    final amountController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    // Initialize the amount controller with the state amount if it's not empty
    useEffect(() {
      if (mintState.amount > 0 && amountController.text.isEmpty) {
        amountController.text = mintState.amount.toString();
      }
      return null;
    }, [mintState.amount]);

    void generateInvoice() {
      if (!(formKey.currentState?.validate() ?? false)) {
        return;
      }

      final amount = int.parse(amountController.text);
      ref.read(mintNotifierProvider.notifier).generateInvoice(amount);
    }

    void copyInvoiceToClipboard(String invoice) {
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

    Widget buildAmountInputForm(MintState state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simple instruction text
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 24),
            child: Text(
              context.l10n.mintScreenSubtitle,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: context.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),

          // Amount input card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.mintScreenAmountHint,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                            color: AppColors.actionColors['receive']!
                                .withOpacity(0.1),
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
                                color: context.colorScheme.onSurface
                                    .withOpacity(0.3),
                                fontWeight: FontWeight.bold,
                              ),
                              suffixText: 'sats',
                              suffixStyle:
                                  context.textTheme.titleMedium?.copyWith(
                                color: context.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              final amount = int.tryParse(value);
                              if (amount == null || amount <= 0) {
                                return 'Please enter a valid amount';
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
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: context.colorScheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                    child: ElevatedButton(
                      onPressed: generateInvoice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.actionColors['receive'],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bolt, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            context.l10n.mintScreenGenerateInvoice,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget buildInvoiceDisplay(String invoice) {
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
                  '${mintState.amount} sats',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.actionColors['receive'],
                  ),
                ),
              ],
            ),
          ),

          // QR Code card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  context.l10n.mintScreenInvoiceSubtitle,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),

                const SizedBox(height: 24),

                // QR Code
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: AppQrCode(
                    data: invoice,
                    size: 220,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.zero,
                    boxShadow: null,
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => copyInvoiceToClipboard(invoice),
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
                        onPressed: () {
                          ref.read(mintNotifierProvider.notifier).reset();
                          context.pop();
                        },
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
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.l10n.mintScreenTitle,
          style: TextStyle(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: context.colorScheme.onSurface,
        ),
      ),
      extendBodyBehindAppBar: false,
      body: LoadingOverlay(
        isLoading: mintState.isLoading,
        loadingText: context.l10n.mintScreenLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: mintState.invoice == null
                  ? buildAmountInputForm(mintState)
                  : buildInvoiceDisplay(mintState.invoice!),
            ),
          ),
        ),
      ),
    );
  }
}
