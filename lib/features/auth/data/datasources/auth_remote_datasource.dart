import 'package:ecomerceapp/features/auth/data/models/user_model.dart';
import 'package:ecomerceapp/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


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

    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );


    return UserModel.fromSupabaseUser(response.user!);
  }

  @override
  Future<UserModel> signUp({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {

    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'phone_number': phoneNumber},
    );


    return UserModel.fromSupabaseUser(response.user!);
  }



  @override
  Future<void> logout() async {

    await supabase.auth.signOut();

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
