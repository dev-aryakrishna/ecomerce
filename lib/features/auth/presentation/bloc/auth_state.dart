import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
 
  @override
  List<Object?> get props => [];
}

class AuthLoggedOut extends AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {

  final String? email;
  final String? fullName;

  const AuthAuthenticated({this.email , this.fullName});

   @override

  List<Object?> get props => [email , fullName];

}

class AuthUnauthenticated extends AuthState {}

class AuthSuccess extends AuthState {
  final String messageKey;
  const AuthSuccess(this.messageKey);

  @override
  List<Object?> get props => [messageKey];
}

class AuthFailure extends AuthState {
  final String errorCode;
  const AuthFailure(this.errorCode);

  @override
  List<Object?> get props => [errorCode];
}
