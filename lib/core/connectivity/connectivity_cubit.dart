import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/core/services/connectivity_service.dart';
import 'connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final ConnectivityService connectivityService;
  late final StreamSubscription _subscription;

  ConnectivityCubit({required this.connectivityService})
      : super(ConnectivityInitial()) {
    _subscription = connectivityService.connectivityStream.listen((isOnline) {
      if (isOnline) {
        emit(ConnectivityOnline());
      } else {
        emit(ConnectivityOffline());
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}