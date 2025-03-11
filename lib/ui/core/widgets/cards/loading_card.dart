import 'package:flutter/material.dart';

import '../shimmer/shimmer.dart';
import 'default_card.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
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
