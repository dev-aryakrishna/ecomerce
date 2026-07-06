import 'package:equatable/equatable.dart';
import 'package:ecomerceapp/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

 class ProfileLoadFailure extends ProfileState {
  final String messageKey;

  const ProfileLoadFailure(this.messageKey);

  @override
  List<Object?> get props => [messageKey];
}

 class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

 
class ProfileUpdating extends ProfileState {
  final ProfileEntity profile;

  const ProfileUpdating(this.profile);

  @override
  List<Object?> get props => [profile];
}

 class ProfileUpdateSuccess extends ProfileState {
  final ProfileEntity profile;

  const ProfileUpdateSuccess(this.profile);

  @override
  List<Object?> get props => [profile];
}

 
class ProfileNoChanges extends ProfileState {
  final ProfileEntity profile;

  const ProfileNoChanges(this.profile);

  @override
  List<Object?> get props => [profile];
}

 
class ProfileUpdateFailure extends ProfileState {
  final ProfileEntity profile;
  final String messageKey;

  const ProfileUpdateFailure(this.profile, this.messageKey);

  @override
  List<Object?> get props => [profile, messageKey];
}
