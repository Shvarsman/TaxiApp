import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taxi_app/blocs/booking/booking_bloc.dart';
import 'package:taxi_app/blocs/booking/booking_state.dart';
import 'package:taxi_app/l10n/app_localizations.dart';
import 'package:taxi_app/screens/booking_screen.dart';

class MockBookingBloc extends Mock implements BookingBloc {}

void main() {
  late MockBookingBloc bookingBloc;

  setUp(() {
    bookingBloc = MockBookingBloc();
    when(() => bookingBloc.state).thenReturn(const BookingState());
  });

  Widget createWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<BookingBloc>.value(
        value: bookingBloc,
        child: const BookingScreen(),
      ),
    );
  }

  testWidgets('renders tariff cards and order button', (tester) async {
    await tester.pumpWidget(createWidget());
    expect(find.text('Эконом'), findsOneWidget);
    expect(find.text('Комфорт'), findsOneWidget);
    expect(find.text('Бизнес'), findsOneWidget);
    expect(find.text('Заказать'), findsOneWidget);
  });

  testWidgets('button disabled when no tariff selected', (tester) async {
    await tester.pumpWidget(createWidget());
    final btn = tester.widget<ElevatedButton>(find.text('Заказать'));
    expect(btn.onPressed, isNull);
  });

  testWidgets('shows loading when searching', (tester) async {
    when(() => bookingBloc.state).thenReturn(const BookingState(
      tariff: 'economy',
      from: 'A',
      to: 'B',
      status: BookingStatus.searching,
    ));
    await tester.pumpWidget(createWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}