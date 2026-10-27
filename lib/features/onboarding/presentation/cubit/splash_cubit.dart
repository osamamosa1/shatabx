import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/local_storage/app_shared_preferences.dart';
import '../../../auth/domain/entities/user_entity.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this.preferences) : super(SplashInitial());

  final AppSharedPreferences preferences;

  Future<void> decide() async {
    emit(SplashLoading());
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final user = preferences.user;
    if (user != null) {
      emit(SplashGoHome(user));
      return;
    }
    if (preferences.onboardingSeen) {
      emit(SplashGoAccountType());
      return;
    }
    emit(SplashGoOnboarding());
  }
}

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashGoOnboarding extends SplashState {}

class SplashGoAccountType extends SplashState {}

class SplashGoHome extends SplashState {
  const SplashGoHome(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}
