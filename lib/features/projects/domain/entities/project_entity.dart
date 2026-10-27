import 'package:equatable/equatable.dart';

import '../../../../config/locale/app_localizations.dart';

enum ProjectStatus { inProgress, completed, onHold }

class ProjectEntity extends Equatable {
  const ProjectEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.progress,
    required this.status,
    required this.phase,
    required this.engineer,
  });

  final String id;
  final L10n name;
  final L10n location;
  final double progress;
  final ProjectStatus status;
  final L10n phase;
  final L10n engineer;

  @override
  List<Object?> get props => [id, name, location, progress, status, phase, engineer];
}
