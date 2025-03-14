import 'package:flutter/material.dart';

import '../../../utils/extensions/build_context_x.dart';

/// A reusable dialog component with consistent styling
class DefaultDialog extends StatelessWidget {
  /// Creates a [DefaultDialog].
  ///
  /// The [title] parameter is required and specifies the dialog title.
  /// The [children] parameter is required and specifies the content of the dialog.
  /// The [actions] parameter is required and specifies the buttons at the bottom of the dialog.
  const DefaultDialog({
    super.key,
    required this.title,
    required this.children,
    required this.actions,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
  });

  /// The title of the dialog
  final String title;

  /// Optional icon displayed before the title
  final IconData? icon;

  /// The content widgets of the dialog
  final List<Widget> children;

  /// The action buttons at the bottom of the dialog
  final Widget actions;

  /// The padding around the dialog content
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title
            _buildHeader(context),
            const SizedBox(height: 24),
            // Content
            ...children,
            const SizedBox(height: 24),
            // Bottom buttons
            actions,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: context.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
