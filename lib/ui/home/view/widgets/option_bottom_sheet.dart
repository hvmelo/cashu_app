import 'package:flutter/material.dart';

/// A model class representing an option item in the bottom sheet
class OptionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const OptionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });
}

/// A reusable bottom sheet widget that displays a list of options
class OptionBottomSheet extends StatelessWidget {
  /// The title of the bottom sheet
  final String title;

  /// The list of option items to display
  final List<OptionItem> items;

  /// Optional padding for the bottom sheet content
  final EdgeInsets padding;

  /// Optional background color for the bottom sheet
  final Color? backgroundColor;

  /// Optional shape for the bottom sheet
  final ShapeBorder? shape;

  const OptionBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.padding = const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
    this.backgroundColor,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  });

  /// Static method to show the bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<OptionItem> items,
    EdgeInsets? padding,
    Color? backgroundColor,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
      builder: (context) => OptionBottomSheet(
        title: title,
        items: items,
        padding: padding ??
            const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        backgroundColor: backgroundColor,
        shape: shape,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.scaffoldBackgroundColor,
        borderRadius: shape is RoundedRectangleBorder
            ? (shape as RoundedRectangleBorder).borderRadius as BorderRadius
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 16.0),
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: padding,
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: (item.iconColor ??
                                    Theme.of(context).colorScheme.primary)
                                .withAlpha(10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            item.icon,
                            color: item.iconColor ??
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.subtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withAlpha(100),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(100),
                        ),
                      ],
                    ),
                  ),
                ),
                if (index < items.length - 1)
                  const Divider(height: 1, indent: 88, endIndent: 16),
              ],
            );
          }),
        ],
      ),
    );
  }
}
