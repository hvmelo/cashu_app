import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

import '../themes/colors.dart';

class PrimaryActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double borderRadius;
  final double elevation;
  final TextStyle? textStyle;
  final bool isFullWidth;
  final Widget? icon;

  const PrimaryActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.height = 56,
    this.borderRadius = 16,
    this.elevation = 0,
    this.textStyle,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.green,
      foregroundColor: foregroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: elevation,
    );

    final defaultTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );

    final buttonChild = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: 8),
              Text(
                text,
                style: textStyle ?? defaultTextStyle,
              ),
            ],
          )
        : Text(
            text,
            style: textStyle ?? defaultTextStyle,
          );

    final button = ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: buttonChild,
    );

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            height: height,
            child: button,
          )
        : SizedBox(height: height, child: button);
  }
}

class OutlinedActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final double borderRadius;
  final double elevation;
  final TextStyle? textStyle;
  final bool isFullWidth;
  final Widget? icon;

  const OutlinedActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 56,
    this.borderRadius = 16,
    this.elevation = 0,
    this.textStyle,
    this.isFullWidth = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = OutlinedButton.styleFrom(
      backgroundColor:
          backgroundColor ?? context.colorScheme.surfaceContainerHighest,
      foregroundColor: foregroundColor ?? context.colorScheme.onSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: elevation,
    );

    final defaultTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );

    final buttonChild = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon!,
              const SizedBox(width: 8),
              Text(
                text,
                style: textStyle ?? defaultTextStyle,
              ),
            ],
          )
        : Text(
            text,
            style: textStyle ?? defaultTextStyle,
          );

    final button = OutlinedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: buttonChild,
    );

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            height: height,
            child: button,
          )
        : SizedBox(
            height: height,
            child: button,
          );
  }
}
