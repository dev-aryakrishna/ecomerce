import 'package:ecomerceapp/features/profile/domain/entities/profile_entity.dart';

/// Contract for reading and updating the current user's profile.
///
/// This is intentionally separate from [AuthRepository]: authentication
/// (login/signup/logout/session) and profile management are different
/// responsibilities and should not be mixed.
abstract class ProfileRepository {
  /// Fetches the current user's profile.
  Future<ProfileEntity> getProfile();

  /// Updates only the provided fields. Pass `null` for a field to leave
  /// it unchanged. Email is never accepted here because this app does
  /// not support changing email from the profile screen.
  Future<ProfileEntity> updateProfile({
    String? fullName,
    String? phoneNumber,
  });
}
