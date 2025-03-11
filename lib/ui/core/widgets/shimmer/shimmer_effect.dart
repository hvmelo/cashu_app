import 'package:flutter/material.dart';

/// A widget that applies a shimmer effect to its child.
///
/// This widget creates a shimmering effect that can be used to indicate
/// loading states in the UI. It animates a gradient across the child widget
/// to create a shimmering effect.
class ShimmerEffect extends StatefulWidget {
  /// Creates a [ShimmerEffect] widget.
  ///
  /// The [child] parameter is required and will have the shimmer effect
  /// applied to it.
  ///
  /// The [baseColor] and [highlightColor] parameters define the colors used
  /// in the shimmer gradient. By default, they use colors that work well
  /// in both light and dark themes.
  ///
  /// The [duration] parameter defines how long one complete shimmer animation
  /// cycle takes.
  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.leftToRight,
  });

  /// The widget to apply the shimmer effect to.
  final Widget child;

  /// The base color of the shimmer effect.
  ///
  /// If not provided, it will use a color based on the current theme.
  final Color? baseColor;

  /// The highlight color of the shimmer effect.
  ///
  /// If not provided, it will use a color based on the current theme.
  final Color? highlightColor;

  /// The duration of one complete shimmer effect cycle.
  final Duration duration;

  /// The direction of the shimmer effect.
  final ShimmerDirection direction;

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Default colors based on theme
    final baseColor =
        widget.baseColor ?? (isDark ? Colors.grey[800]! : Colors.grey[300]!);
    final highlightColor = widget.highlightColor ??
        (isDark ? Colors.grey[700]! : Colors.grey[100]!);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final shimmerSize = widget.direction == ShimmerDirection.leftToRight
                ? bounds.width
                : bounds.height;

            return LinearGradient(
              begin: widget.direction == ShimmerDirection.leftToRight
                  ? Alignment.centerLeft
                  : Alignment.topCenter,
              end: widget.direction == ShimmerDirection.leftToRight
                  ? Alignment.centerRight
                  : Alignment.bottomCenter,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _clamp(_controller.value - 0.3),
                _controller.value,
                _clamp(_controller.value + 0.3),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }

  double _clamp(double value) {
    if (value < 0.0) return 0.0;
    if (value > 1.0) return 1.0;
    return value;
  }
}

/// The direction of the shimmer effect.
enum ShimmerDirection {
  /// The shimmer effect moves from left to right.
  leftToRight,

  /// The shimmer effect moves from top to bottom.
  topToBottom,
}
