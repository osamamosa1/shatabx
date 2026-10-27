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

class ReportEntity extends Equatable {
  const ReportEntity({
    required this.id,
    required this.title,
    required this.projectName,
    required this.dateLabel,
    required this.status,
    required this.notes,
  });

  final String id;
  final L10n title;
  final L10n projectName;
  final L10n dateLabel;
  final L10n status;
  final L10n notes;

  @override
  List<Object?> get props => [id, title, projectName, dateLabel, status, notes];
}

class InspectionTemplateEntity extends Equatable {
  const InspectionTemplateEntity({
    required this.id,
    required this.name,
    required this.itemsCount,
    required this.category,
    required this.items,
  });

  final String id;
  final L10n name;
  final int itemsCount;
  final L10n category;
  final List<L10n> items;

  @override
  List<Object?> get props => [id, name, itemsCount, category, items];
}
