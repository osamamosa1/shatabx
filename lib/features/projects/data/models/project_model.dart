import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/assets.dart';
import '../../domain/entities/project_entity.dart';

class ProjectModel {
  const ProjectModel._();

  static ProjectEntity fromLocation(Map<String, dynamic> json) {
    final engineers = json['engineers'];
    String engineerName = '';
    if (engineers is List && engineers.isNotEmpty) {
      final first = engineers.first;
      if (first is Map) {
        final engineer = first['engineer'];
        if (engineer is Map) {
          engineerName = engineer['name']?.toString() ?? '';
        }
      }
    }

    final user = json['user'];
    final clientName = user is Map ? user['name']?.toString() : null;
    final userAddress = user is Map ? user['address']?.toString() : null;
    final type = json['type']?.toString() ?? '';
    final area = json['area']?.toString() ?? '';
    final notes = json['notes']?.toString() ?? '';
    final name = json['name']?.toString() ?? '';
    final locationLabel = [
      if (userAddress != null && userAddress.isNotEmpty) userAddress,
      if (type.isNotEmpty) type,
    ].join(' - ');

    return ProjectEntity(
      id: json['id']?.toString() ?? '',
      name: L10n(name, name),
      location: L10n(
        locationLabel.isEmpty ? '-' : locationLabel,
        locationLabel.isEmpty ? '-' : locationLabel,
      ),
      progress: _progressFor(type),
      status: _statusFor(type),
      phase: L10n(
        notes.isEmpty ? type : notes,
        notes.isEmpty ? type : notes,
      ),
      engineer: L10n(
        engineerName.isEmpty ? '-' : engineerName,
        engineerName.isEmpty ? '-' : engineerName,
      ),
      imageAsset: ImgAssets.loginCompanyHero,
      lastUpdated: const L10n('آخر تحديث من السيرفر', 'Updated from server'),
      clientName: clientName == null || clientName.isEmpty
          ? null
          : L10n(clientName, clientName),
      unitArea: area.isEmpty ? null : L10n('$area م²', '$area m²'),
      phases: const [],
    );
  }

  static double _progressFor(String type) {
    return switch (type) {
      'villa' => 0.55,
      'apartment' => 0.35,
      'retail_shop' => 0.7,
      _ => 0.25,
    };
  }

  static ProjectStatus _statusFor(String type) {
    return switch (type) {
      'retail_shop' => ProjectStatus.inProgress,
      'villa' => ProjectStatus.inProgress,
      'apartment' => ProjectStatus.started,
      _ => ProjectStatus.inProgress,
    };
  }
}
