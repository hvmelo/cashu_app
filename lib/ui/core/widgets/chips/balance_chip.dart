import 'package:cashu_app/core/types/result.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../domain/value_objects/value_objects.dart';
import '../../../providers/mint_providers.dart';
import '../../themes/colors.dart';

class BalanceChip extends ConsumerWidget {
  const BalanceChip({
    super.key,
    required this.mintUrl,
    this.unit = 'sat',
    this.isCurrentMint = false,
  });

  final MintUrl mintUrl;
  final String unit;
  final bool isCurrentMint;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(mintBalanceStreamProvider(mintUrl));

    final balanceText = switch (balanceAsync) {
      AsyncData(:final value) => switch (value) {
          Ok(:final value) => '${value.toString()} $unit',
          Error() => '-- $unit',
        },
      _ => '-- $unit',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: isCurrentMint
            ? AppColors.actionColors['mint']
            : context.colorScheme.onSurface, // Added background colo
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        balanceText,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.colorScheme.surface,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
