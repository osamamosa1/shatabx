import 'dart:math' as math;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/validator.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../../../core/widgets/my_text_field.dart';
import '../../../language/presentation/cubit/locale_cubit.dart';
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
  final _password = TextEditingController(text: '123456');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _engineer => widget.role == AccountRole.engineer;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final locale = context.watch<LocaleCubit>().state.locale.languageCode;

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
        backgroundColor: const Color(0xFFF9FAFF),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 360.h,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20.r),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ZoomIn(
                      duration: const Duration(milliseconds: 850),
                      from: 1.08,
                      child: Image.asset(
                        _engineer
                            ? ImgAssets.loginEngineer
                            : ImgAssets.loginCompanyHero,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.18),
                            const Color(0x441E2680),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PositionedDirectional(
              bottom: 0,
              end: -10.w,
              child: IgnorePointer(
                child: FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 700),
                  child: Opacity(
                    opacity: 0.65,
                    child: AppSvg(SvgAssets.xWatermark, size: 110.r),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  SoftDrop(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          TapScale(
                            child: InkWell(
                              onTap: () => context.pop(),
                              borderRadius: BorderRadius.circular(8.r),
                              child: Container(
                                width: 34.r,
                                height: 34.r,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                  ),
                                ),
                                child: AppSvg(
                                  rtl
                                      ? SvgAssets.arrowForward
                                      : SvgAssets.arrowBack,
                                  size: 16.r,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (_engineer)
                            TapScale(
                              child: InkWell(
                                onTap: () => context
                                    .read<LocaleCubit>()
                                    .setLocale(locale == 'ar' ? 'en' : 'ar'),
                                borderRadius: BorderRadius.circular(100.r),
                                child: Container(
                                  width: 40.r,
                                  height: 40.r,
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF262A3B),
                                    shape: BoxShape.circle,
                                  ),
                                  child: AppSvg(
                                    SvgAssets.language,
                                    size: 20.r,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(16.w, 80.h, 16.w, 24.h),
                        child: SoftZoom(
                          delay: const Duration(milliseconds: 60),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 24.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(24.r),
                              border: Border.all(
                                color: const Color(0xFFE5E7ED),
                                width: 0.8,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x14000000),
                                  blurRadius: 28,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      SoftDrop(
                                        delay: const Duration(
                                          milliseconds: 120,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              _engineer
                                                  ? context.tr('engineer_login')
                                                  : context.tr('company_login'),
                                              textAlign: TextAlign.center,
                                              style: TextStyles.bold24(
                                                color: AppColors.text,
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            Text(
                                              _engineer
                                                  ? context.tr(
                                                      'engineer_login_sub',
                                                    )
                                                  : context.tr(
                                                      'company_login_sub',
                                                    ),
                                              textAlign: TextAlign.center,
                                              style: TextStyles.regular12(
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!_engineer)
                                        PositionedDirectional(
                                          top: -12.h,
                                          end: 0,
                                          child: ElasticIn(
                                            delay: const Duration(
                                              milliseconds: 260,
                                            ),
                                            duration: const Duration(
                                              milliseconds: 700,
                                            ),
                                            child: Transform.rotate(
                                              angle: -3.78 * math.pi / 180,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8.w,
                                                  vertical: 3.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.brand2,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                              12.r,
                                                            ),
                                                        bottomLeft:
                                                            Radius.circular(
                                                              12.r,
                                                            ),
                                                      ),
                                                ),
                                                child: Text(
                                                  'Shatab X',
                                                  style: TextStyles.poppins(
                                                    size: 13,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 22.h),
                                  SoftRise(
                                    delay: const Duration(milliseconds: 170),
                                    child: MyTextFormField(
                                      controller: _email,
                                      label: context.tr('email'),
                                      hint: 'company@example.com',
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) =>
                                          Validator.email(context, value),
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  SoftRise(
                                    delay: const Duration(milliseconds: 230),
                                    child: MyTextFormField(
                                      controller: _password,
                                      label: context.tr('password'),
                                      hint: context.tr('password'),
                                      obscure: true,
                                      validator: (value) =>
                                          Validator.password(context, value),
                                    ),
                                  ),
                                  SoftSlideEnd(
                                    delay: const Duration(milliseconds: 270),
                                    child: Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: TextButton(
                                        onPressed: () => context.push(
                                          '${AppRoutes.otp}?purpose=reset&email=${Uri.encodeComponent(_email.text.trim())}&role=${widget.role.name}',
                                        ),
                                        child: Text(
                                          context.tr('forgot_password'),
                                          style: TextStyles.medium12(
                                            color: const Color(0xFF003A53),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  SoftRise(
                                    delay: const Duration(milliseconds: 320),
                                    child: BlocBuilder<LoginCubit, LoginState>(
                                      builder: (context, state) {
                                        return MyDefaultButton(
                                          text: context.tr('sign_in'),
                                          height: 48.h,
                                          borderRadius: 16.r,
                                          isLoading: state is LoginLoading,
                                          onPressed: () {
                                            if (!_formKey.currentState!
                                                .validate()) {
                                              return;
                                            }
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
                                  ),
                                  if (!_engineer) ...[
                                    SizedBox(height: 16.h),
                                    SoftFade(
                                      delay: const Duration(milliseconds: 380),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            context.tr('no_account'),
                                            style: TextStyles.regular14(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                context.push(AppRoutes.register),
                                            child: Text(
                                              context.tr('create_new_account'),
                                              style: TextStyles.bold14(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
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
