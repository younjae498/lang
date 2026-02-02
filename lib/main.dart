import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/map/map_screen.dart';
import 'features/review/review_screen.dart';
import 'features/calendar/calendar_screen.dart';
import 'scaffold_with_navbar.dart';
import 'ui/theme/brand_colors.dart';

void main() {
  runApp(const ProviderScope(child: FoxLanguageApp()));
}

class FoxLanguageApp extends ConsumerWidget {
  const FoxLanguageApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      initialLocation: '/map',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ScaffoldWithNavBar(navigationShell: navigationShell);
          },
          branches: [
            // Branch Map
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/map',
                  builder: (context, state) => const MapScreen(),
                ),
              ],
            ),
            // Branch Review
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/review',
                  builder: (context, state) => const ReviewScreen(),
                ),
              ],
            ),
            // Branch Calendar
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/calendar',
                  builder: (context, state) => const CalendarScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Fox Language App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.successFace,
          primary: AppColors.successFace,
          secondary: AppColors.energyFace,
          error: AppColors.errorFace,
          surface: AppColors.backgroundPure,
        ),
        useMaterial3: true,
        fontFamily: GoogleFonts.nunito().fontFamily,
        textTheme: GoogleFonts.nunitoTextTheme().copyWith(
          // Fun & Playful typography
          displayLarge: GoogleFonts.nunito(
            fontWeight: FontWeight.w900,
            color: AppColors.textMain,
          ),
          headlineLarge: GoogleFonts.nunito(
            fontWeight: FontWeight.w900,
            color: AppColors.textMain,
          ),
          headlineMedium: GoogleFonts.nunito(
            fontWeight: FontWeight.w900,
            color: AppColors.textMain,
          ),
          titleLarge: GoogleFonts.nunito(
            fontWeight: FontWeight.w900,
            color: AppColors.textMain,
          ),
          bodyLarge: GoogleFonts.nunito(
            fontWeight: FontWeight.w700,
            color: AppColors.textMain,
          ),
          bodyMedium: GoogleFonts.nunito(
            fontWeight: FontWeight.w600,
            color: AppColors.textMain,
          ),
        ),
        scaffoldBackgroundColor: AppColors.backgroundPure,
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.backgroundPure,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
