import 'package:ecomerceapp/features/auth/domain/repositories/auth_repository.dart';

class IsLoggedInUsecase {

  final AuthRepository repository;

  IsLoggedInUsecase(this.repository);

  bool call() => repository.isLoggedIn;    

}