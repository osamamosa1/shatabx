import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/error_message.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/params/auth_params.dart';
import '../../../auth/domain/usecases/auth_use_cases.dart';
import '../../../auth/presentation/cubit/session_cubit.dart';
import '../../../content/data/datasources/content_remote_data_source.dart';
import 'profile_sub_screens.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _old = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _old.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final session = context.read<SessionCubit>().state;
    final email =
        session is SessionAuthenticated ? session.user.email : '';
    if (email.isEmpty) {
      AppSnackBar.show(context, context.tr('no_session'), error: true);
      return;
    }
    setState(() => _saving = true);
    final result = await ServiceLocator.instance<UpdatePasswordUseCase>()(
      UpdatePasswordParams(
        email: email,
        password: _password.text,
        oldPassword: _old.text,
      ),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    result.fold(
      (failure) => AppSnackBar.show(
        context,
        resolveErrorMessage(context, failure.message),
        error: true,
      ),
      (_) {
        AppSnackBar.show(context, context.tr('password_updated'));
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            WhiteProfileHeader(title: context.tr('change_password')),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.r),
                  children: [
                    SoftRise(
                      child: MyTextFormField(
                        controller: _old,
                        label: context.tr('current_password'),
                        hint: '••••••••',
                        obscure: true,
                        validator: (v) => Validator.password(context, v),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SoftRise(
                      delay: const Duration(milliseconds: 40),
                      child: MyTextFormField(
                        controller: _password,
                        label: context.tr('new_password'),
                        hint: '••••••••',
                        obscure: true,
                        validator: (v) => Validator.password(context, v),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SoftRise(
                      delay: const Duration(milliseconds: 80),
                      child: MyTextFormField(
                        controller: _confirm,
                        label: context.tr('confirm_password'),
                        hint: '••••••••',
                        obscure: true,
                        validator: (v) => Validator.confirmPassword(
                          context,
                          v,
                          _password.text,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    MyDefaultButton(
                      text: context.tr('save_data'),
                      height: 48.h,
                      borderRadius: 16.r,
                      isLoading: _saving,
                      onPressed: _saving ? null : _submit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeEmailScreen extends StatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  State<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final session = ServiceLocator.instance<SessionCubit>().state;
    if (session is SessionAuthenticated) {
      _email.text = session.user.email;
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final result = await ServiceLocator.instance<UpdateEmailUseCase>()(
      UpdateEmailParams(
        email: _email.text.trim(),
        password: _password.text,
      ),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    result.fold(
      (failure) => AppSnackBar.show(
        context,
        resolveErrorMessage(context, failure.message),
        error: true,
      ),
      (user) async {
        await context.read<SessionCubit>().setUser(user);
        if (!mounted) return;
        AppSnackBar.show(context, context.tr('email_updated'));
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            WhiteProfileHeader(title: context.tr('change_email')),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.r),
                  children: [
                    SoftRise(
                      child: MyTextFormField(
                        controller: _email,
                        label: context.tr('email'),
                        hint: 'name@email.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => Validator.email(context, v),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SoftRise(
                      delay: const Duration(milliseconds: 40),
                      child: MyTextFormField(
                        controller: _password,
                        label: context.tr('password'),
                        hint: '••••••••',
                        obscure: true,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    MyDefaultButton(
                      text: context.tr('save_data'),
                      height: 48.h,
                      borderRadius: 16.r,
                      isLoading: _saving,
                      onPressed: _saving ? null : _submit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _saving = false;

  Future<void> _confirm() async {
    setState(() => _saving = true);
    final result = await ServiceLocator.instance<DeleteAccountUseCase>()(
      const NoParams(),
    );
    if (!mounted) return;
    setState(() => _saving = false);
    result.fold(
      (failure) => AppSnackBar.show(
        context,
        resolveErrorMessage(context, failure.message),
        error: true,
      ),
      (_) {
        context.read<SessionCubit>().forceLocalLogout();
        context.go(AppRoutes.accountType);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            WhiteProfileHeader(title: context.tr('delete_account')),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16.r),
                children: [
                  SoftRise(
                    child: Container(
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: AppColors.statusErrorLight,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        context.tr('delete_account_desc'),
                        style: TextStyles.regular14(color: AppColors.error),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  MyDefaultButton(
                    text: context.tr('delete_account'),
                    height: 48.h,
                    borderRadius: 16.r,
                    isLoading: _saving,
                    onPressed: _saving ? null : _confirm,
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

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final Future<List<Map<String, dynamic>>> _future =
      ServiceLocator.instance<ContentRemoteDataSource>().getPackages();
  String? _requestingId;

  Future<void> _request(String id) async {
    setState(() => _requestingId = id);
    try {
      await ServiceLocator.instance<ContentRemoteDataSource>()
          .requestSubscription(id);
      if (!mounted) return;
      AppSnackBar.show(context, context.tr('subscription_requested'));
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        resolveErrorMessage(context, error.toString()),
        error: true,
      );
    } finally {
      if (mounted) setState(() => _requestingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            WhiteProfileHeader(title: context.tr('packages')),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const LoadingView();
                  }
                  final items = snapshot.data ?? const <Map<String, dynamic>>[];
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        context.isArabic
                            ? 'لا توجد باقات حالياً'
                            : 'No packages available',
                        style: TextStyles.regular14(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.all(16.r),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final id = item['id']?.toString() ?? '';
                      final name = item['name']?.toString() ?? '-';
                      final price = item['price']?.toString() ?? '-';
                      final type = item['type']?.toString() ?? '';
                      final payment =
                          item['payment_type']?.toString() ?? '';
                      final requesting = _requestingId == id;
                      return SoftRise(
                        delay: Duration(milliseconds: 40 * index),
                        child: Container(
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.border),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(name, style: TextStyles.bold16()),
                              SizedBox(height: 6.h),
                              Text(
                                '${context.isArabic ? 'السعر' : 'Price'}: $price',
                                style: TextStyles.regular12(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (type.isNotEmpty || payment.isNotEmpty) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  '$type • $payment',
                                  style: TextStyles.regular12(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                              SizedBox(height: 12.h),
                              MyDefaultButton(
                                text: context.tr('request_package'),
                                height: 42.h,
                                borderRadius: 12.r,
                                isLoading: requesting,
                                onPressed: requesting || id.isEmpty
                                    ? null
                                    : () => _request(id),
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
