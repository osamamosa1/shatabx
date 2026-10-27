import 'package:dartz/dartz.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/workspace_entities.dart';
import '../../domain/repositories/workspace_repository.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  static const notifications = <NotificationEntity>[
    NotificationEntity(
      id: 'n1',
      title: L10n('تقرير فحص جديد', 'New inspection report'),
      body: L10n(
        'تم رفع تقرير فحص التشطيبات لمشروع فيلا النرجس بانتظار اعتمادك.',
        'A finishes inspection report for Al Narjis Villa is waiting for your approval.',
      ),
      timeLabel: L10n('قبل 12 دقيقة', '12 minutes ago'),
      read: false,
    ),
    NotificationEntity(
      id: 'n2',
      title: L10n('زيارة ميدانية', 'Site visit'),
      body: L10n(
        'موعد زيارة المهندس لمشروع الملقا ريزيدنس غداً الساعة 10 صباحاً.',
        'The engineer visit for Al Malqa Residence is tomorrow at 10:00 AM.',
      ),
      timeLabel: L10n('قبل ساعة', '1 hour ago'),
      read: false,
    ),
    NotificationEntity(
      id: 'n3',
      title: L10n('تحديث تقدم', 'Progress update'),
      body: L10n(
        'ارتفع تقدم برج العليا إلى 92٪ بعد اعتماد مرحلة التسليم الابتدائي.',
        'Al Olaya Tower progress reached 92% after the initial handover was approved.',
      ),
      timeLabel: L10n('أمس', 'Yesterday'),
      read: true,
    ),
  ];

  static const reports = <ReportEntity>[
    ReportEntity(
      id: 'r1',
      title: L10n('فحص ضبط الجودة - التشطيبات', 'Quality inspection - finishes'),
      projectName: L10n('فيلا النرجس', 'Al Narjis Villa'),
      dateLabel: L10n('26 أكتوبر 2026', '26 Oct 2026'),
      status: L10n('بانتظار الاعتماد', 'Pending approval'),
      notes: L10n(
        'ملاحظات على دهانات الصالة الرئيسية ويلزم إعادة الفحص بعد المعالجة.',
        'Notes on the main hall paint. Re-inspection is required after the fix.',
      ),
    ),
    ReportEntity(
      id: 'r2',
      title: L10n('فحص الأعمال الكهربائية', 'Electrical inspection'),
      projectName: L10n('مبنى القيروان', 'Al Qirawan Building'),
      dateLabel: L10n('24 أكتوبر 2026', '24 Oct 2026'),
      status: L10n('معاد للفحص', 'Sent back'),
      notes: L10n(
        'لوحات التوزيع غير مكتملة التوسيم.',
        'Distribution boards are not fully labeled.',
      ),
    ),
    ReportEntity(
      id: 'r3',
      title: L10n('تقرير التسليم الابتدائي', 'Initial handover report'),
      projectName: L10n('برج العليا', 'Al Olaya Tower'),
      dateLabel: L10n('20 أكتوبر 2026', '20 Oct 2026'),
      status: L10n('معتمد', 'Approved'),
      notes: L10n(
        'تم الاعتماد مع ملاحظات بسيطة على أعمال الألمنيوم.',
        'Approved with minor notes on the aluminum works.',
      ),
    ),
  ];

  static const templates = <InspectionTemplateEntity>[
    InspectionTemplateEntity(
      id: 't1',
      name: L10n('قالب فحص التشطيبات', 'Finishes inspection template'),
      itemsCount: 12,
      category: L10n('تشطيبات', 'Finishes'),
      items: [
        L10n('استقامة الجدران والأسقف', 'Wall and ceiling alignment'),
        L10n('جودة الدهانات', 'Paint quality'),
        L10n('تركيب الأبواب', 'Door installation'),
        L10n('الأرضيات والوزرات', 'Floors and skirting'),
        L10n('العزل المائي في دورات المياه', 'Waterproofing in bathrooms'),
      ],
    ),
    InspectionTemplateEntity(
      id: 't2',
      name: L10n('قالب فحص الكهرباء', 'Electrical inspection template'),
      itemsCount: 9,
      category: L10n('كهرباء', 'Electrical'),
      items: [
        L10n('لوحات التوزيع', 'Distribution boards'),
        L10n('التأريض', 'Earthing'),
        L10n('نقاط الإنارة', 'Lighting points'),
        L10n('أفياش القوى', 'Power outlets'),
      ],
    ),
    InspectionTemplateEntity(
      id: 't3',
      name: L10n('قالب فحص السباكة', 'Plumbing inspection template'),
      itemsCount: 8,
      category: L10n('سباكة', 'Plumbing'),
      items: [
        L10n('ضغط شبكة المياه', 'Water network pressure'),
        L10n('ميول الصرف', 'Drainage slope'),
        L10n('عزل الخزان', 'Tank waterproofing'),
        L10n('تركيب الأدوات الصحية', 'Sanitary fixtures'),
      ],
    ),
  ];

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const Right(notifications);
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getReports() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const Right(reports);
  }

  @override
  Future<Either<Failure, ReportEntity>> getReport(String id) async {
    final match = reports.where((item) => item.id == id);
    if (match.isEmpty) {
      return const Left(ServerFailure(message: 'err_report_missing'));
    }
    return Right(match.first);
  }

  @override
  Future<Either<Failure, List<InspectionTemplateEntity>>> getTemplates() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const Right(templates);
  }

  @override
  Future<Either<Failure, InspectionTemplateEntity>> getTemplate(String id) async {
    final match = templates.where((item) => item.id == id);
    if (match.isEmpty) {
      return const Left(ServerFailure(message: 'err_template_missing'));
    }
    return Right(match.first);
  }
}
