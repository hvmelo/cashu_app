import 'package:cashu_app/config/providers.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/widgets/default_card.dart';

class MintInfoCard extends ConsumerWidget {
  const MintInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);

    return DefaultCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withAlpha(10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance,
              color: context.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.homeScreenCurrentMint,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  wallet?.mintUrl ?? context.l10n.homeScreenMintNotConnected,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () {
              // TODO: Implement refresh mint connection
            },
          ),
        ],
      ),
    );
  }
}
