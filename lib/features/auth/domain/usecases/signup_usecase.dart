import 'package:ecomerceapp/features/auth/domain/entities/user_entity.dart';
import 'package:ecomerceapp/features/auth/domain/repositories/auth_repository.dart';

class SignupUsecase {

  final AuthRepository repository ;

  SignupUsecase(this.repository);

  Future<UserEntity> call({
    
  required String fullName,
  required String phoneNumber,
  required String email,
  required String password,
  })
  {
    return repository.signUp(
      
    fullName: fullName,
    phoneNumber: phoneNumber,
    email: email,
    password: password,

   );
  }

}