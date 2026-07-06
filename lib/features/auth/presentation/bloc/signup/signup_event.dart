import 'package:equatable/equatable.dart';


abstract class SignupEvent extends Equatable {
  const SignupEvent();
  @override
  List<Object?> get props => [];
}

class SignUpRequested extends SignupEvent {
  final String fullName;
  final String phoneNumber;
  final String email;
  final String password;


  const SignUpRequested({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,

  });

  @override
  List<Object?> get props => [fullName, phoneNumber, email, password];
}