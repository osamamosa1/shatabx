import 'package:equatable/equatable.dart';

class BaseOneResponse<T> extends Equatable {
  const BaseOneResponse({this.data, this.message, this.success});

  final T? data;
  final String? message;
  final bool? success;

  @override
  List<Object?> get props => [data, message, success];
}
