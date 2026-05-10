import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/models/user.dart';
import 'package:taxi_app/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _auth;

  AuthBloc(this._auth) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _auth.tryAutoLogin();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError('Auto-login failed: $e'));
    }
  }

  Future<void> _onLogin(Login event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _auth.login(event.email, event.password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    await _auth.logout();
    emit(Unauthenticated());
  }
}