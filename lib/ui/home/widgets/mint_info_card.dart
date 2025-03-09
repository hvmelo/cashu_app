import 'package:cashu_app/config/providers.dart';
import 'package:cashu_app/ui/home/widgets/mint_selector.dart' as mint_selector;
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/widgets/default_card.dart';

class MintInfoCard extends ConsumerWidget {
  const MintInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final currentMint = ref.watch(mint_selector.currentMintProvider);

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
                  currentMint,
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz, size: 20),
            tooltip: 'Switch Mint',
            onPressed: () {
              _showMintSelector(context, ref, currentMint);
            },
          ),
        ],
      ),
    );
  }

  void _showMintSelector(
      BuildContext context, WidgetRef ref, String currentMint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Mint'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: mint_selector.availableMints.length,
            itemBuilder: (context, index) {
              final mint = mint_selector.availableMints[index];
              final isSelected = mint == currentMint;

              return ListTile(
                title: Text(mint),
                leading: const Icon(Icons.bolt),
                trailing: isSelected
                    ? Icon(Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary)
                    : null,
                selected: isSelected,
                onTap: () {
                  // Update the current mint provider
                  ref.read(mint_selector.currentMintProvider.notifier).state =
                      mint;
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
