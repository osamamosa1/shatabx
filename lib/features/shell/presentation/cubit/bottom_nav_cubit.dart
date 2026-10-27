import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState(0));

  void select(int index) => emit(BottomNavState(index));
}

class BottomNavState extends Equatable {
  const BottomNavState(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}
