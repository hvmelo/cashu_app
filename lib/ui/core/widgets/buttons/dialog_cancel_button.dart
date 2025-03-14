import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class DialogCancelButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color? textColor;

  const DialogCancelButton({
    super.key,
    this.text,
    this.onPressed,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text ?? context.l10n.generalCancelButtonLabel,
        style: TextStyle(
          color: textColor ?? context.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
