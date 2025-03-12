import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/models/mint_wrapper.dart';
import '../../../utils/url_utils.dart';
import '../../core/themes/colors.dart';
import '../../core/widgets/cards/default_card.dart';
import '../../core/widgets/cards/error_card.dart';
import '../../core/widgets/shimmer/loading_indicator.dart';
import '../notifiers/mint_manager_notifier.dart';
import 'widgets.dart';

class MintManagerScreen extends ConsumerWidget {
  const MintManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mintManagerNotifierProvider);
    final notifier = ref.read(mintManagerNotifierProvider.notifier);

    return Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.mintManagerScreenTitle),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => notifier.refreshMints(),
              tooltip: context.l10n.mintManagerScreenRefresh,
            ),
          ],
        ),
        backgroundColor: context.colorScheme.surface,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddMintDialog(context, ref),
          backgroundColor: AppColors.actionColors['mint'],
          child: const Icon(
            Icons.add,
            color: AppColors.white,
          ),
        ),
        body: switch (state) {
          AsyncData(:final value) =>
            _buildScreen(context, ref, notifier: notifier, state: value),
          AsyncError(:final error) => Center(
              child: ErrorCard(
                message: context.l10n.mintManagerScreenErrorLoadingMintData,
                details: error.toString(),
                onRetry: () => notifier.refreshMints(),
              ),
            ),
          _ => const Center(
              child: LoadingIndicator(),
            ),
        });
  }

  SafeArea _buildScreen(
    BuildContext context,
    WidgetRef ref, {
    required MintManagerNotifier notifier,
    required MintManagerState state,
  }) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: state.availableMints.isEmpty
            ? _buildEmptyState(context, ref)
            : _buildMintsList(context, state: state, notifier: notifier),
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
              icon: const Icon(Icons.add),
              label: Text(context.l10n.mintManagerScreenAddMintButton),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionColors['mint'],
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMintsList(
    BuildContext context, {
    required MintManagerState state,
    required MintManagerNotifier notifier,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          context.l10n.mintManagerScreenTitle,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.mintManagerScreenAddMintPrompt,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withAlpha(178),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: state.availableMints.length,
            itemBuilder: (context, index) {
              final mint = state.availableMints[index];
              final isCurrentMint =
                  mint.mint.url == state.currentMint?.mint.url;

              return _buildMintCard(
                context,
                mint: mint,
                isCurrentMint: isCurrentMint,
                notifier: notifier,
                state: state,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMintCard(
    BuildContext context, {
    required MintWrapper mint,
    required bool isCurrentMint,
    required MintManagerNotifier notifier,
    required MintManagerState state,
  }) {
    return DefaultCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () => _showMintDetailsDialog(
        context,
        mint: mint,
        isCurrentMint: isCurrentMint,
        notifier: notifier,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isCurrentMint
                      ? AppColors.actionColors['mint']!.withAlpha(39)
                      : context.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance,
                  color: isCurrentMint
                      ? AppColors.actionColors['mint']
                      : context.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mint.nickName ?? UrlUtils.extractHost(mint.mint.url),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isCurrentMint ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mint.mint.url,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withAlpha(153),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isCurrentMint)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.actionColors['mint'],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.l10n.mintManagerScreenCurrentMint,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showMintOptionsBottomSheet(
                  context,
                  mint: mint,
                  isCurrentMint: isCurrentMint,
                  notifier: notifier,
                  state: state,
                ),
              ),
            ],
          ),
        ],
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
    required MintWrapper mint,
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
    BuildContext context, {
    required MintWrapper mint,
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
                notifier.setCurrentMint(mint.mint.url);
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
                  mint: mint,
                  notifier: notifier,
                );
              },
      ),
    );
  }

  void _showEditMintDialog(
    BuildContext context, {
    required MintWrapper mint,
    required MintManagerNotifier notifier,
    required MintManagerState state,
  }) {
    showDialog(
      context: context,
      builder: (context) => EditMintDialog(
        mint: mint,
        isCurrentMint: mint.mint.url == state.currentMint?.mint.url,
      ),
    ).then((_) {
      // Refresh the list after editing a mint
      notifier.refreshMints();
    });
  }

  void _showDeleteMintConfirmation(
    BuildContext context, {
    required MintWrapper mint,
    required MintManagerNotifier notifier,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.mintManagerScreenDeleteMintTitle),
        content: Text(
          context.l10n.mintManagerScreenDeleteMintConfirmation(
            mint.nickName ?? UrlUtils.extractHost(mint.mint.url),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.generalCancelButtonLabel),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete mint
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
