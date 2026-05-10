import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taxi_app/blocs/auth/auth_bloc.dart';
import 'package:taxi_app/blocs/auth/auth_state.dart';
import 'package:taxi_app/l10n/app_localizations.dart';
import 'package:taxi_app/screens/login_screen.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockAuthBloc authBloc;

  setUp(() {
    authBloc = MockAuthBloc();
    when(() => authBloc.state).thenReturn(Unauthenticated());
  });

  Widget createWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: const LoginScreen(),
      ),
    );
  }

  testWidgets('renders email and password fields and login button', (tester) async {
    await tester.pumpWidget(createWidget());
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Войти'), findsOneWidget); // русская локаль по умолчанию
  });

  testWidgets('shows loading indicator when state is AuthLoading', (tester) async {
    when(() => authBloc.state).thenReturn(AuthLoading());
    await tester.pumpWidget(createWidget());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Войти'), findsNothing);
  });
}