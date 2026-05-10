import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_app/l10n/app_localizations.dart';
import 'package:taxi_app/widgets/shell_scaffold.dart';

void main() {
  Widget createTestWidget() {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(
        initialLocation: '/home',
        routes: [
          ShellRoute(
            builder: (context, state, child) => ShellScaffold(child: child),
            routes: [
              GoRoute(path: '/home', builder: (_, __) => const Scaffold(body: Text('Home'))),
              GoRoute(path: '/booking', builder: (_, __) => const Scaffold(body: Text('Booking'))),
            ],
          ),
        ],
      ),
    );
  }

  testWidgets('mobile shows bottom navigation', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(400, 800);
    await tester.pumpWidget(createTestWidget());
    expect(find.byType(NavigationBar), findsOneWidget);
    tester.binding.window.clearPhysicalSizeTestValue();
  });

  testWidgets('wide layout shows navigation rail', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    await tester.pumpWidget(createTestWidget());
    expect(find.byType(NavigationRail), findsOneWidget);
    tester.binding.window.clearPhysicalSizeTestValue();
  });
}