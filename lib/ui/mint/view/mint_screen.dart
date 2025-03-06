import 'package:cashu_app/routing/routes.dart';
import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/core/widgets/loading_overlay.dart';
import 'package:cashu_app/ui/mint/notifier/mint_notifier.dart';
import 'package:cashu_app/ui/mint/view/widgets/amount_input_form.dart';
import 'package:cashu_app/ui/mint/view/widgets/invoice_display.dart';
import 'package:cashu_app/ui/mint/view/widgets/mint_card.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MintScreen extends HookConsumerWidget {
  const MintScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mintState = ref.watch(mintNotifierProvider);
    final amountController = useTextEditingController();

    // Initialize the amount controller with the state amount if it's not empty
    useEffect(() {
      if (mintState.amount > 0 && amountController.text.isEmpty) {
        amountController.text = mintState.amount.toString();
      }
      return null;
    }, [mintState.amount]);

    void handleGenerateInvoice(int amount) {
      ref.read(mintNotifierProvider.notifier).generateInvoice(amount);
    }

    void handleCloseInvoice() {
      ref.read(mintNotifierProvider.notifier).reset();
      context.pop();
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
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: context.colorScheme.onSurface,
          ),
          onPressed: () {
            if (mintState.invoice != null) {
              ref.read(mintNotifierProvider.notifier).reset();
            }
            context.pop();
          },
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: context.colorScheme.onSurface,
        ),
      ),
      extendBodyBehindAppBar: false,
      body: LoadingOverlay(
        isLoading: mintState.isGeneratingInvoice,
        loadingText: context.l10n.mintScreenLoading,
        progressColor: AppColors.actionColors['receive'],
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the mint card
                  const MintCard(),
                  const SizedBox(height: 24),

                  // Display the appropriate content based on state
                  mintState.invoice == null
                      ? AmountInputForm(
                          onGenerateInvoice: handleGenerateInvoice,
                        )
                      : InvoiceDisplay(
                          invoice: mintState.invoice!,
                          amount: mintState.amount,
                          onClose: handleCloseInvoice,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
