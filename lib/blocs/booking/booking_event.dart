import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();
  @override
  List<Object?> get props => [];
}

class StartBooking extends BookingEvent {}

class SelectTariff extends BookingEvent {
  final String tariff;
  const SelectTariff(this.tariff);
  @override
  List<Object?> get props => [tariff];
}

class SubmitOrder extends BookingEvent {
  final String from;
  final String to;
  const SubmitOrder({required this.from, required this.to});
  @override
  List<Object?> get props => [from, to];
}

class FinishRide extends BookingEvent {}

class SetRating extends BookingEvent {
  final int rating;
  const SetRating(this.rating);
  @override
  List<Object?> get props => [rating];
}