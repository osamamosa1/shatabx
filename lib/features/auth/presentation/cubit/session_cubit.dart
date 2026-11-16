import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/local_storage/app_shared_preferences.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_use_cases.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this.preferences, this.logoutUseCase) : super(SessionInitial()) {
    final user = preferences.user;
    final token = preferences.token;
    if (user != null && token != null && token.isNotEmpty) {
      emit(SessionAuthenticated(user));
    } else {
      emit(SessionUnauthenticated());
    }
  }

  final AppSharedPreferences preferences;
  final LogoutUseCase logoutUseCase;

  Future<void> setUser(UserEntity user) async {
    await preferences.saveUser(user);
    emit(SessionAuthenticated(user));
  }

  Future<void> logout() async {
    await logoutUseCase(const NoParams());
    emit(SessionUnauthenticated());
  }

  Future<void> forceLocalLogout() async {
    await preferences.clearSession();
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
