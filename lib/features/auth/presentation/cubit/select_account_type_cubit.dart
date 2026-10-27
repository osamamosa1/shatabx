import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_entity.dart';

class SelectAccountTypeCubit extends Cubit<SelectAccountTypeState> {
  SelectAccountTypeCubit() : super(SelectAccountTypeInitial());

  void select(AccountRole role) => emit(AccountTypeSelected(role));
}

sealed class SelectAccountTypeState extends Equatable {
  const SelectAccountTypeState();

  @override
  List<Object?> get props => [];
}

class SelectAccountTypeInitial extends SelectAccountTypeState {}

class AccountTypeSelected extends SelectAccountTypeState {
  const AccountTypeSelected(this.role);

  final AccountRole role;

  @override
  List<Object?> get props => [role];
}
