import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/workspace_entities.dart';
import '../../domain/usecases/workspace_use_cases.dart';

class GetNotificationsCubit extends Cubit<GetNotificationsState> {
  GetNotificationsCubit(this.useCase) : super(GetNotificationsInitial());

  final GetNotificationsUseCase useCase;

  Future<void> load() async {
    emit(GetNotificationsLoading());
    final result = await useCase(const NoParams());
    result.fold(
      (failure) => emit(GetNotificationsError(failure.message ?? 'err_notifications')),
      (items) => emit(GetNotificationsLoaded(items)),
    );
  }
}

sealed class GetNotificationsState extends Equatable {
  const GetNotificationsState();
  @override
  List<Object?> get props => [];
}

class GetNotificationsInitial extends GetNotificationsState {}

class GetNotificationsLoading extends GetNotificationsState {}

class GetNotificationsLoaded extends GetNotificationsState {
  const GetNotificationsLoaded(this.items);
  final List<NotificationEntity> items;
  @override
  List<Object?> get props => [items];
}

class GetNotificationsError extends GetNotificationsState {
  const GetNotificationsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
