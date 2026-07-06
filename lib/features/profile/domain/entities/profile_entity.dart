import 'package:equatable/equatable.dart';

/// Domain entity representing a user's editable profile.
///
/// Only fields that genuinely exist in the underlying data source
/// (Supabase auth user + user metadata) are represented here.
/// [email] is intentionally read-only from this feature's perspective:
/// this app does not support changing email from the profile screen.
class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String phoneNumber;

  const ProfileEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
  });

  ProfileEntity copyWith({
    String? fullName,
    String? phoneNumber,
  }) {
    return ProfileEntity(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [id, email, fullName, phoneNumber];
}
