import 'package:ecomerceapp/core/errors/exceptions.dart';
import 'package:ecomerceapp/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();

  Future<ProfileModel> updateProfile({
    String? fullName,
    String? phoneNumber,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabase;

  ProfileRemoteDataSourceImpl(this.supabase);

  @override
  Future<ProfileModel> getProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw UnauthorizedException('errorUnknown');
    }
    return ProfileModel.fromSupabaseUser(user);
  }

  @override
  Future<ProfileModel> updateProfile({
    String? fullName,
    String? phoneNumber,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw UnauthorizedException('errorUnknown');
    }

    // Only send fields that were actually requested to change; never
    // touch the email attribute from this data source.
    final metadata = <String, dynamic>{
      ...?user.userMetadata,
      if (fullName != null) 'full_name': fullName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
    };

    try{

    final response = await supabase.auth.updateUser(
      UserAttributes(data: metadata),
    );

    final updatedUser = response.user;
    if (updatedUser == null) {
      throw ServerException('errorUnknown');
    }

    return ProfileModel.fromSupabaseUser(updatedUser);
    }
    on AuthException catch(e){
      throw ServerException(e.message);
    }catch(e){
      if(e is ServerException) rethrow;
      throw UnknownException('something went wrong');
    }
  }
}
