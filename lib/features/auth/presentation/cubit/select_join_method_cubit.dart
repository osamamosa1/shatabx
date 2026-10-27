import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/params/auth_params.dart';

class SelectJoinMethodCubit extends Cubit<SelectJoinMethodState> {
  SelectJoinMethodCubit() : super(const JoinMethodSelected(JoinMethod.newCompany));

  void select(JoinMethod method) => emit(JoinMethodSelected(method));
}

sealed class SelectJoinMethodState extends Equatable {
  const SelectJoinMethodState();

  @override
  List<Object?> get props => [];
}

class JoinMethodSelected extends SelectJoinMethodState {
  const JoinMethodSelected(this.method);

  final JoinMethod method;

  @override
  List<Object?> get props => [method];
}
