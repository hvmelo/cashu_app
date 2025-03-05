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
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      item.icon,
                      color: item.iconColor ?? theme.colorScheme.primary,
                    ),
                  ),
                  title: Text(item.title),
                  subtitle: Text(
                    item.subtitle,
                    style: theme.textTheme.bodySmall,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    item.onTap();
                  },
                ),
                if (index < items.length - 1) const SizedBox(height: 8),
              ],
            );
          }),
        ],
      ),
    );
  }
}
