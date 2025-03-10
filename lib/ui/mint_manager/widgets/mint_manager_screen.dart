import 'package:cashu_app/domain/models/user_mint.dart';
import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:cashu_app/ui/core/widgets/default_card.dart';
import 'package:cashu_app/ui/home/widgets/app_drawer.dart';
import 'package:cashu_app/ui/mint_manager/notifiers/mint_manager_notifier.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:cashu_app/utils/url_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'widgets.dart';

class MintManagerScreen extends ConsumerWidget {
  const MintManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mintManagerNotifierProvider);
    final notifier = ref.read(mintManagerNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.manageMintScreenTitle),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.refreshMints(),
            tooltip: context.l10n.manageMintScreenRefresh,
          ),
        ],
      ),
      backgroundColor: context.colorScheme.surface,
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMintDialog(context, ref),
        backgroundColor: AppColors.actionColors['mint'],
        child: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: state.mints.isEmpty
              ? _buildEmptyState(context, ref)
              : _buildMintsList(context, state, notifier),
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
              color: AppColors.actionColors['mint']!.withOpacity(0.1),
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
            context.l10n.manageMintScreenNoMints,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.manageMintScreenAddMintPrompt,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Consumer(
            builder: (context, ref, _) => ElevatedButton.icon(
              onPressed: () => _showAddMintDialog(context, ref),
              icon: const Icon(Icons.add),
              label: Text(context.l10n.manageMintScreenAddMintButton),
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
    BuildContext context,
    MintManagementState state,
    MintManagerNotifier notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          context.l10n.manageMintScreenTitle,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.manageMintScreenAddMintPrompt,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: state.mints.length,
            itemBuilder: (context, index) {
              final mint = state.mints[index];
              final isCurrentMint = mint.url == state.currentMintUrl;

              return _buildMintCard(context, mint, isCurrentMint, notifier);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMintCard(
    BuildContext context,
    UserMint mint,
    bool isCurrentMint,
    MintManagerNotifier notifier,
  ) {
    return DefaultCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: () =>
          _showMintDetailsDialog(context, mint, isCurrentMint, notifier),
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
                      ? AppColors.actionColors['mint']!.withOpacity(0.15)
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
                      mint.nickName ?? UrlUtils.extractHost(mint.url),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isCurrentMint ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mint.url,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onSurface.withOpacity(0.6),
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
                    context.l10n.manageMintScreenCurrentMint,
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
                  mint,
                  isCurrentMint,
                  notifier,
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
    BuildContext context,
    UserMint mint,
    bool isCurrentMint,
    MintManagerNotifier notifier,
  ) {
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
    UserMint mint,
    bool isCurrentMint,
    MintManagerNotifier notifier,
  ) {
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
                Navigator.pop(context);
                notifier.setCurrentMint(mint.url);
              },
        onEdit: () {
          Navigator.pop(context);
          _showEditMintDialog(context, mint, notifier);
        },
        onDelete: isCurrentMint
            ? null
            : () {
                Navigator.pop(context);
                _showDeleteMintConfirmation(context, mint, notifier);
              },
      ),
    );
  }

  void _showEditMintDialog(
    BuildContext context,
    UserMint mint,
    MintManagerNotifier notifier,
  ) {
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
    UserMint mint,
    MintManagerNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.manageMintScreenDeleteMintTitle),
        content: Text(
          context.l10n.manageMintScreenDeleteMintConfirmation(
            mint.nickName ?? UrlUtils.extractHost(mint.url),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.generalCancelButtonLabel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              notifier.deleteMint(mint.url);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.red,
            ),
            child: Text(context.l10n.manageMintScreenDeleteButton),
          ),
        ],
      ),
    );
  }
}
