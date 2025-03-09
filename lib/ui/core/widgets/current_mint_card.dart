import 'package:cashu_app/config/app_providers.dart';
import 'package:cashu_app/domain/models/user_mint.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:cashu_app/utils/url_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../themes/colors.dart';
import 'default_card.dart';

/// A reusable component that displays information about the current mint
/// and allows the user to switch between available mints.
class CurrentMintCard extends ConsumerWidget {
  /// Creates a [CurrentMintCard].
  ///
  /// The [onMintSelected] parameter is optional and will be called when the user
  /// selects a new mint. If not provided, the current mint will be
  /// updated automatically.
  const CurrentMintCard({
    super.key,
    this.onMintSelected,
    this.showSwitchButton = true,
  });

  /// Callback called when the user selects a new mint.
  final void Function(UserMint mint)? onMintSelected;

  /// Whether to show the switch mint button.
  final bool showSwitchButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUserMints = ref.watch(allUserMintsProvider);
    final currentMint = ref.watch(currentMintProvider);

    return DefaultCard(
      onTap: allUserMints.isNotEmpty
          ? () {
              _showMintSelector(context, ref, currentMint, allUserMints);
            }
          : null,
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
                  context.l10n.currentMintCardTitle,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentMint?.nickName ??
                      currentMint?.url ??
                      context.l10n.currentMintCardNoMintSelected,
                  style: context.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showSwitchButton && allUserMints.length > 1)
            IconButton(
              icon: const Icon(Icons.sync, size: 20),
              onPressed: () {
                _showMintSelector(context, ref, currentMint, allUserMints);
              },
            ),
        ],
      ),
    );
  }

  void _showMintSelector(
    BuildContext context,
    WidgetRef ref,
    UserMint? currentMint,
    List<UserMint> userMints,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: context.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  context.l10n.currentMintCardSelectMint,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
              const Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: userMints.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final mint = userMints[index];
                    final isSelected = mint.url == currentMint?.url;

                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      selected: isSelected,
                      selectedTileColor:
                          context.colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      title: Text(
                        mint.nickName ?? UrlUtils.extractHost(mint.url),
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color:
                              isSelected ? context.colorScheme.primary : null,
                        ),
                      ),
                      subtitle: Text(
                        mint.url,
                        style: context.textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_sharp,
                              color: AppColors.green,
                            )
                          : null,
                      onTap: () {
                        if (onMintSelected != null) {
                          onMintSelected!(mint);
                        } else {
                          // Update the current mint provider
                          ref
                              .read(currentMintProvider.notifier)
                              .setCurrentMint(mint.url);
                        }
                        context.pop();
                      },
                    );
                  },
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => context.pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: context.colorScheme.primary,
                      ),
                      child: Text(context.l10n.generalCancelButtonLabel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
