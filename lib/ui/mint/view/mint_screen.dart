import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/themes/colors.dart';
import '../../core/widgets/loading_overlay.dart';
import '../notifier/mint_screen_notifier.dart';
import 'widgets/widgets.dart';

class MintScreen extends HookConsumerWidget {
  const MintScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mintState = ref.watch(mintScreenNotifierProvider);

    void handleCloseInvoice() {
      ref.read(mintScreenNotifierProvider.notifier).reset();
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
        automaticallyImplyLeading: true,
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
                      ? AmountInputForm()
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
