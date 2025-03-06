import 'package:cashu_app/ui/home/view/home_screen.dart';
import 'package:cashu_app/ui/mint/view/mint_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Top go_router entry point.
GoRouter router() => GoRouter(
      initialLocation: Routes.home,
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            return const HomeScreen();
          },
          routes: [
            GoRoute(
              path: Routes.mint,
              builder: (context, state) {
                return const MintScreen();
              },
            ),
          ],
        ),
      ],
    );
