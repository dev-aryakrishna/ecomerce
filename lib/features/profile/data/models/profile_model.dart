import 'package:ecomerceapp/features/profile/domain/entities/profile_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.phoneNumber,
  });

  factory ProfileModel.fromSupabaseUser(User user) {
    return ProfileModel(
      id: user.id,
      email: user.email ?? '',
      fullName: (user.userMetadata?['full_name'] as String?)?.trim() ?? '',
      phoneNumber: (user.userMetadata?['phone_number'] as String?)?.trim() ?? '',
    );
  }
}
