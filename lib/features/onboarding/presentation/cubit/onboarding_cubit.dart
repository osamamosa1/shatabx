import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/local_storage/app_shared_preferences.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this.preferences) : super(const OnboardingPage(0));

  final AppSharedPreferences preferences;

  void next(int pageCount) {
    final current = state;
    if (current is! OnboardingPage) return;
    if (current.index >= pageCount - 1) {
      finish();
      return;
    }
    emit(OnboardingPage(current.index + 1));
  }

  void skip() => finish();

  Future<void> finish() async {
    await preferences.setOnboardingSeen(true);
    emit(OnboardingFinished());
  }
}

sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingPage extends OnboardingState {
  const OnboardingPage(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class OnboardingFinished extends OnboardingState {}
