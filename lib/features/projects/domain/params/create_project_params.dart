import 'package:equatable/equatable.dart';

class CreateProjectParams extends Equatable {
  const CreateProjectParams({
    required this.name,
    required this.clientName,
    required this.location,
    required this.engineerName,
    required this.area,
    this.startDate,
    this.endDate,
    this.type = 'apartment',
    this.customerId,
    this.engineerId,
  });

  final String name;
  final String clientName;
  final String location;
  final String engineerName;
  final String area;
  final String? startDate;
  final String? endDate;
  final String type;
  final String? customerId;
  final String? engineerId;

  @override
  List<Object?> get props => [
        name,
        clientName,
        location,
        engineerName,
        area,
        startDate,
        endDate,
        type,
        customerId,
        engineerId,
      ];
}
