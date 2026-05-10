import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/blocs/auth/auth_bloc.dart';
import 'package:taxi_app/blocs/auth/auth_state.dart';
import 'package:taxi_app/blocs/settings/settings_bloc.dart';
import 'package:taxi_app/l10n/app_localizations.dart';
import 'package:taxi_app/screens/login_screen.dart';
import 'package:taxi_app/screens/home_screen.dart';
import 'package:taxi_app/screens/booking_screen.dart';
import 'package:taxi_app/screens/map_screen.dart';
import 'package:taxi_app/screens/history_screen.dart';
import 'package:taxi_app/screens/ride_detail_screen.dart';
import 'package:taxi_app/screens/addresses_screen.dart';
import 'package:taxi_app/screens/settings_screen.dart';
import 'package:taxi_app/theme/app_theme.dart';
import 'package:taxi_app/widgets/shell_scaffold.dart';

final _router = GoRouter(
  initialLocation: '/login',
  redirect: (BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    final isLoggedIn = authState is Authenticated;
    final isLoggingIn = state.matchedLocation == '/login';
    if (!isLoggedIn && !isLoggingIn) return '/login';
    if (isLoggedIn && isLoggingIn) return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    ShellRoute(
      builder: (context, state, child) => ShellScaffold(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/booking', builder: (_, __) => const BookingScreen()),
        GoRoute(path: '/history', builder: (_, __) => const HistoryScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ],
    ),
    GoRoute(path: '/map', builder: (_, __) => const MapScreen()),
    GoRoute(path: '/ride/:id', builder: (_, state) => RideDetailScreen(rideId: int.parse(state.pathParameters['id']!))),
    GoRoute(path: '/addresses', builder: (_, __) => const AddressesScreen()),
  ],
);

class TaxiApp extends StatelessWidget {
  const TaxiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Taxi App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsState.themeMode,
      locale: settingsState.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('be'),
      ],
      routerConfig: _router,
    );
  }
}