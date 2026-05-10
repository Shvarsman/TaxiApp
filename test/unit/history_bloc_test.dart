import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taxi_app/blocs/history/history_bloc.dart';
import 'package:taxi_app/blocs/history/history_event.dart';
import 'package:taxi_app/blocs/history/history_state.dart';
import 'package:taxi_app/models/ride.dart';
import 'package:taxi_app/services/database_helper.dart';

class MockDatabaseHelper extends Mock implements DatabaseHelper {}

void main() {
  late MockDatabaseHelper db;
  late HistoryBloc bloc;

  final ride1 = Ride(
    id: 1,
    fromLocation: 'A',
    toLocation: 'B',
    tariff: 'economy',
    price: 10,
    driver: 'Ivan',
    timestamp: DateTime.now(),
  );

  setUp(() {
    db = MockDatabaseHelper();
    bloc = HistoryBloc(db);
  });

  tearDown(() => bloc.close());

  group('LoadHistory', () {
    blocTest<HistoryBloc, HistoryState>(
      'emit [HistoryLoading, HistoryLoaded] on success',
      build: () {
        when(() => db.getAllRides()).thenReturn([ride1]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadHistory()),
      expect: () => [HistoryLoading(), HistoryLoaded([ride1])],
    );

    blocTest<HistoryBloc, HistoryState>(
      'emit [HistoryLoading, HistoryError] on error',
      build: () {
        when(() => db.getAllRides()).thenThrow(Exception('db error'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadHistory()),
      expect: () => [HistoryLoading(), HistoryError('Failed to load history: Exception: db error')],
    );
  });

  group('AddRide', () {
    blocTest<HistoryBloc, HistoryState>(
      'adds ride and emits updated list',
      seed: () => HistoryLoaded([ride1]),
      build: () {
        when(() => db.insertRide(any())).thenAnswer((_) async => 2);
        when(() => db.getAllRides()).thenReturn([ride1, ride1.copyWith(id: 2)]);
        return bloc;
      },
      act: (bloc) => bloc.add(AddRide(ride1.copyWith(id: null))),
      expect: () => [HistoryLoaded([ride1, ride1.copyWith(id: 2)])],
    );
  });

  group('DeleteRide', () {
    blocTest<HistoryBloc, HistoryState>(
      'removes ride and emits updated list',
      seed: () => HistoryLoaded([ride1]),
      build: () {
        when(() => db.deleteRide(any())).thenAnswer((_) async {});
        when(() => db.getAllRides()).thenReturn([]);
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteRide(1)),
      expect: () => [HistoryLoaded([])],
    );
  });
}