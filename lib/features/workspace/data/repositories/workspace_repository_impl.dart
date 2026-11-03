import 'package:dartz/dartz.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/values/assets.dart';
import '../../domain/entities/workspace_entities.dart';
import '../../domain/repositories/workspace_repository.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  static final List<NotificationEntity> _notifications = <NotificationEntity>[
    const NotificationEntity(
      id: 'n1',
      title: L10n('تمت الموافقة على تقرير', 'Report approved'),
      body: L10n(
        'مرحلة التسليم النهائي - مجمع النخيل التجاري',
        'Final handover phase - Al Nakheel Commercial Complex',
      ),
      timeLabel: L10n('منذ : 5 دقائق', '5 minutes ago'),
      read: false,
    ),
    const NotificationEntity(
      id: 'n2',
      title: L10n('تنبيه تأخر مشروع', 'Project delay alert'),
      body: L10n(
        'فيلا الياسمين الفاخرة متأخرة عن الجدول الزمني',
        'Al Yasmeen Luxury Villa is behind schedule',
      ),
      timeLabel: L10n('منذ : 5 دقائق', '5 minutes ago'),
      read: false,
    ),
    const NotificationEntity(
      id: 'n3',
      title: L10n('مشكلة عالية الأولوية', 'High priority issue'),
      body: L10n(
        'تشققات في جدار الدور الثالث - برج الواحة السكني',
        'Cracks in 3rd floor wall - Al Waha Residential Tower',
      ),
      timeLabel: L10n('منذ : 5 دقائق', '5 minutes ago'),
      read: false,
    ),
    const NotificationEntity(
      id: 'n4',
      title: L10n(
        'تعليق جديد على المشكلة #ISS-412',
        'New comment on issue #ISS-412',
      ),
      body: L10n(
        'أضافت الشركة تعليقاً وصوراً جديدة لعملية الإصلاح.',
        'The company added a comment and new photos for the repair.',
      ),
      timeLabel: L10n('منذ : 5 دقائق', '5 minutes ago'),
      read: true,
    ),
  ];

  static const _defaultChecklist = <ReportChecklistItem>[
    ReportChecklistItem(
      title: L10n(
        'مطابقة الأعمال للمخططات المعتمدة',
        'Works match approved blueprints',
      ),
      compliant: true,
    ),
    ReportChecklistItem(
      title: L10n(
        'جودة التمديدات والمواد المستخدمة',
        'Quality of wiring and materials used',
      ),
      compliant: true,
    ),
    ReportChecklistItem(
      title: L10n(
        'سلامة تأريض اللوحات الكهربائية',
        'Safety of electrical panel earthing',
      ),
      compliant: false,
      note: L10n(
        'ملاحظة: وجود فراغات في ترابط شبكة الحديد عند زاوية المحور ج-12',
        'Note: Gaps found in steel mesh bonding at axis corner C-12',
      ),
      reply: L10n(
        'أرجو توفر اشتراطات السلامة المهنية قبل كل شئ',
        'Please ensure occupational safety requirements first',
      ),
      images: [ImgAssets.loginCompanyHero, ImgAssets.projectThumb2],
    ),
    ReportChecklistItem(
      title: L10n(
        'تمديد قنوات الضغط العالي والفرعية',
        'High and sub-voltage duct extensions',
      ),
      compliant: false,
      note: L10n(
        'يلزم تمديد قنوات الضغط العالي في الممرات الفرعية وربطها بالمحطة الفرعية بنسبة إنجاز جيدة.',
        'High-voltage ducts must be extended in sub-corridors and connected.',
      ),
      images: [ImgAssets.projectThumb3, ImgAssets.projectThumb4],
    ),
  ];

  static const reports = <ReportEntity>[
    ReportEntity(
      id: 'r1',
      title: L10n('تقرير فحص التمديدات والكهرباء', 'Wiring & Electrical Report'),
      projectName: L10n('مدارس المستقبل النموذجية', 'Future Model Schools'),
      dateLabel: L10n('26 أكتوبر 2026', '26 Oct 2026'),
      status: L10n('بانتظار المراجعة', 'Pending review'),
      statusType: ReportStatusType.pendingReview,
      engineerName: L10n('م. خالد العتيبي', 'Eng. Khalid Al-Otaibi'),
      phaseName: L10n('الهيكل الإنشائي', 'Structural frame'),
      notes: L10n(
        'التقرير قيد المراجعة حالياً من قبلك لاعتماد البنود أو طلب إعادة الفحص.',
        'The report is currently under your review to approve or request re-inspection.',
      ),
      checklist: _defaultChecklist,
    ),
    ReportEntity(
      id: 'r2',
      title: L10n('فحص أعمال المباني والخرسانة', 'Masonry & Concrete Inspection'),
      projectName: L10n('فيلا الياسمين الفاخرة', 'Al Yasmeen Luxury Villa'),
      dateLabel: L10n('24 أكتوبر 2026', '24 Oct 2026'),
      status: L10n('إعادة فحص', 'Re-inspect'),
      statusType: ReportStatusType.reinspect,
      engineerName: L10n('م. فيصل الدوسري', 'Eng. Faisal Al-Dosari'),
      phaseName: L10n('أعمال المباني', 'Building works'),
      notes: L10n(
        'تم إرسال إعادة الفحص مرة أخرى لوجود ملاحظات في الموقع.',
        'Sent back for re-inspection due to on-site notes.',
      ),
      checklist: _defaultChecklist,
    ),
    ReportEntity(
      id: 'r3',
      title: L10n('تقرير التسليم النهائي', 'Final Handover Report'),
      projectName: L10n('برج الواحة السكني', 'Al Waha Residential Tower'),
      dateLabel: L10n('20 أكتوبر 2026', '20 Oct 2026'),
      status: L10n('معتمدة', 'Approved'),
      statusType: ReportStatusType.approved,
      engineerName: L10n('م. سارة القحطاني', 'Eng. Sarah Al-Qahtani'),
      phaseName: L10n('التسليم النهائي', 'Final handover'),
      notes: L10n(
        'تم اعتماد جميع بنود الاستلام بنجاح وفق معايير الجودة.',
        'All handover items approved according to quality standards.',
      ),
      checklist: _defaultChecklist,
    ),
  ];

  static final List<InspectionTemplateEntity> _templates =
      <InspectionTemplateEntity>[
        const InspectionTemplateEntity(
          id: 't1',
          name: L10n('الكود المصري - شقة سكنية', 'Egyptian Code - Apartment'),
          itemsCount: 16,
          phasesCount: 4,
          inspectionsCount: 8,
          category: L10n('تشطيبات متكاملة', 'Full Finishes'),
          dateLabel: L10n('تاريخ الإنشاء: 12/6/2026', 'Created: 12/6/2026'),
          items: [
            L10n('استقامة الجدران والأسقف', 'Wall and ceiling alignment'),
            L10n('جودة الدهانات والمعجون', 'Paint and putty quality'),
            L10n('تركيب الأبواب والنجارة', 'Door and carpentry installation'),
            L10n('الأرضيات والوزرات والسيراميك', 'Floors, skirting & ceramics'),
            L10n('العزل المائي في دورات المياه', 'Waterproofing in bathrooms'),
          ],
        ),
        const InspectionTemplateEntity(
          id: 't2',
          name: L10n('الكود السعودي - فيلا فاخرة', 'Saudi Code - Luxury Villa'),
          itemsCount: 24,
          phasesCount: 6,
          inspectionsCount: 12,
          category: L10n('مقاولات وتشطيب', 'Contracting & Finishing'),
          dateLabel: L10n('تاريخ الإنشاء: 18/6/2026', 'Created: 18/6/2026'),
          items: [
            L10n('لوحات التوزيع الكهربائية', 'Electrical distribution boards'),
            L10n('سلامة التأريض والكابلات', 'Earthing and cable safety'),
            L10n('نقاط الإنارة والمفاتيح', 'Lighting points and switches'),
            L10n('اختبار ضغط شبكة التغذية', 'Water supply pressure test'),
          ],
        ),
        const InspectionTemplateEntity(
          id: 't3',
          name: L10n('قالب فحص الهيكل الإنشائي', 'Structural Frame Template'),
          itemsCount: 14,
          phasesCount: 3,
          inspectionsCount: 6,
          category: L10n('إنشائي', 'Structural'),
          dateLabel: L10n('تاريخ الإنشاء: 22/6/2026', 'Created: 22/6/2026'),
          items: [
            L10n('ترابط شبكة التسليح والحديد', 'Steel reinforcement bonding'),
            L10n('أبعاد الشدات الخشبية والمحاور', 'Formwork dimensions & axes'),
            L10n('جودة صب الخرسانة والمعالجة', 'Concrete pouring & curing'),
            L10n('عزل القواعد والرقاب', 'Foundation waterproofing'),
          ],
        ),
      ];

  static void clearNotifications() {
    _notifications.clear();
  }

  static void removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
  }

  static void addTemplate(InspectionTemplateEntity template) {
    _templates.insert(0, template);
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return Right(List.of(_notifications));
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getReports() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
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
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return Right(List.of(_templates));
  }

  @override
  Future<Either<Failure, InspectionTemplateEntity>> getTemplate(String id) async {
    final match = _templates.where((item) => item.id == id);
    if (match.isEmpty) {
      return const Left(ServerFailure(message: 'err_template_missing'));
    }
    return Right(match.first);
  }
}
