import 'package:flutter/material.dart';

import 'shimmer_effect.dart';

/// A generic shimmer placeholder widget that can be used for various UI elements.
///
/// This widget displays a container with a shimmer effect that can be customized
/// to match the shape and size of different UI elements.
class ShimmerPlaceholder extends StatelessWidget {
  /// Creates a [ShimmerPlaceholder] widget.
  ///
  /// The [width] and [height] parameters define the size of the placeholder.
  /// The [borderRadius] parameter defines the border radius of the placeholder.
  /// The [shape] parameter defines the shape of the placeholder.
  const ShimmerPlaceholder({
    super.key,
    this.width = 100,
    this.height = 40,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.shape = BoxShape.rectangle,
    this.margin,
    this.baseColor,
    this.highlightColor,
  });

  /// The width of the placeholder.
  ///
  /// If null, the placeholder will expand to fill the available width.
  final double? width;

  /// The height of the placeholder.
  ///
  /// If null, the placeholder will expand to fill the available height.
  final double? height;

  /// The border radius of the placeholder.
  ///
  /// Only applicable when [shape] is [BoxShape.rectangle].
  final BorderRadius? borderRadius;

  /// The shape of the placeholder.
  ///
  /// Can be either [BoxShape.rectangle] or [BoxShape.circle].
  final BoxShape shape;

  /// The margin around the placeholder.
  final EdgeInsetsGeometry? margin;

  /// The base color of the shimmer effect.
  ///
  /// If not provided, it will use a color based on the current theme.
  final Color? baseColor;

  /// The highlight color of the shimmer effect.
  ///
  /// If not provided, it will use a color based on the current theme.
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Default colors based on theme
    final baseColorValue =
        baseColor ?? (isDark ? Colors.grey[800]! : Colors.grey[300]!);

    return ShimmerEffect(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: baseColorValue,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? (borderRadius ?? BorderRadius.circular(4))
              : null,
        ),
      ),
    );
  }
}
