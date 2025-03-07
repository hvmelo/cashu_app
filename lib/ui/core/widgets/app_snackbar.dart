import 'package:flutter/material.dart';

/// A reusable SnackBar component with different styles
class AppSnackBar {
  /// Shows an error snackbar
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
    bool dismissible = true,
  }) {
    _show(
      context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      dismissible: dismissible,
    );
  }

  /// Shows a warning snackbar
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool dismissible = true,
  }) {
    _show(
      context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      dismissible: dismissible,
    );
  }

  /// Shows an information snackbar
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onAction,
    bool dismissible = true,
  }) {
    _show(
      context,
      message: message,
      type: SnackBarType.info,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      dismissible: dismissible,
    );
  }

  /// Shows a success snackbar
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    String? actionLabel,
    VoidCallback? onAction,
    bool dismissible = true,
  }) {
    _show(
      context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      dismissible: dismissible,
    );
  }

  /// Private method to show the snackbar
  static void _show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    required Duration duration,
    String? actionLabel,
    VoidCallback? onAction,
    bool dismissible = true,
  }) {
    final theme = Theme.of(context);

    // Settings based on type
    final config = _getSnackBarConfig(type, theme);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              config.icon,
              color: config.iconColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: config.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: config.backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
        dismissDirection:
            dismissible ? DismissDirection.horizontal : DismissDirection.none,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: config.actionTextColor,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onAction();
                },
              )
            : null,
      ),
    );
  }

  /// Gets the snackbar configuration based on type
  static _SnackBarConfig _getSnackBarConfig(
      SnackBarType type, ThemeData theme) {
    switch (type) {
      case SnackBarType.error:
        return _SnackBarConfig(
          backgroundColor: Colors.red.shade800,
          textColor: Colors.white,
          iconColor: Colors.white,
          actionTextColor: Colors.white,
          icon: Icons.error_outline,
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          backgroundColor: Colors.amber.shade800,
          textColor: Colors.white,
          iconColor: Colors.white,
          actionTextColor: Colors.white,
          icon: Icons.warning_amber_outlined,
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          backgroundColor: Colors.blue.shade700,
          textColor: Colors.white,
          iconColor: Colors.white,
          actionTextColor: Colors.white,
          icon: Icons.info_outline,
        );
      case SnackBarType.success:
        return _SnackBarConfig(
          backgroundColor: Colors.green.shade700,
          textColor: Colors.white,
          iconColor: Colors.white,
          actionTextColor: Colors.white,
          icon: Icons.check_circle_outline,
        );
    }
  }

  /// Method to hide the current snackbar
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

/// Available snackbar types
enum SnackBarType {
  error,
  warning,
  info,
  success,
}

/// Internal snackbar configuration
class _SnackBarConfig {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color actionTextColor;
  final IconData icon;

  _SnackBarConfig({
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.actionTextColor,
    required this.icon,
  });
}
