import 'package:ecomerceapp/core/errors/exceptions.dart';
import 'package:ecomerceapp/features/profile/domain/entities/profile_entity.dart';
import 'package:ecomerceapp/features/profile/domain/repositories/profile_repository.dart';

/// Validates, diffs, and (if needed) persists profile changes.
///
/// Business rules live here rather than in the UI or the BLoC:
/// - Full name is required and is trimmed before comparison/submission.
/// - Phone number is optional but trimmed before comparison/submission.
/// - Only fields that actually changed are sent to the repository.
/// - If nothing changed, the repository is not called at all; `call`
///   returns `null` so the caller can show a "no changes" message.
class UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<ProfileEntity?> call({
    required ProfileEntity currentProfile,
    required String fullName,
    required String phoneNumber,
  }) async {
    final trimmedName = fullName.trim();
    final trimmedPhone = phoneNumber.trim();

    if (trimmedName.isEmpty) {
      throw ValidationException('fullNameRequired');
    }

    final nameChanged = trimmedName != currentProfile.fullName;
    final phoneChanged = trimmedPhone != currentProfile.phoneNumber;

    if (!nameChanged && !phoneChanged) {
      return null;
    }

    return repository.updateProfile(
      fullName: nameChanged ? trimmedName : null,
      phoneNumber: phoneChanged ? trimmedPhone : null,
    );
  }
}
