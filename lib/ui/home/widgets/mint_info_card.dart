import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:cdk_flutter/cdk_flutter.dart';
import 'package:flutter/material.dart';

class MintInfoCard extends StatelessWidget {
  final Wallet? wallet;

  const MintInfoCard({
    super.key,
    required this.wallet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colorScheme.primary.withAlpha(10),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
                  'Current Mint',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  wallet?.mintUrl ?? 'Not connected',
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
