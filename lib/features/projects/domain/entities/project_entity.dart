import 'package:equatable/equatable.dart';

import '../../../../config/locale/app_localizations.dart';

enum ProjectStatus { started, inProgress, delayed, completed, onHold }

class ProjectPhaseItem extends Equatable {
  const ProjectPhaseItem({
    required this.title,
    required this.lastCheckLabel,
    required this.progress,
    required this.statusLabel,
    required this.itemsCount,
    required this.completed,
  });

  final L10n title;
  final L10n lastCheckLabel;
  final double progress;
  final L10n statusLabel;
  final int itemsCount;
  final bool completed;

  @override
  List<Object?> get props => [
    title,
    lastCheckLabel,
    progress,
    statusLabel,
    itemsCount,
    completed,
  ];
}

class ProjectEntity extends Equatable {
  const ProjectEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.progress,
    required this.status,
    required this.phase,
    required this.engineer,
    this.imageAsset,
    this.lastUpdated,
    this.clientName,
    this.startDate,
    this.endDate,
    this.unitArea,
    this.phases = const [],
  });

  final String id;
  final L10n name;
  final L10n location;
  final double progress;
  final ProjectStatus status;
  final L10n phase;
  final L10n engineer;
  final String? imageAsset;
  final L10n? lastUpdated;
  final L10n? clientName;
  final String? startDate;
  final String? endDate;
  final L10n? unitArea;
  final List<ProjectPhaseItem> phases;

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    progress,
    status,
    phase,
    engineer,
    imageAsset,
    lastUpdated,
    clientName,
    startDate,
    endDate,
    unitArea,
    phases,
  ];
}
