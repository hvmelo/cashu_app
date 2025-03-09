import 'package:cashu_app/routing/routes.dart';
import 'package:cashu_app/ui/core/widgets/current_mint_card.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifiers/mint_screen_notifier.dart';
import 'widgets.dart';

class MintScreen extends HookConsumerWidget {
  const MintScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mintScreenState = ref.watch(mintScreenNotifierProvider);

    void handleCloseInvoice() {
      ref.read(mintScreenNotifierProvider.notifier).reset();
      context.go(Routes.home);
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the mint card
                const CurrentMintCard(),
                const SizedBox(height: 24),

                if (!mintScreenState.isSubmitted)
                  AmountInputForm()
                else
                  InvoiceDisplay(
                    amount: BigInt.from(mintScreenState.amount),
                    onClose: handleCloseInvoice,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
