import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/routing/routes.dart';
import '../../core/widgets/widgets.dart';
import '../notifiers/mint_screen_notifier.dart';
import 'widgets.dart';

class MintScreen extends ConsumerWidget {
  const MintScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mintScreenStateAsync = ref.watch(mintScreenNotifierProvider);

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
            child: switch (mintScreenStateAsync) {
              AsyncData(:final value) => _buildUI(
                  mintScreenNotifier:
                      ref.read(mintScreenNotifierProvider.notifier),
                  mintScreenState: value,
                  handleCloseInvoice: handleCloseInvoice,
                ),
              AsyncError(:final error) => ErrorWidget(error),
              _ => const Center(child: LoadingIndicator()),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUI({
    required MintScreenNotifier mintScreenNotifier,
    required MintScreenState mintScreenState,
    required void Function() handleCloseInvoice,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the mint card
        const CurrentMintCard(),
        const SizedBox(height: 24),
        // Display the amount input form or the invoice display
        switch (mintScreenState) {
          MintScreenEditingState() => AmountInputForm(
              mintScreenNotifier: mintScreenNotifier,
              state: mintScreenState,
            ),
          MintScreenInvoiceState() => InvoiceDisplay(
              amount: mintScreenState.mintAmount,
              onClose: handleCloseInvoice,
            ),
          _ => const SizedBox.shrink(),
        },
      ],
    );
  }
}
