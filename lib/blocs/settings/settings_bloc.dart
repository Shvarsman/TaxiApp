import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/services/hive_cache_service.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final HiveCacheService _cacheService;

  SettingsBloc(this._cacheService) : super(const SettingsState(
    themeMode: ThemeMode.system,
    locale: Locale('ru'),
  )) {
    on<LoadSettings>(_onLoad);
    on<ChangeTheme>(_onChangeTheme);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ClearCache>(_onClearCache);
  }

  Future<void> _onLoad(LoadSettings event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode') ?? false;
    final lang = prefs.getString('language') ?? 'ru';
    emit(SettingsState(
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(lang),
    ));
  }

  Future<void> _onChangeTheme(ChangeTheme event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', event.isDark);
    emit(SettingsState(
      themeMode: event.isDark ? ThemeMode.dark : ThemeMode.light,
      locale: state.locale,
    ));
  }

  Future<void> _onChangeLanguage(ChangeLanguage event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', event.languageCode);
    emit(SettingsState(
      themeMode: state.themeMode,
      locale: Locale(event.languageCode),
    ));
  }

  Future<void> _onClearCache(ClearCache event, Emitter<SettingsState> emit) async {
    await _cacheService.clearCache();
  }
}