import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../language/presentation/cubit/locale_cubit.dart';

class EngineerManagementScreen extends StatefulWidget {
  const EngineerManagementScreen({super.key});

  @override
  State<EngineerManagementScreen> createState() =>
      _EngineerManagementScreenState();
}

class _EngineerManagementScreenState extends State<EngineerManagementScreen> {
  String _query = '';
  final List<({String name, String role, String avatar})> _engineers = [
    (
      name: 'م. خالد العتيبي',
      role: 'مهندس موقع أول',
      avatar: ImgAssets.engineerAvatar,
    ),
    (
      name: 'م. فيصل الدوسري',
      role: 'مهندس تشطيبات',
      avatar: ImgAssets.companyAvatar,
    ),
    (
      name: 'م. سارة القحطاني',
      role: 'مهندسة جودة',
      avatar: ImgAssets.engineerAvatar,
    ),
  ];

  void _addEngineerDialog() {
    final nameCtrl = TextEditingController();
    final roleCtrl = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            16.h,
            20.w,
            MediaQuery.of(ctx).viewInsets.bottom + 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.tr('add_engineer'), style: TextStyles.bold18()),
              SizedBox(height: 12.h),
              MyTextFormField(
                controller: nameCtrl,
                label: context.tr('engineer'),
                hint: 'م. أحمد محمود',
              ),
              SizedBox(height: 10.h),
              MyTextFormField(
                controller: roleCtrl,
                label: context.tr('phase'),
                hint: 'مهندس موقع',
              ),
              SizedBox(height: 16.h),
              MyDefaultButton(
                text: context.tr('save_data'),
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _engineers.insert(0, (
                      name: nameCtrl.text.trim(),
                      role: roleCtrl.text.trim().isEmpty
                          ? 'مهندس موقع'
                          : roleCtrl.text.trim(),
                      avatar: ImgAssets.engineerAvatar,
                    ));
                  });
                  Navigator.pop(ctx);
                  AppSnackBar.show(context, context.tr('engineer_added'));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final filtered = _engineers
        .where((e) => e.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _addEngineerDialog,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(
          Icons.person_add_alt_1_rounded,
          color: AppColors.white,
          size: 24.r,
        ),
      ),
      body: Column(
        children: [
          _CurvedPrimaryHeader(title: context.tr('manage_engineers'), rtl: rtl),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 80.h),
              children: [
                _SearchBox(
                  hint: context.tr('search_engineer'),
                  onChanged: (v) => setState(() => _query = v),
                ),
                SizedBox(height: 14.h),
                ...List.generate(filtered.length, (i) {
                  final item = filtered[i];
                  return SoftRise(
                    delay: Duration(milliseconds: 40 + (i * 45)),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.asset(
                              item.avatar,
                              width: 42.r,
                              height: 42.r,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: TextStyles.bold14()),
                                Text(
                                  item.role,
                                  style: TextStyles.regular12(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                setState(() => _engineers.remove(item)),
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.error,
                              size: 20.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClientManagementScreen extends StatefulWidget {
  const ClientManagementScreen({super.key});

  @override
  State<ClientManagementScreen> createState() => _ClientManagementScreenState();
}

class _ClientManagementScreenState extends State<ClientManagementScreen> {
  String _query = '';
  final List<({String name, String phone})> _clients = [
    (name: 'علاء صفوان', phone: '+201208354274'),
    (name: 'يزيد حسن', phone: '+201140563239'),
    (name: 'معاذ أبوبكر', phone: '+201067857630'),
  ];

  void _addClientDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20.w,
            16.h,
            20.w,
            MediaQuery.of(ctx).viewInsets.bottom + 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(context.tr('add_client'), style: TextStyles.bold18()),
              SizedBox(height: 12.h),
              MyTextFormField(
                controller: nameCtrl,
                label: context.tr('client_name'),
                hint: 'علاء صفوان',
              ),
              SizedBox(height: 10.h),
              MyTextFormField(
                controller: phoneCtrl,
                label: context.tr('phone'),
                hint: '+201010254896',
              ),
              SizedBox(height: 16.h),
              MyDefaultButton(
                text: context.tr('save_data'),
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _clients.insert(0, (
                      name: nameCtrl.text.trim(),
                      phone: phoneCtrl.text.trim().isEmpty
                          ? '+201000000000'
                          : phoneCtrl.text.trim(),
                    ));
                  });
                  Navigator.pop(ctx);
                  AppSnackBar.show(context, context.tr('client_added'));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final filtered = _clients
        .where((c) => c.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _addClientDialog,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(
          Icons.person_add_alt_1_rounded,
          color: AppColors.white,
          size: 24.r,
        ),
      ),
      body: Column(
        children: [
          _CurvedPrimaryHeader(title: context.tr('manage_clients'), rtl: rtl),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 80.h),
              children: [
                _SearchBox(
                  hint: context.tr('search_client'),
                  onChanged: (v) => setState(() => _query = v),
                ),
                SizedBox(height: 14.h),
                ...List.generate(filtered.length, (i) {
                  final item = filtered[i];
                  return SoftRise(
                    delay: Duration(milliseconds: 40 + (i * 45)),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.r,
                            height: 40.r,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: AppColors.primarySoft,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_outline_rounded,
                              color: AppColors.primary,
                              size: 20.r,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: TextStyles.bold14()),
                                Text(
                                  item.phone,
                                  style: TextStyles.regular12(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                setState(() => _clients.remove(item)),
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.error,
                              size: 20.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  bool _activeTab = true;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          _CurvedPrimaryHeader(title: context.tr('subscriptions'), rtl: rtl),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              children: [
                Container(
                  height: 46.h,
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _activeTab = true),
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _activeTab
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              context.tr('active_subscriptions'),
                              style: TextStyles.bold12(
                                color: _activeTab
                                    ? AppColors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _activeTab = false),
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: !_activeTab
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              context.tr('expired_subscriptions'),
                              style: TextStyles.bold12(
                                color: !_activeTab
                                    ? AppColors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                SoftRise(
                  child: Container(
                    padding: EdgeInsets.all(18.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56.r,
                              height: 56.r,
                              decoration: BoxDecoration(
                                color: AppColors.primarySoft,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Icon(
                                Icons.workspace_premium_rounded,
                                color: AppColors.primary,
                                size: 30.r,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _activeTab
                                        ? (context.isArabic
                                              ? 'باقة بريميوم الاحترافية'
                                              : 'Premium Pro Plan')
                                        : (context.isArabic
                                              ? 'الباقة الأساسية'
                                              : 'Starter Plan'),
                                    style: TextStyles.bold18(
                                      color: AppColors.text,
                                    ),
                                  ),
                                  Text(
                                    context.isArabic
                                        ? 'الأنسب لشركات المقاولات والتشطيبات'
                                        : 'Best for contracting & finishing firms',
                                    style: TextStyles.regular12(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              context.isArabic ? '25 مشروعاً' : '25 Projects',
                              style: TextStyles.bold14(
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              context.isArabic ? '15 مهندساً' : '15 Engineers',
                              style: TextStyles.bold14(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: LinearProgressIndicator(
                            value: _activeTab ? 0.35 : 1.0,
                            minHeight: 8.h,
                            backgroundColor: AppColors.surface,
                            color: AppColors.progressBlue,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.isArabic
                                          ? 'صالحة حتى'
                                          : 'Valid until',
                                      style: TextStyles.regular12(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      '15/06/2027',
                                      style: TextStyles.bold14(
                                        color: AppColors.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.isArabic
                                          ? 'المشاريع المتبقية'
                                          : 'Remaining projects',
                                      style: TextStyles.regular12(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      _activeTab ? '17' : '0',
                                      style: TextStyles.bold14(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                MyDefaultButton(
                  text: context.tr('upgrade_package'),
                  height: 48.h,
                  borderRadius: 16.r,
                  onPressed: () =>
                      AppSnackBar.show(context, context.tr('upgrade_package')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PersonalProfileScreen extends StatelessWidget {
  const PersonalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final session = context.watch<SessionCubit>().state;
    final user = session is SessionAuthenticated ? session.user : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          _CurvedPrimaryHeader(title: context.tr('personal_profile'), rtl: rtl),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.r),
              children: [
                SoftZoom(
                  child: Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            ImgAssets.engineerAvatar,
                            width: 82.r,
                            height: 82.r,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          user?.name ?? 'م. خالد العتيبي',
                          style: TextStyles.bold18(),
                        ),
                        Text(
                          user?.email ?? 'engineer@shatabx.com',
                          style: TextStyles.regular14(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                SoftRise(
                  child: Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _ProfileRow(
                          label: context.tr('owner_name'),
                          value: user?.name ?? 'م. خالد العتيبي',
                        ),
                        const Divider(height: 24, color: AppColors.border),
                        _ProfileRow(
                          label: context.tr('phone'),
                          value: user?.phone ?? '+2010102548963',
                        ),
                        const Divider(height: 24, color: AppColors.border),
                        _ProfileRow(
                          label: context.tr('email'),
                          value: user?.email ?? 'engineer@shatabx.com',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleCubit>().state.locale.languageCode;
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            _WhiteHeader(title: context.tr('settings')),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.r),
                children: [
                  SoftRise(
                    child: Container(
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => context.read<LocaleCubit>().setLocale(
                              locale == 'ar' ? 'en' : 'ar',
                            ),
                            child: Row(
                              children: [
                                AppSvg(
                                  SvgAssets.language,
                                  size: 20.r,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    context.tr('language'),
                                    style: TextStyles.medium14(),
                                  ),
                                ),
                                Text(
                                  locale == 'ar'
                                      ? context.tr('arabic')
                                      : context.tr('english'),
                                  style: TextStyles.bold14(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            _WhiteHeader(title: context.tr('about_app')),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.r),
                children: [
                  SoftZoom(
                    child: Center(
                      child: Image.asset(ImgAssets.logo, height: 48.h),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SoftRise(
                    child: Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Text(
                        context.isArabic
                            ? 'منصة ShatabX هي الحل الرقمي المتكامل لشركات المقاولات والتشطيبات ومهندسي المواقع لإدارة المشاريع، متابعة مراحل التنفيذ، فحص الجودة الميداني، واعتماد التقارير المصورة بدقة واحترافية.'
                            : 'ShatabX is the all-in-one digital platform for finishing companies and site engineers to manage construction projects, track phases, run field quality inspections, and approve photo reports seamlessly.',
                        style: TextStyles.regular14(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      (
        q: context.isArabic
            ? 'كيف أضيف مشروعاً جديداً وأربطه بقالب فحص؟'
            : 'How do I create a project and link an inspection template?',
        a: context.isArabic
            ? 'من تبويب المشاريع اضغط على زر الإضافة (+)، وسيتم نسخ مراحل وبنود قالب الاستلامات المعتمد تلقائياً للمشروع.'
            : 'From the Projects tab tap (+); the default inspection template phases and items are automatically copied.',
      ),
      (
        q: context.isArabic
            ? 'كيف يرفع المهندس تقرير الفحص الميداني؟'
            : 'How does the site engineer submit an inspection report?',
        a: context.isArabic
            ? 'يدخل المهندس على المشروع المكلّف به، يختار المرحلة، ثم يحدد حالة كل بند (مطابق / غير مطابق) مع إرفاق الصور والملاحظات.'
            : 'The engineer opens the assigned project phase, marks each checklist item with photos and notes, and submits.',
      ),
      (
        q: context.isArabic
            ? 'ماذا يحدث عند طلب إعادة الفحص؟'
            : 'What happens when re-inspection is requested?',
        a: context.isArabic
            ? 'يصل إشعار فوري للمهندس المسؤول بالملاحظات المطلوب تلافيها ليعيد الفحص ويرفع الصور الجديدة.'
            : 'The assigned engineer receives an instant notification with notes to fix and re-submit.',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            _WhiteHeader(title: context.tr('faq')),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.r),
                itemCount: faqs.length,
                itemBuilder: (context, index) {
                  final item = faqs[index];
                  return SoftRise(
                    delay: Duration(milliseconds: 40 + (index * 45)),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          item.q,
                          style: TextStyles.bold14(color: AppColors.text),
                        ),
                        childrenPadding: EdgeInsets.fromLTRB(
                          16.w,
                          0,
                          16.w,
                          14.h,
                        ),
                        children: [
                          Text(
                            item.a,
                            style: TextStyles.regular12(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurvedPrimaryHeader extends StatelessWidget {
  const _CurvedPrimaryHeader({required this.title, required this.rtl});

  final String title;
  final bool rtl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(18.r)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: 34.r,
                height: 34.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: AppSvg(
                  rtl ? SvgAssets.arrowForward : SvgAssets.arrowBack,
                  size: 16.r,
                  color: AppColors.white,
                ),
              ),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.bold18(color: AppColors.white),
              ),
            ),
            SizedBox(width: 34.w),
          ],
        ),
      ),
    );
  }
}

class _WhiteHeader extends StatelessWidget {
  const _WhiteHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14B8B8B8),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const AppBackButton(),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.bold18(color: AppColors.text),
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.hint, required this.onChanged});

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyles.regular12(color: AppColors.text),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyles.regular12(color: const Color(0xFF666C6B)),
          prefixIcon: Padding(
            padding: EdgeInsets.all(11.r),
            child: AppSvg(SvgAssets.search, size: 18.r),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyles.regular12(color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(value, style: TextStyles.bold14(color: AppColors.text)),
      ],
    );
  }
}
