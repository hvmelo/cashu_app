import 'package:cashu_app/config/providers.dart';
import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/core/widgets/default_card.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A card that displays the mint URL
class MintCard extends ConsumerWidget {
  const MintCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mintUrl = ref.watch(mintUrlProvider);

    return DefaultCard(
      title: context.l10n.mintScreenMintCardTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.account_balance,
                size: 20,
                color: AppColors.actionColors['receive'],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  mintUrl,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
