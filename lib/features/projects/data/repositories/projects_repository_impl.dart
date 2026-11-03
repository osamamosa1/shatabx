import 'package:dartz/dartz.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/values/assets.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  static const _defaultPhases = <ProjectPhaseItem>[
    ProjectPhaseItem(
      title: L10n('الأعمال التحضيرية', 'Preparatory works'),
      lastCheckLabel: L10n('الفحص الأخير: 2/7/2026', 'Last check: 2/7/2026'),
      progress: 1.0,
      statusLabel: L10n('مكتمل', 'Completed'),
      itemsCount: 5,
      completed: true,
    ),
    ProjectPhaseItem(
      title: L10n('الهيكل الإنشائي', 'Structural frame'),
      lastCheckLabel: L10n('الفحص الأخير: 2/7/2026', 'Last check: 2/7/2026'),
      progress: 0.35,
      statusLabel: L10n('قيد التنفيذ', 'In progress'),
      itemsCount: 5,
      completed: false,
    ),
    ProjectPhaseItem(
      title: L10n('التمديدات والكهرباء', 'Wiring & electrical'),
      lastCheckLabel: L10n('لم تبدأ بعد', 'Not started yet'),
      progress: 0.0,
      statusLabel: L10n('لم يبدأ', 'Not started'),
      itemsCount: 0,
      completed: false,
    ),
    ProjectPhaseItem(
      title: L10n('أعمال التشطيبات', 'Finishing works'),
      lastCheckLabel: L10n('لم تبدأ بعد', 'Not started yet'),
      progress: 0.0,
      statusLabel: L10n('لم يبدأ', 'Not started'),
      itemsCount: 4,
      completed: false,
    ),
  ];

  static final List<ProjectEntity> _items = <ProjectEntity>[
    const ProjectEntity(
      id: 'p1',
      name: L10n('مدارس المستقبل النموذجية', 'Future Model Schools'),
      location: L10n('الرياض - حي النرجس', 'Riyadh - Al Narjis'),
      progress: 0.35,
      status: ProjectStatus.inProgress,
      phase: L10n('التمديدات والكهرباء', 'Wiring & electrical'),
      engineer: L10n('محمد علي', 'Mohamed Ali'),
      imageAsset: ImgAssets.loginCompanyHero,
      lastUpdated: L10n('آخر تحديث قبل 3 أيام', 'Updated 3 days ago'),
      clientName: L10n('شركة أزور للمقاولات', 'Azure Contracting'),
      startDate: '8-4-2026',
      endDate: '19-1-2027',
      unitArea: L10n('450 م²', '450 m²'),
      phases: _defaultPhases,
    ),
    const ProjectEntity(
      id: 'p2',
      name: L10n('فيلا الياسمين الفاخرة', 'Al Yasmeen Luxury Villa'),
      location: L10n('الرياض - حي النرجس', 'Riyadh - Al Narjis'),
      progress: 0.05,
      status: ProjectStatus.started,
      phase: L10n('أعمال المباني', 'Building works'),
      engineer: L10n('محمد علي', 'Mohamed Ali'),
      imageAsset: ImgAssets.projectThumb2,
      lastUpdated: L10n('آخر تحديث قبل 3 أيام', 'Updated 3 days ago'),
      clientName: L10n('علاء صفوان', 'Alaa Safwan'),
      startDate: '12-5-2026',
      endDate: '20-12-2026',
      unitArea: L10n('320 م²', '320 m²'),
      phases: _defaultPhases,
    ),
    const ProjectEntity(
      id: 'p3',
      name: L10n('مجمع النخيل التجاري', 'Al Nakheel Commercial Complex'),
      location: L10n('الدمام - طريق الملك سعود', 'Dammam - King Saud Rd'),
      progress: 0.75,
      status: ProjectStatus.delayed,
      phase: L10n('في مرحلة التسليم', 'Handover stage'),
      engineer: L10n('م. خالد العتيبي', 'Eng. Khalid Al-Otaibi'),
      imageAsset: ImgAssets.projectThumb3,
      lastUpdated: L10n('آخر تحديث قبل 3 أيام', 'Updated 3 days ago'),
      clientName: L10n('يزيد حسن', 'Yazeed Hassan'),
      startDate: '1-1-2026',
      endDate: '1-10-2026',
      unitArea: L10n('1200 م²', '1200 m²'),
      phases: _defaultPhases,
    ),
    const ProjectEntity(
      id: 'p4',
      name: L10n('برج الواحة السكني', 'Al Waha Residential Tower'),
      location: L10n('الدمام - طريق الملك سعود', 'Dammam - King Saud Rd'),
      progress: 1.0,
      status: ProjectStatus.completed,
      phase: L10n('إكتمل التسليم', 'Handover completed'),
      engineer: L10n('محمد علي', 'Mohamed Ali'),
      imageAsset: ImgAssets.projectThumb4,
      lastUpdated: L10n('آخر تحديث قبل 3 أيام', 'Updated 3 days ago'),
      clientName: L10n('معاذ أبوبكر', 'Moaz Abubakr'),
      startDate: '10-6-2025',
      endDate: '15-5-2026',
      unitArea: L10n('850 م²', '850 m²'),
      phases: _defaultPhases,
    ),
  ];

  static List<ProjectEntity> get items => List.unmodifiable(_items);

  static void addProject(ProjectEntity project) {
    _items.insert(0, project);
  }

  @override
  Future<Either<Failure, List<ProjectEntity>>> getProjects() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return Right(List.of(_items));
  }

  @override
  Future<Either<Failure, ProjectEntity>> getProject(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final match = _items.where((item) => item.id == id);
    if (match.isEmpty) {
      return const Left(ServerFailure(message: 'err_project_missing'));
    }
    return Right(match.first);
  }
}
