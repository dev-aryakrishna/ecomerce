import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadRequested extends ProfileEvent {}


class ProfileUpdateRequested extends ProfileEvent {
  final String fullName;
  final String phoneNumber;

  const ProfileUpdateRequested({
    required this.fullName,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [fullName, phoneNumber];
}
