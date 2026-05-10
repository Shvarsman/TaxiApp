import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taxi_app/blocs/booking/booking_bloc.dart';
import 'package:taxi_app/blocs/booking/booking_event.dart';
import 'package:taxi_app/blocs/booking/booking_state.dart';
import 'package:taxi_app/services/api_service.dart';
import 'package:taxi_app/services/database_helper.dart';
import 'package:taxi_app/services/map_service.dart';
import 'package:taxi_app/services/notification_service.dart';

class MockApiService extends Mock implements ApiService {}
class MockMapService extends Mock implements MapService {}
class MockDatabaseHelper extends Mock implements DatabaseHelper {}
class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late MockApiService api;
  late MockMapService mapSvc;
  late MockDatabaseHelper db;
  late MockNotificationService notif;
  late BookingBloc bloc;

  setUp(() {
    api = MockApiService();
    mapSvc = MockMapService();
    db = MockDatabaseHelper();
    notif = MockNotificationService();
    bloc = BookingBloc(api, mapSvc, db, notif);
  });

  tearDown(() => bloc.close());

  blocTest<BookingBloc, BookingState>(
    'selecting economy tariff',
    build: () => bloc,
    act: (bloc) => bloc.add(const SelectTariff('economy')),
    expect: () => [const BookingState(status: BookingStatus.selecting, tariff: 'economy', price: 10.0)],
  );

  blocTest<BookingBloc, BookingState>(
    'selecting comfort tariff',
    build: () => bloc,
    act: (bloc) => bloc.add(const SelectTariff('comfort')),
    expect: () => [const BookingState(status: BookingStatus.selecting, tariff: 'comfort', price: 20.0)],
  );

  blocTest<BookingBloc, BookingState>(
    'submits order, searches driver, fetches weather',
    build: () {
      when(() => api.fetchWeather(any(), any()))
          .thenAnswer((_) async => {'main': {'temp': 15}, 'weather': [{'description': 'clear'}]});
      return bloc;
    },
    seed: () => const BookingState(tariff: 'economy', price: 10),
    act: (bloc) => bloc.add(const SubmitOrder(from: 'A', to: 'B')),
    expect: () => [
      const BookingState(from: 'A', to: 'B', tariff: 'economy', price: 10, status: BookingStatus.searching),
      const BookingState(from: 'A', to: 'B', tariff: 'economy', price: 10, status: BookingStatus.found),
      const BookingState(from: 'A', to: 'B', tariff: 'economy', price: 10, status: BookingStatus.found, weather: '15.0°C, clear'),
    ],
  );

  blocTest<BookingBloc, BookingState>(
    'submits order, fails weather, still found',
    build: () {
      when(() => api.fetchWeather(any(), any())).thenThrow(Exception('no net'));
      return bloc;
    },
    seed: () => const BookingState(tariff: 'economy', price: 10),
    act: (bloc) => bloc.add(const SubmitOrder(from: 'A', to: 'B')),
    expect: () => [
      const BookingState(from: 'A', to: 'B', tariff: 'economy', price: 10, status: BookingStatus.searching),
      const BookingState(from: 'A', to: 'B', tariff: 'economy', price: 10, status: BookingStatus.found),
      const BookingState(from: 'A', to: 'B', tariff: 'economy', price: 10, status: BookingStatus.found, error: 'weather_unavailable'),
    ],
  );

  blocTest<BookingBloc, BookingState>(
    'finish ride saves and notifies',
    build: () {
      when(() => db.insertRide(any())).thenAnswer((_) async => 1);
      when(() => notif.showRideCompleteNotification(any())).thenAnswer((_) async {});
      return bloc;
    },
    seed: () => const BookingState(from: 'A', to: 'B', tariff: 'economy', price: 10),
    act: (bloc) => bloc.add(FinishRide()),
    expect: () => [
      const BookingState(from: 'A', to: 'B', tariff: 'economy', price: 10, status: BookingStatus.finished, rideId: 1),
    ],
  );
}