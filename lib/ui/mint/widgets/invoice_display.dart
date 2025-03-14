import 'package:cashu_app/ui/core/widgets/buttons/outlined_action_button.dart';
import 'package:cashu_app/ui/core/widgets/buttons/primary_action_button.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/types/types.dart';
import '../../../domain/models/mint_quote.dart';
import '../../../domain/value_objects/value_objects.dart';
import '../../core/errors/unexpected_error.dart';
import '../../core/notifiers/current_mint_notifier.dart';
import '../../core/themes/colors.dart';
import '../../core/widgets/widgets.dart';
import '../../core/providers/mint_providers.dart';
import '../notifiers/invoice_display_notifier.dart';

class InvoiceDisplay extends ConsumerWidget {
  final MintAmount amount;
  final VoidCallback onClose;

  const InvoiceDisplay({
    super.key,
    required this.amount,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMintAsync = ref.watch(currentMintNotifierProvider);
    switch (currentMintAsync) {
      case AsyncData(:final value):
        if (value == null) {
          return ErrorWidget(UnexpectedError(message: 'Mint not found'));
        }
        final mintQuoteAsync = ref.watch(mintQuoteStreamProvider(
          value.url,
          amount,
        ));

        ref.listen(
            mintQuoteStreamProvider(
              value.url,
              amount,
            ), (previous, current) {
          switch (current) {
            case AsyncData(:final value):
              switch (value) {
                case Ok(value: final mintQuote):
                  if (mintQuote.isIssued) {
                    Future.delayed(const Duration(seconds: 1), () {
                      onClose();
                    });
                  }
                case Error(:final error):
                  throw error;
              }
            case AsyncError(:final error):
              throw error;
            default:
              return;
          }
        });

        return switch (mintQuoteAsync) {
          AsyncData(value: final result) => switch (result) {
              Ok(value: final mintQuote) =>
                _buildWidget(context, mintQuote: mintQuote),
              Error(:final error) => ErrorWidget(error),
            },
          AsyncError(:final error) => ErrorWidget(error),
          AsyncLoading() => const Center(child: LoadingIndicator()),
          _ => const SizedBox(),
        };
      case AsyncError(:final error):
        return ErrorWidget(error);
      case _:
        return const Center(child: LoadingIndicator());
    }
  }

  Widget _buildWidget(
    BuildContext context, {
    required MintQuote mintQuote,
  }) {
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
                '${amount.value} sats',
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
            QrCodeCard(
              data: mintQuote.request,
              size: MediaQuery.of(context).size.width - 82,
              backgroundColor: Colors.white,
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
                    child: PrimaryActionButton(
                      onPressed: () => _copyInvoiceToClipboard(
                        context,
                        mintQuote.request,
                      ),
                      text: context.l10n.mintScreenCopyInvoice,
                      icon: Icon(
                        Icons.copy,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedActionButton(
                  onPressed: onClose,
                  height: 56,
                  text: context.l10n.mintScreenClose,
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: context.colorScheme.onSurface,
                  ),
                  isFullWidth: false,
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
    AppSnackBar.showInfo(context,
        message: context.l10n.mintScreenInvoiceCopied);
  }
}
