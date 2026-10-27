import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../domain/params/auth_params.dart';
import '../cubit/register_company_cubit.dart';
import '../models/auth_flow_args.dart';

class RegisterCompanyScreen extends StatefulWidget {
  const RegisterCompanyScreen({super.key});

  @override
  State<RegisterCompanyScreen> createState() => _RegisterCompanyScreenState();
}

class _RegisterCompanyScreenState extends State<RegisterCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _company = TextEditingController(text: 'شركة الإتقان للمقاولات');
  final _owner = TextEditingController(text: 'عبدالله الحربي');
  final _phone = TextEditingController(text: '10102548963');
  final _email = TextEditingController(text: 'company@example.com');
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _accepted = true;
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    if (!context.isArabic) {
      _company.text = 'Al Itqan Contracting';
      _owner.text = 'Abdullah Alharbi';
    }
  }

  @override
  void dispose() {
    _company.dispose();
    _owner.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_accepted) {
      AppSnackBar.show(context, context.tr('must_accept_terms'), error: true);
      return;
    }
    context.read<RegisterCompanyCubit>().submit(
      RegisterCompanyParams(
        companyName: _company.text,
        ownerName: _owner.text,
        phone: _phone.text,
        email: _email.text,
        password: _password.text,
        acceptedTerms: _accepted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCompanyCubit, RegisterCompanyState>(
      listener: (context, state) {
        if (state is RegisterCompanyError) {
          AppSnackBar.show(context, context.tr(state.message), error: true);
        } else if (state is RegisterCompanySuccess) {
          context.push(
            AppRoutes.otp,
            extra: OtpArgs(
              email: state.user.email,
              purpose: OtpPurpose.register,
              pendingUser: state.user,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              children: [
                const AppBackButton(),
                SizedBox(height: 12.h),
                Text(
                  context.tr('create_company'),
                  textAlign: TextAlign.center,
                  style: TextStyles.bold22(color: AppColors.text),
                ),
                SizedBox(height: 6.h),
                Text(
                  context.tr('create_company_sub'),
                  textAlign: TextAlign.center,
                  style: TextStyles.regular14(color: AppColors.textSecondary),
                ),
                SizedBox(height: 22.h),
                MyTextFormField(
                  controller: _company,
                  label: context.tr('company_name'),
                  hint: context.tr('company_name_hint'),
                  validator: (v) => Validator.requiredField(context, v, label: context.tr('company_name')),
                ),
                SizedBox(height: 14.h),
                MyTextFormField(
                  controller: _owner,
                  label: context.tr('owner_name'),
                  hint: context.tr('owner_name_hint'),
                  validator: (v) => Validator.requiredField(context, v, label: context.tr('owner_label')),
                ),
                SizedBox(height: 14.h),
                MyTextFormField(
                  controller: _phone,
                  label: context.tr('phone'),
                  hint: '10102548963',
                  keyboardType: TextInputType.phone,
                  prefix: const _DialCode(),
                  validator: (v) => Validator.phone(context, v),
                ),
                SizedBox(height: 14.h),
                MyTextFormField(
                  controller: _email,
                  label: context.tr('email'),
                  hint: 'company@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => Validator.email(context, v),
                ),
                SizedBox(height: 14.h),
                MyTextFormField(
                  controller: _password,
                  label: context.tr('password'),
                  hint: '••••••••',
                  obscure: true,
                  validator: (v) => Validator.password(context, v),
                ),
                SizedBox(height: 14.h),
                MyTextFormField(
                  controller: _confirm,
                  label: context.tr('confirm_password'),
                  hint: '••••••••',
                  obscure: true,
                  validator: (v) => Validator.confirmPassword(context, v, _password.text),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: Checkbox(
                        value: _accepted,
                        activeColor: AppColors.primary,
                        onChanged: (value) => setState(() => _accepted = value ?? false),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.terms),
                      child: Text(
                        context.tr('accept_terms'),
                        style: TextStyles.medium14(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                BlocBuilder<RegisterCompanyCubit, RegisterCompanyState>(
                  builder: (context, state) {
                    return MyDefaultButton(
                      text: context.tr('create_account'),
                      isLoading: state is RegisterCompanyLoading,
                      onPressed: _submit,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DialCode extends StatelessWidget {
  const _DialCode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🇪🇬', style: TextStyle(fontSize: 16.sp)),
          SizedBox(width: 4.w),
          Text('+20', style: TextStyles.medium14(color: AppColors.text)),
          Icon(Icons.keyboard_arrow_down_rounded, size: 18.r, color: AppColors.hint),
        ],
      ),
    );
  }
}
