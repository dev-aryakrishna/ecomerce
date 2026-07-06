import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ecomerceapp/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:ecomerceapp/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogoutUsecase logoutUseCase;
  final IsLoggedInUsecase isLoggedInUseCase;
  final GetCurrentUserUsecase getCurrentUserUseCase;

  AuthBloc({
    required this.logoutUseCase,
    required this.isLoggedInUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckSessionRequested>(_onCheckSessionRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckSessionRequested(
    CheckSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (isLoggedInUseCase()) {
      final user = await getCurrentUserUseCase();
      emit(AuthAuthenticated(
        email: user?.email,
        fullName: user?.fullName,
      ));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}