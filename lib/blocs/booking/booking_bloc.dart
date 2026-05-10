import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/services/api_service.dart';
import 'package:taxi_app/services/map_service.dart';
import 'package:taxi_app/services/database_helper.dart';
import 'package:taxi_app/services/notification_service.dart';
import 'package:taxi_app/models/ride.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final ApiService _api;
  final MapService _mapService;
  final DatabaseHelper _dbHelper;
  final NotificationService _notificationService;

  BookingBloc(this._api, this._mapService, this._dbHelper, this._notificationService)
      : super(const BookingState()) {
    on<StartBooking>(_onStart);
    on<SelectTariff>(_onSelectTariff);
    on<SubmitOrder>(_onSubmit);
    on<FinishRide>(_onFinish);
    on<SetRating>(_onSetRating);
  }

  void _onStart(StartBooking event, Emitter<BookingState> emit) {
    emit(const BookingState(status: BookingStatus.selecting));
  }

  void _onSelectTariff(SelectTariff event, Emitter<BookingState> emit) {
    double price = 10.0;
    if (event.tariff == 'comfort') price = 20.0;
    if (event.tariff == 'business') price = 35.0;
    emit(state.copyWith(tariff: event.tariff, price: price));
  }

  Future<void> _onSubmit(SubmitOrder event, Emitter<BookingState> emit) async {
    emit(state.copyWith(
      status: BookingStatus.searching,
      from: event.from,
      to: event.to,
      error: null,
    ));
    // Эмуляция поиска
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(status: BookingStatus.found));
    // Погода (кэшируется)
    try {
      final weatherData = await _api.fetchWeather(
        _mapService.endPoint.latitude,
        _mapService.endPoint.longitude,
      );
      final desc = '${weatherData['main']['temp']}°C, ${weatherData['weather'][0]['description']}';
      emit(state.copyWith(weather: desc));
      // кэшируем
      // cacheService.cacheWeather(weatherData);
    } catch (e) {
      // офлайн: можно взять из кэша, пока оставим null
      emit(state.copyWith(error: 'weather_unavailable'));
    }
  }

  Future<void> _onFinish(FinishRide event, Emitter<BookingState> emit) async {
    final ride = Ride(
      fromLocation: state.from ?? '',
      toLocation: state.to ?? '',
      tariff: state.tariff ?? 'economy',
      price: state.price,
      driver: 'Иван Иванов',
      timestamp: DateTime.now(),
    );
    try {
      final id = await _dbHelper.insertRide(ride);
      emit(state.copyWith(status: BookingStatus.finished, rideId: id));
      await _notificationService.showRideCompleteNotification('Поездка завершена!');
    } catch (e) {
      emit(state.copyWith(error: 'db_error'));
    }
  }

  Future<void> _onSetRating(SetRating event, Emitter<BookingState> emit) async {
    if (state.rideId != null) {
      await _dbHelper.updateRating(state.rideId!, event.rating);
      // можно обновить состояние
    }
  }
}