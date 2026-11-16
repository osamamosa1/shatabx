import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/error_message.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../content/data/datasources/content_remote_data_source.dart';
import '../../../language/presentation/cubit/locale_cubit.dart';

class EngineerManagementScreen extends StatefulWidget {
  const EngineerManagementScreen({super.key});

  @override
  State<EngineerManagementScreen> createState() =>
      _EngineerManagementScreenState();
}

class _EngineerManagementScreenState extends State<EngineerManagementScreen> {
  String _query = '';
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() {
    return ServiceLocator.instance<ContentRemoteDataSource>().getEngineers();
  }

  void _reload() => setState(() => _future = _load());

  Future<void> _addEngineerDialog() async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    var saving = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
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
                    controller: phoneCtrl,
                    label: context.tr('phone'),
                    hint: '01000000000',
                  ),
                  SizedBox(height: 10.h),
                  MyTextFormField(
                    controller: emailCtrl,
                    label: context.tr('email'),
                    hint: 'engineer@email.com',
                  ),
                  SizedBox(height: 10.h),
                  MyTextFormField(
                    controller: passwordCtrl,
                    label: context.tr('password'),
                    hint: '******',
                    obscure: true,
                  ),
                  SizedBox(height: 16.h),
                  MyDefaultButton(
                    text: context.tr('save_data'),
                    isLoading: saving,
                    onPressed: () async {
                      if (nameCtrl.text.trim().isEmpty ||
                          phoneCtrl.text.trim().isEmpty ||
                          emailCtrl.text.trim().isEmpty ||
                          passwordCtrl.text.trim().isEmpty) {
                        return;
                      }
                      setModal(() => saving = true);
                      try {
                        await ServiceLocator.instance<ContentRemoteDataSource>()
                            .addEngineer(
                          name: nameCtrl.text,
                          phone: phoneCtrl.text,
                          email: emailCtrl.text,
                          password: passwordCtrl.text,
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (mounted) {
                          _reload();
                          AppSnackBar.show(
                            context,
                            context.tr('engineer_added'),
                          );
                        }
                      } catch (error) {
                        setModal(() => saving = false);
                        if (mounted) {
                          AppSnackBar.show(
                            context,
                            resolveErrorMessage(context, error.toString()),
                            error: true,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LoadingView();
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      resolveErrorMessage(context, snapshot.error.toString()),
                    ),
                  );
                }
                final filtered = (snapshot.data ?? const [])
                    .where((e) {
                      final name = e['name']?.toString() ?? '';
                      return name.toLowerCase().contains(_query.toLowerCase());
                    })
                    .toList();
                return ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 80.h),
                  children: [
                    _SearchBox(
                      hint: context.tr('search_engineer'),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                    SizedBox(height: 14.h),
                    ...List.generate(filtered.length, (i) {
                      final item = filtered[i];
                      final name = item['name']?.toString() ?? '-';
                      final role = item['email']?.toString() ??
                          item['phone']?.toString() ??
                          '';
                      final id = item['id']?.toString() ?? '';
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
                                  ImgAssets.engineerAvatar,
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
                                    Text(name, style: TextStyles.bold14()),
                                    Text(
                                      role,
                                      style: TextStyles.regular12(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final host = this.context;
                                  try {
                                    await ServiceLocator.instance<
                                            ContentRemoteDataSource>()
                                        .deleteEngineer(id);
                                    _reload();
                                  } catch (error) {
                                    if (!host.mounted) return;
                                    AppSnackBar.show(
                                      host,
                                      resolveErrorMessage(
                                        host,
                                        error.toString(),
                                      ),
                                      error: true,
                                    );
                                  }
                                },
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
                );
              },
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
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Map<String, dynamic>>> _load() {
    return ServiceLocator.instance<ContentRemoteDataSource>().getCustomers();
  }

  void _reload() => setState(() => _future = _load());

  Future<void> _addClientDialog() async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    var saving = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
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
                    hint: '01000000000',
                  ),
                  SizedBox(height: 10.h),
                  MyTextFormField(
                    controller: emailCtrl,
                    label: context.tr('email'),
                    hint: 'client@email.com',
                  ),
                  SizedBox(height: 16.h),
                  MyDefaultButton(
                    text: context.tr('save_data'),
                    isLoading: saving,
                    onPressed: () async {
                      if (nameCtrl.text.trim().isEmpty ||
                          phoneCtrl.text.trim().isEmpty) {
                        return;
                      }
                      setModal(() => saving = true);
                      try {
                        await ServiceLocator.instance<ContentRemoteDataSource>()
                            .addCustomer(
                          name: nameCtrl.text,
                          phone: phoneCtrl.text,
                          email: emailCtrl.text,
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (mounted) {
                          _reload();
                          AppSnackBar.show(
                            context,
                            context.tr('client_added'),
                          );
                        }
                      } catch (error) {
                        setModal(() => saving = false);
                        if (mounted) {
                          AppSnackBar.show(
                            context,
                            resolveErrorMessage(context, error.toString()),
                            error: true,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LoadingView();
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      resolveErrorMessage(context, snapshot.error.toString()),
                    ),
                  );
                }
                final filtered = (snapshot.data ?? const [])
                    .where((c) {
                      final name = c['name']?.toString() ?? '';
                      return name.toLowerCase().contains(_query.toLowerCase());
                    })
                    .toList();
                return ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 80.h),
                  children: [
                    _SearchBox(
                      hint: context.tr('search_client'),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                    SizedBox(height: 14.h),
                    ...List.generate(filtered.length, (i) {
                      final item = filtered[i];
                      final name = item['name']?.toString() ?? '-';
                      final phone = item['phone']?.toString() ?? '';
                      final id = item['id']?.toString() ?? '';
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
                                    Text(name, style: TextStyles.bold14()),
                                    Text(
                                      phone,
                                      style: TextStyles.regular12(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final host = this.context;
                                  try {
                                    await ServiceLocator.instance<
                                            ContentRemoteDataSource>()
                                        .deleteCustomer(id);
                                    _reload();
                                  } catch (error) {
                                    if (!host.mounted) return;
                                    AppSnackBar.show(
                                      host,
                                      resolveErrorMessage(
                                        host,
                                        error.toString(),
                                      ),
                                      error: true,
                                    );
                                  }
                                },
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
                );
              },
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
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = ServiceLocator.instance<ContentRemoteDataSource>()
        .getSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Column(
        children: [
          _CurvedPrimaryHeader(title: context.tr('subscriptions'), rtl: rtl),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const LoadingView();
                }
                final all = snapshot.data ?? const <Map<String, dynamic>>[];
                final filtered = all.where((item) {
                  final active = item['active']?.toString() == '1' ||
                      item['active'] == 1 ||
                      item['active'] == true;
                  return _activeTab ? active : !active;
                }).toList();
                return ListView(
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
                    if (filtered.isEmpty)
                      SoftRise(
                        child: Container(
                          padding: EdgeInsets.all(18.r),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            context.isArabic
                                ? 'لا توجد اشتراكات في هذا التبويب'
                                : 'No subscriptions in this tab',
                            style: TextStyles.regular14(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ...List.generate(filtered.length, (index) {
                      final item = filtered[index];
                      final packageName =
                          item['package']?['name']?.toString() ??
                              item['package_id']?.toString() ??
                              (context.isArabic ? 'باقة' : 'Package');
                      final endDate = item['end_date']?.toString() ?? '-';
                      final projects =
                          item['num_projects']?.toString() ?? '0';
                      final engineers =
                          item['num_engineers']?.toString() ?? '0';
                      return SoftRise(
                        delay: Duration(milliseconds: 40 + (index * 40)),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12.h),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          packageName,
                                          style: TextStyles.bold18(
                                            color: AppColors.text,
                                          ),
                                        ),
                                        Text(
                                          '${context.isArabic ? 'السعر' : 'Price'}: ${item['price'] ?? '-'}',
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context.isArabic
                                        ? '$projects مشروع'
                                        : '$projects Projects',
                                    style: TextStyles.bold14(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    context.isArabic
                                        ? '$engineers مهندس'
                                        : '$engineers Engineers',
                                    style: TextStyles.bold14(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              Container(
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  context.isArabic
                                      ? 'صالحة حتى: $endDate'
                                      : 'Valid until: $endDate',
                                  style: TextStyles.bold14(
                                    color: AppColors.text,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
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

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  late final Future<String> _future = _load();

  Future<String> _load() async {
    try {
      final item = await ServiceLocator.instance<ContentRemoteDataSource>()
          .getSettingByKey('about_us');
      if (item != null && item.value.trim().isNotEmpty) return item.value;
    } catch (_) {}
    return '';
  }

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
                      child: FutureBuilder<String>(
                        future: _future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const LoadingView();
                          }
                          final remote = snapshot.data ?? '';
                          return Text(
                            remote.isEmpty
                                ? (context.isArabic
                                    ? 'منصة ShatabX هي الحل الرقمي المتكامل لشركات المقاولات والتشطيبات ومهندسي المواقع لإدارة المشاريع، متابعة مراحل التنفيذ، فحص الجودة الميداني، واعتماد التقارير المصورة بدقة واحترافية.'
                                    : 'ShatabX is the all-in-one digital platform for finishing companies and site engineers to manage construction projects, track phases, run field quality inspections, and approve photo reports seamlessly.')
                                : remote,
                            style: TextStyles.regular14(
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
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

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late final Future<List<Map<String, dynamic>>> _future =
      ServiceLocator.instance<ContentRemoteDataSource>().getCommonQuestions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            _WhiteHeader(title: context.tr('faq')),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const LoadingView();
                  }
                  final faqs = snapshot.data ?? const [];
                  if (faqs.isEmpty) {
                    return Center(
                      child: Text(
                        context.isArabic
                            ? 'لا توجد أسئلة شائعة حالياً'
                            : 'No FAQ items yet',
                        style: TextStyles.regular14(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(16.r),
                    itemCount: faqs.length,
                    itemBuilder: (context, index) {
                      final item = faqs[index];
                      final q = item['question']?.toString() ??
                          item['title']?.toString() ??
                          '';
                      final a = item['answer']?.toString() ??
                          item['value']?.toString() ??
                          '';
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
                              q,
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
                                a,
                                style: TextStyles.regular12(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
