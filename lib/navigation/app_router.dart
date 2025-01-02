import 'package:go_router/go_router.dart';

import '../ui/screens/main_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    // TODO: Add more routes for other screens (e.g., chat screen, settings screen)
  ],
); 