import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// A default card widget with standard styling that can be used throughout the app
class DefaultCard extends StatelessWidget {
  /// The child widget to be displayed inside the card
  final Widget child;

  final String? title;

  /// Optional padding for the card content
  final EdgeInsetsGeometry? padding;

  /// Optional margin for the card
  final EdgeInsetsGeometry? margin;

  /// Optional border radius for the card
  final BorderRadius? borderRadius;

  /// Optional background color for the card
  final Color? backgroundColor;

  /// Whether to use a thin border instead of elevation
  final bool useBorder;

  const DefaultCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.useBorder = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colorScheme.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: useBorder
            ? Border.all(
                color: context.colorScheme.primary.withAlpha(15),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface.withAlpha(178),
              ),
            ),
          child,
        ],
      ),
    );
  }
}
