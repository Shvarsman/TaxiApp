import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taxi_app/app.dart';
import 'package:taxi_app/blocs/auth/auth_bloc.dart';
import 'package:taxi_app/blocs/booking/booking_bloc.dart';
import 'package:taxi_app/blocs/history/history_bloc.dart';
import 'package:taxi_app/blocs/addresses/addresses_bloc.dart';
import 'package:taxi_app/blocs/settings/settings_bloc.dart';
import 'package:taxi_app/services/auth_service.dart';
import 'package:taxi_app/services/hive_cache_service.dart';
import 'package:taxi_app/services/database_helper.dart';
import 'package:taxi_app/services/api_service.dart';
import 'package:taxi_app/services/map_service.dart';
import 'package:taxi_app/services/notification_service.dart';

import 'blocs/auth/auth_event.dart';
import 'blocs/history/history_event.dart';
import 'blocs/settings/settings_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final ridesBox = await Hive.openBox('rides');
  final cacheBox = await Hive.openBox('cache');
  final addressesBox = await Hive.openBox('addresses');

  final databaseHelper = DatabaseHelper(ridesBox);
  final cacheService = HiveCacheService();   // использует 'cache' box
  final authService = AuthService();         // использует 'cache' box для сессии
  final apiService = ApiService();
  final mapService = MapService();
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authService)..add(AppStarted())),
        BlocProvider(create: (_) => SettingsBloc(cacheService)..add(LoadSettings())),
        BlocProvider(create: (_) => HistoryBloc(databaseHelper)..add(LoadHistory())),
        BlocProvider(create: (_) => BookingBloc(apiService, mapService, databaseHelper, notificationService)),
        BlocProvider(create: (_) => AddressesBloc(addressesBox)),
      ],
      child: const TaxiApp(),
    ),
  );
}