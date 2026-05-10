import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taxi_app/blocs/settings/settings_bloc.dart';
import 'package:taxi_app/blocs/settings/settings_event.dart';
import 'package:taxi_app/blocs/settings/settings_state.dart';
import 'package:taxi_app/services/hive_cache_service.dart';

class MockCacheService extends Mock implements HiveCacheService {}

void main() {
  late MockCacheService cache;
  late SettingsBloc bloc;

  setUp(() {
    cache = MockCacheService();
    bloc = SettingsBloc(cache);
  });

  tearDown(() => bloc.close());

  blocTest<SettingsBloc, SettingsState>(
    'ChangeTheme to dark',
    build: () => bloc,
    act: (bloc) => bloc.add(const ChangeTheme(true)),
    expect: () => [const SettingsState(themeMode: ThemeMode.dark, locale: Locale('ru'))],
  );

  blocTest<SettingsBloc, SettingsState>(
    'ChangeLanguage to en',
    build: () => bloc,
    act: (bloc) => bloc.add(const ChangeLanguage('en')),
    expect: () => [const SettingsState(themeMode: ThemeMode.system, locale: Locale('en'))],
  );

  blocTest<SettingsBloc, SettingsState>(
    'ClearCache calls clearCache',
    build: () {
      when(() => cache.clearCache()).thenAnswer((_) async {});
      return bloc;
    },
    act: (bloc) => bloc.add(ClearCache()),
    expect: () => [],
    verify: (_) => verify(() => cache.clearCache()).called(1),
  );
}