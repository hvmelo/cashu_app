import 'package:flutter/material.dart';

/// A widget that displays a loading overlay on top of its child.
class LoadingOverlay extends StatelessWidget {
  /// The child widget to display.
  final Widget child;

  /// Whether the loading overlay is visible.
  final bool isLoading;

  /// The text to display in the loading overlay.
  final String? loadingText;

  /// The color of the loading indicator.
  final Color? color;

  /// The opacity of the loading overlay background.
  final double opacity;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingText,
    this.color,
    this.opacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(opacity),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: color ?? colorScheme.primary,
                    ),
                    if (loadingText != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        loadingText!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
