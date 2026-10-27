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
import '../cubit/reset_password_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordError) {
          AppSnackBar.show(context, context.tr(state.message), error: true);
        } else if (state is ResetPasswordSuccess) {
          AppSnackBar.show(context, context.tr(state.message));
          context.go(AppRoutes.accountType);
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
                SizedBox(height: 28.h),
                Text(
                  context.tr('reset_title'),
                  textAlign: TextAlign.center,
                  style: TextStyles.bold22(color: AppColors.text),
                ),
                SizedBox(height: 8.h),
                Text(
                  context.tr('reset_sub'),
                  textAlign: TextAlign.center,
                  style: TextStyles.regular14(color: AppColors.textSecondary),
                ),
                SizedBox(height: 28.h),
                MyTextFormField(
                  controller: _password,
                  label: context.tr('new_password'),
                  hint: '••••••••',
                  obscure: true,
                  validator: (value) => Validator.password(context, value),
                ),
                SizedBox(height: 14.h),
                MyTextFormField(
                  controller: _confirm,
                  label: context.tr('confirm_new_password'),
                  hint: '••••••••',
                  obscure: true,
                  validator: (value) => Validator.confirmPassword(context, value, _password.text),
                ),
                SizedBox(height: 22.h),
                BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                  builder: (context, state) {
                    return MyDefaultButton(
                      text: context.tr('confirm'),
                      isLoading: state is ResetPasswordLoading,
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        context.read<ResetPasswordCubit>().submit(
                          ResetPasswordParams(
                            email: widget.email,
                            password: _password.text,
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
    );
  }
}
