import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// A customized TextFormField widget that follows the app's design system
class DefaultTextFormField extends StatelessWidget {
  /// Creates an [DefaultTextFormField]
  const DefaultTextFormField({
    super.key,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.showErrorMessages = false,
    this.fillColor,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.maxLines = 1,
    this.contentPadding,
    this.textInputAction,
    this.focusNode,
    this.controller,
    this.suffix,
    this.prefix,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
  });

  /// Hint text shown when the field is empty
  final String? hintText;

  /// Initial value for the text field
  final String? initialValue;

  /// Called when the user changes the text in the field
  final void Function(String)? onChanged;

  /// Validates the text field input
  final String? Function(String?)? validator;

  /// Whether to show error messages
  final bool showErrorMessages;

  /// The color of the text field background
  final Color? fillColor;

  /// Whether the text field is read only
  final bool readOnly;

  /// Whether to obscure the text (for passwords)
  final bool obscureText;

  /// The keyboard type to use for the text field
  final TextInputType? keyboardType;

  /// How to capitalize text being entered
  final TextCapitalization textCapitalization;

  /// Maximum number of characters allowed
  final int? maxLength;

  /// Maximum number of lines allowed
  final int? maxLines;

  /// Padding inside the text field
  final EdgeInsetsGeometry? contentPadding;

  /// The action to take when the enter button is pressed
  final TextInputAction? textInputAction;

  /// Focus node for controlling focus
  final FocusNode? focusNode;

  /// Controller for the text field
  final TextEditingController? controller;

  /// Widget to display at the end of the text field
  final Widget? suffix;

  /// Widget to display at the start of the text field
  final Widget? prefix;

  /// Whether the field should automatically get focus
  final bool autofocus;

  /// Text alignment within the field
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: context.textTheme.bodySmall?.copyWith(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        errorMaxLines: 2,
        filled: true,
        fillColor: fillColor ?? context.colorScheme.surfaceContainerHighest,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
        isDense: true,
        suffixIcon: suffix,
        prefixIcon: prefix,
      ),
      initialValue: controller == null ? initialValue : null,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      maxLines: maxLines,
      textInputAction: textInputAction,
      autofocus: autofocus,
      textAlign: textAlign,
      onChanged: onChanged,
      validator: validator,
      style: context.textTheme.bodyMedium,
    );
  }
}
