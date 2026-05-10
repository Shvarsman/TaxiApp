import 'package:equatable/equatable.dart';
import 'package:taxi_app/models/ride.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadHistory extends HistoryEvent {}

class AddRide extends HistoryEvent {
  final Ride ride;
  const AddRide(this.ride);
  @override
  List<Object?> get props => [ride];
}

class DeleteRide extends HistoryEvent {
  final int rideId;
  const DeleteRide(this.rideId);
  @override
  List<Object?> get props => [rideId];
}