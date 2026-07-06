import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      await loginUseCase(email: event.email, password: event.password);
      emit(LoginSuccess());
    } catch (e) {
      if (e is AuthException) {
        if (e.toString().contains('Failed to fetch') ||
            e.toString().contains('ClientException')) {
             emit(LoginFailure('errorNetworkError')
          );
        }
        else 
        {
          
          emit(LoginFailure(e.message));
        }
      } else {
        emit(LoginFailure('errorUnknown'));
      }
    }
  }
}
