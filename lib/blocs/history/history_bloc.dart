import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:taxi_app/services/database_helper.dart';
import 'package:taxi_app/models/ride.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final DatabaseHelper _db;

  HistoryBloc(this._db) : super(HistoryInitial()) {
    on<LoadHistory>(_onLoad);
    on<AddRide>(_onAdd);
    on<DeleteRide>(_onDelete);
  }

  Future<void> _onLoad(LoadHistory event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final rides = _db.getAllRides(); // теперь синхронный или Future?
      // DatabaseHelper.getAllRides синхронный, можно обернуть в Future.value
      emit(HistoryLoaded(rides));
    } catch (e) {
      emit(HistoryError('Failed to load history: $e'));
    }
  }

  Future<void> _onAdd(AddRide event, Emitter<HistoryState> emit) async {
    if (state is HistoryLoaded) {
      await _db.insertRide(event.ride);
      final updatedRides = _db.getAllRides();
      emit(HistoryLoaded(updatedRides));
    }
  }

  Future<void> _onDelete(DeleteRide event, Emitter<HistoryState> emit) async {
    if (state is HistoryLoaded) {
      await _db.deleteRide(event.rideId);
      final updatedRides = _db.getAllRides();
      emit(HistoryLoaded(updatedRides));
    }
  }
}