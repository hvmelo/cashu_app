import 'package:flutter/material.dart';

import 'shimmer_effect.dart';

/// A loading indicator widget that displays a circular progress indicator
/// with an optional shimmer effect.
///
/// This widget can be used as a drop-in replacement for [CircularProgressIndicator]
/// with the added benefit of a shimmer effect.
class LoadingIndicator extends StatelessWidget {
  /// Creates a [LoadingIndicator] widget.
  ///
  /// The [size] parameter defines the size of the loading indicator.
  /// The [color] parameter defines the color of the loading indicator.
  /// The [useShimmer] parameter determines whether to apply a shimmer effect.
  /// The [strokeWidth] parameter defines the width of the circular progress indicator.
  const LoadingIndicator({
    super.key,
    this.size = 24.0,
    this.color,
    this.useShimmer = true,
    this.strokeWidth = 4.0,
  });

  /// The size of the loading indicator.
  final double size;

  /// The color of the loading indicator.
  ///
  /// If not provided, it will use the primary color from the current theme.
  final Color? color;

  /// Whether to apply a shimmer effect to the loading indicator.
  final bool useShimmer;

  /// The width of the circular progress indicator.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final progressIndicator = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    );

    if (useShimmer) {
      return ShimmerEffect(
        child: progressIndicator,
      );
    }

    return progressIndicator;
  }
}
