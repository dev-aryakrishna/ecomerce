import 'package:ecomerceapp/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> signUp({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
  });

  Future<void> logout();

  bool get isLoggedIn;

  UserEntity? get currentUser;
}