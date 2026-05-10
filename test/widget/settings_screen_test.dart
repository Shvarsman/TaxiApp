import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taxi_app/blocs/settings/settings_bloc.dart';
import 'package:taxi_app/blocs/settings/settings_state.dart';
import 'package:taxi_app/l10n/app_localizations.dart';
import 'package:taxi_app/screens/settings_screen.dart';

class MockSettingsBloc extends Mock implements SettingsBloc {}

void main() {
  late MockSettingsBloc settingsBloc;

  setUp(() {
    settingsBloc = MockSettingsBloc();
    when(() => settingsBloc.state).thenReturn(const SettingsState(themeMode: ThemeMode.light, locale: Locale('ru')));
  });

  Widget createWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<SettingsBloc>.value(
        value: settingsBloc,
        child: const SettingsScreen(),
      ),
    );
  }

  testWidgets('shows dark theme switch and language dropdown', (tester) async {
    await tester.pumpWidget(createWidget());
    expect(find.text('Тёмная тема'), findsOneWidget);
    expect(find.text('Язык'), findsOneWidget);
  });

  testWidgets('clears cache with confirmation dialog', (tester) async {
    await tester.pumpWidget(createWidget());
    await tester.tap(find.text('Очистить кэш'));
    await tester.pumpAndSettle();
    expect(find.text('Удалить все кэшированные данные?'), findsOneWidget);
  });
}