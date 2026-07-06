import 'package:ecomerceapp/features/profile/domain/entities/profile_entity.dart';
import 'package:ecomerceapp/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase(this.repository);

  Future<ProfileEntity> call() {
    return repository.getProfile();
  }
}
