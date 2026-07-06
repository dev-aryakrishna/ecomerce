import 'package:ecomerceapp/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.fullName,
    required super.phoneNumber,
  });
  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ??'',
      fullName: user.userMetadata?['full_name'] ?? '',
      phoneNumber: user.userMetadata?['phone_number'] ??  '',
    );
  }
}
