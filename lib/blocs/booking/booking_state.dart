import 'package:equatable/equatable.dart';

enum BookingStatus { initial, selecting, searching, found, tracking, finished }

class BookingState extends Equatable {
  final BookingStatus status;
  final String? tariff;
  final String? from;
  final String? to;
  final double price;
  final String? weather;          // описание погоды
  final String? error;
  final int? rideId;

  const BookingState({
    this.status = BookingStatus.initial,
    this.tariff,
    this.from,
    this.to,
    this.price = 0.0,
    this.weather,
    this.error,
    this.rideId,
  });

  BookingState copyWith({
    BookingStatus? status,
    String? tariff,
    String? from,
    String? to,
    double? price,
    String? weather,
    String? error,
    int? rideId,
  }) {
    return BookingState(
      status: status ?? this.status,
      tariff: tariff ?? this.tariff,
      from: from ?? this.from,
      to: to ?? this.to,
      price: price ?? this.price,
      weather: weather ?? this.weather,
      error: error,
      rideId: rideId ?? this.rideId,
    );
  }

  @override
  List<Object?> get props => [status, tariff, from, to, price, weather, error, rideId];
}