import 'package:cashu_app/ui/core/themes/colors.dart';
import 'package:flutter/material.dart';

class DialogActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isSubmitting;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const DialogActionButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isSubmitting = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.actionColors['mint'],
        foregroundColor: foregroundColor ?? Colors.white,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Text is always present to maintain the width, but hidden when loading
          Opacity(
            opacity: isSubmitting ? 0.0 : 1.0,
            child: Text(text),
          ),
          // Loading indicator only visible when loading
          if (isSubmitting)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
