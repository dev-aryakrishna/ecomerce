import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecomerceapp/core/errors/exceptions.dart';
import 'package:ecomerceapp/features/profile/domain/entities/profile_entity.dart';
import 'package:ecomerceapp/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:ecomerceapp/features/profile/domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase getProfileUsecase;
  final UpdateProfileUsecase updateProfileUsecase;


  ProfileEntity? _lastKnownProfile;

  bool _isUpdating = false;

  ProfileBloc({
    required this.getProfileUsecase,
    required this.updateProfileUsecase,
  }) : super(ProfileInitial()) {
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileUpdateRequested>(_onUpdateRequested);
  }

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final profile = await getProfileUsecase();
      _lastKnownProfile = profile;
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileLoadFailure(_mapErrorToMessageKey(e)));
    }
  }

  Future<void> _onUpdateRequested(
    ProfileUpdateRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final current = _lastKnownProfile;
    if (current == null || _isUpdating) {
      return;
    }

    _isUpdating = true;
    emit(ProfileUpdating(current));

    try {
      final updated = await updateProfileUsecase(
        currentProfile: current,
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
      );

      if (updated == null) {
        emit(ProfileNoChanges(current));
      } else {
        _lastKnownProfile = updated;
        emit(ProfileUpdateSuccess(updated));
      }
    } catch (e) {

      emit(ProfileUpdateFailure(current, _mapErrorToMessageKey(e)));
    } finally {
      _isUpdating = false;
    }
  }

  String _mapErrorToMessageKey(Object error) {
    if (error is ValidationException) {
      return error.message;
    }
    if (error is AuthException) {
      final text = error.toString();
      if (text.contains('Failed to fetch') || text.contains('ClientException')) {
        return 'errorNetwork';
      }
      return error.message;
    }
    if (error is NetworkException || error is TimeoutException) {
      return 'errorNetwork';
    }
    if (error is UnauthorizedException) {
      return error.message;
    }
    return 'errorUnknown';
  }
}
