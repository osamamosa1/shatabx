import 'package:equatable/equatable.dart';

import '../../../../config/locale/app_localizations.dart';

class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.read,
  });

  final String id;
  final L10n title;
  final L10n body;
  final L10n timeLabel;
  final bool read;

  @override
  List<Object?> get props => [id, title, body, timeLabel, read];
}

enum ReportStatusType { approved, pendingReview, reinspect }

class ReportChecklistItem extends Equatable {
  const ReportChecklistItem({
    required this.title,
    required this.compliant,
    this.note,
    this.reply,
    this.images = const [],
  });

  final L10n title;
  final bool compliant;
  final L10n? note;
  final L10n? reply;
  final List<String> images;

  @override
  List<Object?> get props => [title, compliant, note, reply, images];
}

class ReportEntity extends Equatable {
  const ReportEntity({
    required this.id,
    required this.title,
    required this.projectName,
    required this.dateLabel,
    required this.status,
    required this.notes,
    this.statusType = ReportStatusType.pendingReview,
    this.engineerName,
    this.phaseName,
    this.checklist = const [],
  });

  final String id;
  final L10n title;
  final L10n projectName;
  final L10n dateLabel;
  final L10n status;
  final L10n notes;
  final ReportStatusType statusType;
  final L10n? engineerName;
  final L10n? phaseName;
  final List<ReportChecklistItem> checklist;

  @override
  List<Object?> get props => [
    id,
    title,
    projectName,
    dateLabel,
    status,
    notes,
    statusType,
    engineerName,
    phaseName,
    checklist,
  ];
}

class InspectionTemplateEntity extends Equatable {
  const InspectionTemplateEntity({
    required this.id,
    required this.name,
    required this.itemsCount,
    required this.category,
    required this.items,
    this.phasesCount = 4,
    this.inspectionsCount = 8,
    this.dateLabel,
  });

  final String id;
  final L10n name;
  final int itemsCount;
  final L10n category;
  final List<L10n> items;
  final int phasesCount;
  final int inspectionsCount;
  final L10n? dateLabel;

  @override
  List<Object?> get props => [
    id,
    name,
    itemsCount,
    category,
    items,
    phasesCount,
    inspectionsCount,
    dateLabel,
  ];
}
