import 'package:flutter/material.dart';
import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';

import 'default_card.dart';

/// A reusable component that displays an error message.
///
/// This widget is based on [DefaultCard] and provides a consistent way to
/// display error messages throughout the app.
class ErrorCard extends StatelessWidget {
  /// Creates an [ErrorCard].
  ///
  /// The [message] parameter is optional and will be displayed as the error message.
  /// If not provided, a generic error message will be displayed.
  ///
  /// The [onRetry] parameter is optional and will be called when the user
  /// taps the retry button. If not provided, the retry button will not be shown.
  ///
  /// The [icon] parameter is optional and will be displayed as the error icon.
  /// If not provided, a default error icon will be displayed.
  ///
  /// The [iconColor] parameter is optional and will be used as the color of the icon.
  /// If not provided, the error color from the current theme will be used.
  const ErrorCard({
    super.key,
    this.message,
    this.onRetry,
    this.icon,
    this.iconColor,
    this.details,
  });

  /// The error message to display.
  ///
  /// If null, a generic error message will be displayed.
  final String? message;

  /// Callback called when the user taps the retry button.
  ///
  /// If null, the retry button will not be shown.
  final VoidCallback? onRetry;

  /// The icon to display.
  ///
  /// If null, a default error icon will be displayed.
  final IconData? icon;

  /// The color of the icon.
  ///
  /// If null, the error color from the current theme will be used.
  final Color? iconColor;

  /// Additional error details that can be expanded by the user.
  ///
  /// If null, no details section will be shown.
  final String? details;

  @override
  Widget build(BuildContext context) {
    return DefaultCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (iconColor ?? context.colorScheme.error).withAlpha(10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon ?? Icons.error_outline,
                  color: iconColor ?? context.colorScheme.error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n
                          .errorCardTitle, // TODO: Use localization when available
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message ?? context.l10n.errorCardGenericMessage,
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (details != null) ...[
            const SizedBox(height: 16),
            _ErrorDetails(details: details!),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.errorCardRetryButtonLabel),
                style: TextButton.styleFrom(
                  foregroundColor: context.colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A widget that displays expandable error details.
class _ErrorDetails extends StatefulWidget {
  const _ErrorDetails({
    required this.details,
  });

  final String details;

  @override
  State<_ErrorDetails> createState() => _ErrorDetailsState();
}

class _ErrorDetailsState extends State<_ErrorDetails> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 16,
                  color: context.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  context.l10n.errorCardDetailsLabel,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colorScheme.errorContainer.withAlpha(77),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.details,
              style: context.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                color: context.colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
