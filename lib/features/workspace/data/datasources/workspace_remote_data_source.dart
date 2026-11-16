import '../../../../config/locale/app_localizations.dart';
import '../../../../core/api/api_response.dart';
import '../../../../core/api/dio_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/workspace_entities.dart';

abstract class WorkspaceRemoteDataSource {
  Future<List<NotificationEntity>> getNotifications();
  Future<List<ReportEntity>> getReports();
  Future<ReportEntity> getReport(String id);
  Future<List<InspectionTemplateEntity>> getTemplates();
  Future<InspectionTemplateEntity> getTemplate(String id);
  Future<InspectionTemplateEntity> createTemplate({
    required String name,
    required String category,
  });
  Future<void> submitInspectionNote(String note);
}

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  WorkspaceRemoteDataSourceImpl(this.client);

  final DioConsumer client;

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      final raw = await client.get(EndPoints.notes);
      return ApiResponse.from(raw).dataList.whereType<Map>().map((item) {
        final map = Map<String, dynamic>.from(item);
        final note = map['note']?.toString() ??
            map['title']?.toString() ??
            map['description']?.toString() ??
            '';
        final id = map['id']?.toString() ?? '';
        final read = map['is_read'] == true ||
            map['status']?.toString() == '1' ||
            map['changed'] == true;
        return NotificationEntity(
          id: id,
          title: L10n(note.isEmpty ? 'إشعار' : note, note.isEmpty ? 'Note' : note),
          body: L10n(
            map['created_at']?.toString() ?? '',
            map['created_at']?.toString() ?? '',
          ),
          timeLabel: L10n(
            map['created_at']?.toString() ?? '',
            map['created_at']?.toString() ?? '',
          ),
          read: read,
        );
      }).toList(growable: false);
    } catch (_) {
      // Fallback: empty until a dedicated notifications API ships.
      return const [];
    }
  }

  @override
  Future<List<ReportEntity>> getReports() async {
    // Live API has no dedicated mobile reports route; map notes as report feed.
    try {
      final notes = await getNotifications();
      return notes
          .map(
            (n) => ReportEntity(
              id: n.id,
              title: n.title,
              projectName: const L10n('ملاحظة نظام', 'System note'),
              dateLabel: n.timeLabel,
              status: L10n(
                n.read ? 'مقروء' : 'جديد',
                n.read ? 'Read' : 'New',
              ),
              notes: n.body,
              statusType: n.read
                  ? ReportStatusType.approved
                  : ReportStatusType.pendingReview,
            ),
          )
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<ReportEntity> getReport(String id) async {
    final items = await getReports();
    for (final item in items) {
      if (item.id == id) return item;
    }
    throw const ServerException(message: 'err_report_missing');
  }

  @override
  Future<List<InspectionTemplateEntity>> getTemplates() async {
    try {
      final raw = await client.get(EndPoints.receiptTemplates);
      return ApiResponse.from(raw).dataList.whereType<Map>().map(_templateFrom).toList();
    } on ServerException {
      return _templatesFromNotes();
    } catch (_) {
      return _templatesFromNotes();
    }
  }

  Future<List<InspectionTemplateEntity>> _templatesFromNotes() async {
    try {
      final raw = await client.get(EndPoints.notes);
      return ApiResponse.from(raw).dataList.whereType<Map>().map((item) {
        final map = Map<String, dynamic>.from(item);
        final note = map['note']?.toString() ?? 'Template';
        return InspectionTemplateEntity(
          id: map['id']?.toString() ?? '',
          name: L10n(note, note),
          itemsCount: 0,
          category: const L10n('عام', 'General'),
          items: const [],
          phasesCount: 0,
          inspectionsCount: 0,
          dateLabel: L10n(
            map['created_at']?.toString() ?? '',
            map['created_at']?.toString() ?? '',
          ),
        );
      }).toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  InspectionTemplateEntity _templateFrom(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final stages = map['stages'];
    var itemsCount = 0;
    var phasesCount = 0;
    final items = <L10n>[];
    if (stages is List) {
      phasesCount = stages.length;
      for (final stage in stages) {
        if (stage is! Map) continue;
        final receives = stage['recives'] ?? stage['receives'];
        if (receives is! List) continue;
        for (final receive in receives) {
          if (receive is! Map) continue;
          final receiveItems = receive['items'];
          if (receiveItems is List) {
            itemsCount += receiveItems.length;
            for (final entry in receiveItems) {
              if (entry is Map) {
                final name = entry['name']?.toString() ?? '';
                if (name.isNotEmpty) items.add(L10n(name, name));
              }
            }
          }
        }
      }
    }
    final name = map['name']?.toString() ??
        map['building_code']?.toString() ??
        map['unit_type']?.toString() ??
        'Template';
    return InspectionTemplateEntity(
      id: map['id']?.toString() ?? '',
      name: L10n(name, name),
      itemsCount: itemsCount,
      category: L10n(
        map['unit_type']?.toString() ?? 'عام',
        map['unit_type']?.toString() ?? 'General',
      ),
      items: items,
      phasesCount: phasesCount,
      inspectionsCount: itemsCount,
      dateLabel: L10n(
        map['created_at']?.toString() ?? '',
        map['created_at']?.toString() ?? '',
      ),
    );
  }

  @override
  Future<InspectionTemplateEntity> getTemplate(String id) async {
    try {
      final raw = await client.get(EndPoints.receiptTemplate(id));
      final map = ApiResponse.from(raw).dataMap;
      if (map != null) return _templateFrom(map);
    } catch (_) {}
    final all = await getTemplates();
    for (final item in all) {
      if (item.id == id) return item;
    }
    throw const ServerException(message: 'err_template_missing');
  }

  @override
  Future<InspectionTemplateEntity> createTemplate({
    required String name,
    required String category,
  }) async {
    try {
      final raw = await client.post(
        EndPoints.receiptTemplates,
        body: <String, dynamic>{
          'building_code': 'egypt_code',
          'unit_type': category.trim().isEmpty ? 'apartment' : category.trim(),
          'stages': [
            {
              'name': name.trim(),
              'recives': [
                {
                  'name': name.trim(),
                  'category': 'electrical_works',
                  'items': [
                    {'name': 'بند أساسي'},
                  ],
                },
              ],
            },
          ],
        },
      );
      final map = ApiResponse.from(raw).dataMap;
      if (map != null) return _templateFrom(map);
    } catch (_) {
      // Fallback create via notes when receipt-templates is unavailable.
      final raw = await client.post(
        EndPoints.notes,
        body: <String, dynamic>{'note': name.trim()},
      );
      final map = ApiResponse.from(raw).dataMap ?? <String, dynamic>{};
      final note = map['note']?.toString() ?? name.trim();
      return InspectionTemplateEntity(
        id: map['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: L10n(note, note),
        itemsCount: 1,
        category: L10n(category, category),
        items: [L10n(note, note)],
      );
    }
    return InspectionTemplateEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: L10n(name, name),
      itemsCount: 1,
      category: L10n(category, category),
      items: [L10n(name, name)],
    );
  }

  @override
  Future<void> submitInspectionNote(String note) async {
    final text = note.trim();
    if (text.isEmpty) {
      throw const ValidationException(message: 'err_inspection_note_required');
    }
    await client.post(
      EndPoints.notes,
      body: <String, dynamic>{'note': text},
    );
  }
}
