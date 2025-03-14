import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/models/mint.dart';
import '../../notifiers/current_mint_notifier.dart';
import '../../providers/mint_providers.dart';
import '../../themes/colors.dart';
import '../shimmer/shimmer.dart';
import 'default_card.dart';
import 'error_card.dart';

part 'current_mint_card.g.dart';

@riverpod
Future<(List<Mint>, Mint?)> combinedMintData(Ref ref) async {
  final allMints = await ref.watch(listMintsProvider.future);
  final currentMint = await ref.watch(currentMintNotifierProvider.future);
  return (allMints, currentMint);
}

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
  final void Function(Mint mint)? onMintSelected;

  /// Whether to show the switch mint button.
  final bool showSwitchButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Combines the two async values into a single value
    final combinedMintDataAsync = ref.watch(combinedMintDataProvider);

    return switch (combinedMintDataAsync) {
      AsyncData(:final value) => _buildWidget(
          context,
          ref,
          availableMints: value.$1,
          currentMint: value.$2,
        ),
      AsyncError(:final error) => ErrorCard(
          message: context.l10n.currentMintCardErrorLoadingMintData,
          details: error.toString(),
          onRetry: () => ref.refresh(combinedMintDataProvider),
        ),
      _ => _buildLoadingState(),
    };
  }

  Widget _buildWidget(
    BuildContext context,
    WidgetRef ref, {
    required List<Mint> availableMints,
    required Mint? currentMint,
  }) {
    return DefaultCard(
      onTap: availableMints.isNotEmpty
          ? () {
              _showMintSelector(context, ref, currentMint, availableMints);
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
                  currentMint != null
                      ? currentMint.nickname?.value ??
                          currentMint.url.extractAuthority()
                      : context.l10n.currentMintCardNoMintSelected,
                  style: context.textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showSwitchButton && availableMints.length > 1)
            IconButton(
              icon: const Icon(Icons.sync, size: 20),
              onPressed: () {
                _showMintSelector(context, ref, currentMint, availableMints);
              },
            ),
        ],
      ),
    );
  }

  void _showMintSelector(
    BuildContext context,
    WidgetRef ref,
    Mint? currentMint,
    List<Mint> availableMints,
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
                  itemCount: availableMints.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final mint = availableMints[index];
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
                        mint.nickname?.value ?? mint.url.extractAuthority(),
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color:
                              isSelected ? context.colorScheme.primary : null,
                        ),
                      ),
                      subtitle: Text(
                        mint.url.value,
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
                              .read(currentMintNotifierProvider.notifier)
                              .setCurrentMint(mint.url.value);
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

  Widget _buildLoadingState() {
    return DefaultCard(
      child: Row(
        children: [
          ShimmerPlaceholder(
            width: 40,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerPlaceholder(
                  width: 120,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 8),
                ShimmerPlaceholder(
                  width: 180,
                  height: 12,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),
          ShimmerPlaceholder(
            width: 24,
            height: 24,
            shape: BoxShape.circle,
          ),
        ],
      ),
    );
  }
}
