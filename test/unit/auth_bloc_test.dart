import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taxi_app/blocs/auth/auth_bloc.dart';
import 'package:taxi_app/blocs/auth/auth_event.dart';
import 'package:taxi_app/blocs/auth/auth_state.dart';
import 'package:taxi_app/models/user.dart';
import 'package:taxi_app/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService authService;
  late AuthBloc bloc;

  const testUser = AppUser(email: 't@t.com', name: 'Test');

  setUp(() {
    authService = MockAuthService();
    bloc = AuthBloc(authService);
  });

  tearDown(() => bloc.close());

  group('AppStarted', () {
    blocTest<AuthBloc, AuthState>(
      'emit [AuthLoading, Authenticated] when saved session exists',
      build: () {
        when(() => authService.tryAutoLogin()).thenAnswer((_) async => testUser);
        return bloc;
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [AuthLoading(), Authenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emit [AuthLoading, Unauthenticated] when no saved session',
      build: () {
        when(() => authService.tryAutoLogin()).thenAnswer((_) async => null);
        return bloc;
      },
      act: (bloc) => bloc.add(AppStarted()),
      expect: () => [AuthLoading(), Unauthenticated()],
    );
  });

  group('Login', () {
    blocTest<AuthBloc, AuthState>(
      'emit [AuthLoading, Authenticated] on success',
      build: () {
        when(() => authService.login(any(), any())).thenAnswer((_) async => testUser);
        return bloc;
      },
      act: (bloc) => bloc.add(const Login('t@t.com', '123')),
      expect: () => [AuthLoading(), Authenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emit [AuthLoading, AuthError] on failure',
      build: () {
        when(() => authService.login(any(), any())).thenThrow(Exception('fail'));
        return bloc;
      },
      act: (bloc) => bloc.add(const Login('t@t.com', 'wrong')),
      expect: () => [AuthLoading(), AuthError('Login failed: Exception: fail')],
    );
  });

  group('Logout', () {
    blocTest<AuthBloc, AuthState>(
      'emit Unauthenticated',
      build: () {
        when(() => authService.logout()).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(Logout()),
      expect: () => [Unauthenticated()],
    );
  });
}