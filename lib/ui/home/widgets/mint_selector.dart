import 'package:cashu_app/config/providers.dart';
import 'package:cdk_flutter/cdk_flutter.dart' as cdk;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Available mints
final availableMints = [
  'https://mint.refugio.com.br',
  'https://testnut.cashu.space',
];

// Provider for the current mint URL
final currentMintProvider = StateProvider<String>((ref) {
  final wallet = ref.watch(walletProvider);
  // Access mintUrl through the CDK wallet
  return wallet?.mintUrl ?? availableMints[1]; // Default to testnut.cashu.space
});

class MintSelector extends ConsumerWidget {
  const MintSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMint = ref.watch(currentMintProvider);

    return IconButton(
      icon: const Icon(Icons.swap_horiz),
      tooltip: 'Switch Mint',
      onPressed: () {
        _showMintSelector(context, ref, currentMint);
      },
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
            itemCount: availableMints.length,
            itemBuilder: (context, index) {
              final mint = availableMints[index];
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
                  _switchMint(ref, mint);
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

  Future<void> _switchMint(WidgetRef ref, String newMintUrl) async {
    // Update the current mint provider
    ref.read(currentMintProvider.notifier).state = newMintUrl;

    // Get the current wallet
    final currentWallet = ref.read(walletProvider);
    if (currentWallet == null) return;

    try {
      // We need to recreate the wallet with the new mint URL
      // This requires access to the seed and database from the main file
      // For now, we'll just update the provider and let the app handle recreation

      // In a real implementation, you would need to:
      // 1. Access the seed (securely)
      // 2. Access the database
      // 3. Create a new wallet with the new mint URL
      // 4. Update the wallet provider

      // For demonstration purposes, we'll show a SnackBar indicating the mint change
      ScaffoldMessenger.of(ref.context).showSnackBar(
        SnackBar(
          content: Text('Switched to mint: $newMintUrl'),
          duration: const Duration(seconds: 2),
        ),
      );

      // In a real implementation, you would do something like:
      /*
      final newWallet = cdk.Wallet.newFromHexSeed(
        mintUrl: newMintUrl,
        unit: 'sat',
        seed: getSeedSecurely(),
        localstore: getDatabaseInstance(),
      );
      
      ref.read(walletProvider.notifier).state = newWallet;
      */
    } catch (e) {
      debugPrint('Error switching mint: $e');
    }
  }
}
