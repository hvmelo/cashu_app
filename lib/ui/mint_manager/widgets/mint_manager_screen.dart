import 'package:cashu_app/ui/mint_manager/notifiers/remove_mint_notifier.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/models/mint.dart';
import '../../core/themes/colors.dart';
import '../../core/ui_metrics.dart';
import '../../core/widgets/cards/error_card.dart';
import '../../core/widgets/page_app_bar.dart';
import '../../core/widgets/shimmer/loading_indicator.dart';
import '../notifiers/mint_manager_notifier.dart';
import 'mint_card.dart';
import 'widgets.dart';

class MintManagerScreen extends ConsumerWidget {
  const MintManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mintManagerNotifierProvider);
    final notifier = ref.read(mintManagerNotifierProvider.notifier);

    return Scaffold(
        appBar: PageAppBar(
          title: context.l10n.mintManagerScreenTitle,
          subtitle: context.l10n.mintManagerScreenAddMintPrompt,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddMintDialog(context, ref),
          backgroundColor: AppColors.actionColors['mint'],
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.add_rounded,
            color: AppColors.white,
          ),
        ),
        body: switch (state) {
          AsyncData(:final value) => _buildScreen(
              context,
              ref,
              notifier: notifier,
              state: value,
            ),
          AsyncError(:final error) => Center(
              child: ErrorCard(
                message: context.l10n.mintManagerScreenErrorLoadingMintData,
                details: error.toString(),
                onRetry: () => notifier.refreshMints(),
              ),
            ),
          _ => const Center(
              child: CircularProgressIndicator(),
            ),
        });
  }

  Widget _buildScreen(
    BuildContext context,
    WidgetRef ref, {
    required MintManagerNotifier notifier,
    required MintManagerState state,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPageHorizontalPadding),
        child: state.availableMints.isEmpty
            ? _buildEmptyState(context, ref)
            : _buildMintsList(
                context,
                ref,
                state: state,
                notifier: notifier,
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.actionColors['mint']!.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.account_balance_outlined,
              size: 40,
              color: AppColors.actionColors['mint'],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.l10n.mintManagerScreenNoMints,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.mintManagerScreenAddMintPrompt,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withAlpha(179),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Consumer(
            builder: (context, ref, _) => ElevatedButton.icon(
              onPressed: () => _showAddMintDialog(context, ref),
              icon: const Icon(Icons.add_rounded),
              label: Text(context.l10n.mintManagerScreenAddMintButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionColors['mint'],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMintsList(
    BuildContext context,
    WidgetRef ref, {
    required MintManagerState state,
    required MintManagerNotifier notifier,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: state.availableMints.length,
        separatorBuilder: (context, index) => Divider(
          height: 0.5,
          color: context.colorScheme.outline.withAlpha(128),
        ),
        itemBuilder: (context, index) {
          final mint = state.availableMints[index];
          final isCurrentMint = mint.url.value == state.currentMint?.url.value;

          return MintCard(
            mint: mint,
            isCurrentMint: isCurrentMint,
            onTap: () => _showMintDetailsDialog(
              context,
              mint: mint,
              isCurrentMint: isCurrentMint,
              notifier: notifier,
            ),
            onOptionsPressed: () => _showMintOptionsBottomSheet(
              context,
              ref,
              mint: mint,
              isCurrentMint: isCurrentMint,
              notifier: notifier,
              state: state,
            ),
          );
        },
      ),
    );
  }

  void _showAddMintDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const AddMintDialog(),
    ).then((_) {
      // Refresh the list after adding a mint
      ref.read(mintManagerNotifierProvider.notifier).refreshMints();
    });
  }

  void _showMintDetailsDialog(
    BuildContext context, {
    required Mint mint,
    required bool isCurrentMint,
    required MintManagerNotifier notifier,
  }) {
    showDialog(
      context: context,
      builder: (context) => MintDetailsDialog(
        mint: mint,
        isCurrentMint: isCurrentMint,
      ),
    );
  }

  void _showMintOptionsBottomSheet(
    BuildContext context,
    WidgetRef ref, {
    required Mint mint,
    required bool isCurrentMint,
    required MintManagerNotifier notifier,
    required MintManagerState state,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MintOptionsBottomSheet(
        mint: mint,
        isCurrentMint: isCurrentMint,
        onSetAsCurrent: isCurrentMint
            ? null
            : () {
                context.pop();
                notifier.setCurrentMint(mint.url.value);
              },
        onEdit: () {
          context.pop();
          _showEditMintDialog(
            context,
            mint: mint,
            notifier: notifier,
            state: state,
          );
        },
        onDelete: isCurrentMint
            ? null
            : () {
                context.pop();
                _showDeleteMintConfirmation(
                  context,
                  ref,
                  mint: mint,
                  notifier: notifier,
                );
              },
      ),
    );
  }

  void _showEditMintDialog(
    BuildContext context, {
    required Mint mint,
    required MintManagerNotifier notifier,
    required MintManagerState state,
  }) {
    showDialog(
      context: context,
      builder: (context) => EditMintDialog(mint: mint),
    ).then((_) {
      // Refresh the list after editing a mint
      notifier.refreshMints();
    });
  }

  void _showDeleteMintConfirmation(
    BuildContext context,
    WidgetRef ref, {
    required Mint mint,
    required MintManagerNotifier notifier,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.mintManagerScreenDeleteMintTitle),
        content: Text(
          context.l10n.mintManagerScreenDeleteMintConfirmation(
            mint.nickname?.value ?? mint.url.extractAuthority(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(context.l10n.generalCancelButtonLabel),
          ),
          TextButton(
            onPressed: () async {
              final deleteNotifier =
                  ref.read(removeMintNotifierProvider(mint).notifier);
              await deleteNotifier.removeMint();
              if (context.mounted) {
                context.pop();
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.red,
            ),
            child: Text(context.l10n.mintManagerScreenDeleteButton),
          ),
        ],
      ),
    );
  }
}
