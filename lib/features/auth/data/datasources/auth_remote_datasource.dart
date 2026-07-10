import 'package:ecomerceapp/features/auth/data/models/user_model.dart';
import 'package:ecomerceapp/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecomerceapp/core/errors/exceptions.dart';



Exception _mapAuthError(Object error){
  if(error is AuthException){
    final status = error.statusCode;

      if(status == '400' || status == '422'){
        return ServerException(error.message);
      }
      if(status == '401' || status == '403'){
        return UnauthorizedException('invalid email or password');
      }
    return ServerException(error.message);

  }
  return UnknownException('something went wrong');
}


abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String email, required String password});

  Future<UserModel> signUp({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
  });

  Future<void> logout();

  Session? getCurrentSession();

  User? getCurrentUser();

 
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase;

  AuthRemoteDataSourceImpl(this.supabase);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {

    try{
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );


    return UserModel.fromSupabaseUser(response.user!);
  }
    catch(e){

      throw _mapAuthError(e);
    
  }

  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try{

    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'phone_number': phoneNumber},
    );


    return UserModel.fromSupabaseUser(response.user!);
    }
  catch(e){

      throw _mapAuthError(e);
    
  }

  }



  @override
  Future<void> logout() async {
    try{

    await supabase.auth.signOut();
    }
    catch(e){
      throw _mapAuthError(e);
    }

  }

  @override
  Session? getCurrentSession() {
    return supabase.auth.currentSession;
  }

  @override
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }
}
