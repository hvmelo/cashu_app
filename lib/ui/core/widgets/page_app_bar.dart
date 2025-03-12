import 'package:cashu_app/ui/utils/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

import '../ui_metrics.dart';

class PageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PageAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.padding = const EdgeInsets.only(
      left: kPageHorizontalPadding,
      right: kPageHorizontalPadding,
      top: 30,
    ),
    this.actions,
  });

  final String title;
  final String subtitle;
  final EdgeInsets padding;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface.withAlpha(178),
                    ),
                  ),
                ],
              ),
            ),
            if (actions != null) ...[
              const SizedBox(width: 16),
              ...actions!,
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 32);
}
