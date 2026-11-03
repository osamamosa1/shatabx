import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/resend_otp_cubit.dart';
import '../cubit/session_cubit.dart';
import '../cubit/verify_otp_cubit.dart';
import '../models/auth_flow_args.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.args});

  final OtpArgs args;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _controllers = List.generate(
    4,
    (_) => TextEditingController(text: '5'),
  );
  final _nodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    context.read<VerifyOtpCubit>().startTimer();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VerifyOtpCubit, VerifyOtpState>(
          listener: (context, state) {
            if (state is VerifyOtpError) {
              AppSnackBar.show(context, context.tr(state.message), error: true);
            } else if (state is VerifyOtpSuccess) {
              final user = widget.args.pendingUser;
              if (widget.args.purpose == OtpPurpose.register &&
                  user is UserEntity) {
                context.read<SessionCubit>().setUser(user).then((_) {
                  if (context.mounted) context.push(AppRoutes.completeProfile);
                });
              } else {
                context.push(AppRoutes.resetPassword, extra: widget.args.email);
              }
            }
          },
        ),
        BlocListener<ResendOtpCubit, ResendOtpState>(
          listener: (context, state) {
            if (state is ResendOtpSuccess) {
              AppSnackBar.show(context, context.tr(state.message));
              context.read<VerifyOtpCubit>().startTimer();
            } else if (state is ResendOtpError) {
              AppSnackBar.show(context, context.tr(state.message), error: true);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFCFC),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Column(
              children: [
                const AppBackButton(),
                SizedBox(height: 24.h),
                SoftDrop(
                  child: Column(
                    children: [
                      Text(
                        context.tr('otp_title'),
                        style: TextStyles.bold24(color: AppColors.text),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        widget.args.purpose == OtpPurpose.register
                            ? context.tr('otp_register_sub')
                            : context.tr('otp_reset_sub'),
                        textAlign: TextAlign.center,
                        style: TextStyles.regular14(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (widget.args.email.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          widget.args.email,
                          style: TextStyles.medium14(color: AppColors.primary),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 28.h),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final box = ((constraints.maxWidth - 36) / 4).clamp(
                        52.0,
                        72.0,
                      );
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return ZoomIn(
                            delay: Duration(milliseconds: 70 + (index * 85)),
                            duration: const Duration(milliseconds: 520),
                            curve: Curves.easeOutBack,
                            child: Container(
                              width: box,
                              height: box,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(14.r),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0D000000),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _nodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: TextStyles.bold22(color: AppColors.text),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1),
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: AppColors.white,
                                  contentPadding: EdgeInsets.zero,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: const BorderSide(
                                      color: AppColors.border,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.4,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty && index < 3) {
                                    _nodes[index + 1].requestFocus();
                                  } else if (value.isEmpty && index > 0) {
                                    _nodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                SoftRise(
                  delay: const Duration(milliseconds: 340),
                  child: BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                    builder: (context, state) {
                      final seconds = switch (state) {
                        VerifyOtpReady(:final secondsLeft) => secondsLeft,
                        VerifyOtpLoading(:final secondsLeft) => secondsLeft,
                        VerifyOtpError(:final secondsLeft) => secondsLeft,
                        _ => 0,
                      };
                      final label = '0:${seconds.toString().padLeft(2, '0')}';
                      return Row(
                        children: [
                          TextButton(
                            onPressed: seconds == 0
                                ? () => context.read<ResendOtpCubit>().resend(
                                    widget.args.email,
                                  )
                                : null,
                            child: Text(
                              context.tr('resend_otp'),
                              style: TextStyles.medium12(
                                color: seconds == 0
                                    ? AppColors.primary
                                    : AppColors.hint,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            label,
                            style: TextStyles.medium14(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                SoftRise(
                  delay: const Duration(milliseconds: 420),
                  child: BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                    builder: (context, state) {
                      return MyDefaultButton(
                        text: context.tr('confirm'),
                        height: 48.h,
                        borderRadius: 16.r,
                        isLoading: state is VerifyOtpLoading,
                        onPressed: () {
                          if (_code.length < 4) {
                            AppSnackBar.show(
                              context,
                              context.tr('otp_incomplete'),
                              error: true,
                            );
                            return;
                          }
                          context.read<VerifyOtpCubit>().verify(
                            email: widget.args.email,
                            code: _code,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
