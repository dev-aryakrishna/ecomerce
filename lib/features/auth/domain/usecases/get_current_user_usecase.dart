import 'package:ecomerceapp/features/auth/domain/entities/user_entity.dart';
import 'package:ecomerceapp/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

  UserEntity? call() => repository.currentUser; 
}