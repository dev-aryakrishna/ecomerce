import 'package:ecomerceapp/features/auth/domain/entities/user_entity.dart';
import 'package:ecomerceapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecomerceapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ecomerceapp/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<UserEntity> signUp({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.signUp(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  bool get isLoggedIn => remoteDataSource.getCurrentSession() != null;

 @override
UserEntity? get currentUser {
  final user = remoteDataSource.getCurrentUser();
  if (user == null) return null;
  return UserModel.fromSupabaseUser(user);
}
}
