import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taxi_app/blocs/history/history_bloc.dart';
import 'package:taxi_app/blocs/history/history_state.dart';
import 'package:taxi_app/l10n/app_localizations.dart';
import 'package:taxi_app/models/ride.dart';
import 'package:taxi_app/screens/home_screen.dart';

class MockHistoryBloc extends Mock implements HistoryBloc {}

void main() {
  late MockHistoryBloc historyBloc;

  setUp(() {
    historyBloc = MockHistoryBloc();
    when(() => historyBloc.state).thenReturn(HistoryLoaded([]));
  });

  Widget createWidget() {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(
        initialLocation: '/home',
        routes: [GoRoute(path: '/home', builder: (_, __) => const HomeScreen())],
      ),
      builder: (context, child) => BlocProvider<HistoryBloc>.value(
        value: historyBloc,
        child: child!,
      ),
    );
  }

  testWidgets('shows empty message when no rides', (tester) async {
    await tester.pumpWidget(createWidget());
    expect(find.text('Поездок пока нет'), findsOneWidget);
  });

  testWidgets('shows ride list when loaded', (tester) async {
    final ride = Ride(id: 1, fromLocation: 'A', toLocation: 'B', tariff: 'economy', price: 10, driver: 'Ivan', timestamp: DateTime(2024));
    when(() => historyBloc.state).thenReturn(HistoryLoaded([ride]));
    await tester.pumpWidget(createWidget());
    expect(find.text('A → B'), findsOneWidget);
  });
}