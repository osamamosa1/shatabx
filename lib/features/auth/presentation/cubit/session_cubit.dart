import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/local_storage/app_shared_preferences.dart';
import '../../domain/entities/user_entity.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this.preferences) : super(SessionInitial()) {
    final user = preferences.user;
    if (user != null) emit(SessionAuthenticated(user));
  }

  final AppSharedPreferences preferences;

  Future<void> setUser(UserEntity user) async {
    await preferences.saveUser(user);
    emit(SessionAuthenticated(user));
  }

  Future<void> logout() async {
    await preferences.clearUser();
    emit(SessionUnauthenticated());
  }
}

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}

class SessionAuthenticated extends SessionState {
  const SessionAuthenticated(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

class SessionUnauthenticated extends SessionState {}
