import 'package:cashu_app/ui/home/view/widgets/home_screen.dart';
import 'package:cashu_app/ui/mint/view/mint_screen.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

/// Top go_router entry point.
GoRouter router() => GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: Routes.mint,
          builder: (context, state) {
            return const MintScreen();
          },
        ),
      ],
    );
