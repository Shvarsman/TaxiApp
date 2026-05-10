import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taxi_app/blocs/history/history_bloc.dart';
import 'package:taxi_app/blocs/history/history_state.dart';
import 'package:taxi_app/l10n/app_localizations.dart';
import 'package:taxi_app/models/ride.dart';
import 'package:taxi_app/screens/history_screen.dart';

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
        initialLocation: '/history',
        routes: [GoRoute(path: '/history', builder: (_, __) => const HistoryScreen())],
      ),
      builder: (context, child) => BlocProvider<HistoryBloc>.value(
        value: historyBloc,
        child: child!,
      ),
    );
  }

  testWidgets('shows empty text when list is empty', (tester) async {
    await tester.pumpWidget(createWidget());
    expect(find.text('Поездок пока нет'), findsOneWidget);
  });

  testWidgets('swipe to delete shows confirm dialog', (tester) async {
    final ride = Ride(id: 1, fromLocation: 'X', toLocation: 'Y', tariff: 'eco', price: 5, driver: 'D', timestamp: DateTime.now());
    when(() => historyBloc.state).thenReturn(HistoryLoaded([ride]));
    await tester.pumpWidget(createWidget());
    await tester.fling(find.text('X → Y'), const Offset(-500, 0), 1000);
    await tester.pumpAndSettle();
    expect(find.text('Удалить'), findsOneWidget);
  });
}