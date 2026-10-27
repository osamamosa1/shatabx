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
import '../../domain/entities/user_entity.dart';
import '../../domain/params/auth_params.dart';
import '../cubit/login_cubit.dart';
import '../cubit/session_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.role});

  final AccountRole role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'company@example.com');
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _engineer => widget.role == AccountRole.engineer;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          AppSnackBar.show(context, context.tr(state.message), error: true);
        } else if (state is LoginSuccess) {
          context.read<SessionCubit>().setUser(state.user);
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            _Hero(engineer: _engineer, onBack: () => context.pop()),
            Expanded(
              child: Transform.translate(
                offset: Offset(0, -28.h),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 24.h),
                      children: [
                        Text(
                          _engineer ? context.tr('engineer_login') : context.tr('company_login'),
                          textAlign: TextAlign.center,
                          style: TextStyles.bold22(color: AppColors.text),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          _engineer
                              ? context.tr('engineer_login_sub')
                              : context.tr('company_login_sub'),
                          textAlign: TextAlign.center,
                          style: TextStyles.regular14(color: AppColors.textSecondary),
                        ),
                        SizedBox(height: 22.h),
                        MyTextFormField(
                          controller: _email,
                          label: context.tr('email'),
                          hint: 'company@example.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => Validator.email(context, value),
                        ),
                        SizedBox(height: 14.h),
                        MyTextFormField(
                          controller: _password,
                          label: context.tr('password'),
                          hint: context.tr('password'),
                          obscure: true,
                          validator: (value) => Validator.password(context, value),
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: TextButton(
                            onPressed: () => context.push(
                              '${AppRoutes.otp}?purpose=reset&email=${Uri.encodeComponent(_email.text.trim())}&role=${widget.role.name}',
                            ),
                            child: Text(
                              context.tr('forgot_password'),
                              style: TextStyles.medium14(color: AppColors.primary),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            return MyDefaultButton(
                              text: context.tr('sign_in'),
                              isLoading: state is LoginLoading,
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;
                                context.read<LoginCubit>().login(
                                  LoginParams(
                                    email: _email.text,
                                    password: _password.text,
                                    role: widget.role,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.engineer, required this.onBack});

  final bool engineer;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.h,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppGradients.loginHero,
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Center(
              child: Icon(
                engineer ? Icons.engineering_rounded : Icons.apartment_rounded,
                size: 92.r,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
            PositionedDirectional(
              top: 8.h,
              start: 16.w,
              child: AppBackButton(onTap: onBack),
            ),
          ],
        ),
      ),
    );
  }
}
