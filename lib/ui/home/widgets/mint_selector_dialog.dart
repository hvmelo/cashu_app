import 'package:flutter/material.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';

class MintSelectorDialog extends StatelessWidget {
  final String currentMint;
  final Function(String) onMintSelected;

  const MintSelectorDialog({
    super.key,
    required this.currentMint,
    required this.onMintSelected,
  });

  // Hard-coded list of available mints
  static const availableMints = [
    'https://mint.refugio.com.br',
    'https://testnut.cashu.space',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.selectMintTitle ?? 'Select Mint'),
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
              leading: Icon(Icons.bolt),
              trailing: isSelected
                  ? Icon(Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary)
                  : null,
              selected: isSelected,
              onTap: () {
                onMintSelected(mint);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel ?? 'Cancel'),
        ),
      ],
    );
  }
}
