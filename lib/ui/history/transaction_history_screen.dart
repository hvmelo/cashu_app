import 'package:cashu_app/ui/core/ui_metrics.dart';
import 'package:cashu_app/ui/core/widgets/page_header.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/widgets/page_app_bar.dart';

class TransactionHistoryScreen extends ConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Implement transaction history provider and UI
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: PageAppBar(
        title: context.l10n.transactionHistoryScreenTitle,
        subtitle: context.l10n.transactionHistoryScreenDescription,
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: kPageHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: context.colorScheme.primary.withAlpha(128),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.transactionHistoryScreenEmpty,
                        style: context.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
