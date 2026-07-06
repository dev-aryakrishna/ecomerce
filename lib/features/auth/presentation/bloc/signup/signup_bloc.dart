import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/features/auth/domain/usecases/signup_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUsecase signUpUseCase;

  SignupBloc({required this.signUpUseCase}) : super(SignupInitial()) {
    on<SignUpRequested>(_onSignUpRequested);
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    try {
      await signUpUseCase(
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        email: event.email,
        password: event.password,
      );
      emit( SignupSuccess('signupSuccess'));
    } catch (e) {
      if(e is AuthException){
       if (e.toString().contains('Failed to fetch') ||
            e.toString().contains('ClientException')) {
              emit(SignupFailure('errorNetworkError'));
          }
          else{
            emit(SignupFailure(e.message));
          }
      }
    }
  }
}