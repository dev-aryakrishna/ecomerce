import 'package:ecomerceapp/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:ecomerceapp/features/profile/domain/entities/profile_entity.dart';
import 'package:ecomerceapp/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<ProfileEntity> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  @override
  Future<ProfileEntity> updateProfile({
    String? fullName,
    String? phoneNumber,
  }) async {
    return await remoteDataSource.updateProfile(
      fullName: fullName,
      phoneNumber: phoneNumber,
    );
  }
}
