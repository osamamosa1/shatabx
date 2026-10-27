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
import '../cubit/complete_profile_cubit.dart';
import '../cubit/session_cubit.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _address = TextEditingController(text: 'الرياض، حي العليا');
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    if (!context.isArabic) _address.text = 'Riyadh, Al Olaya';
  }
  String? _companyImage;
  String? _stamp;

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionCubit>().state;
    final company = user is SessionAuthenticated
        ? (user.user.companyName ?? context.tr('company_logo'))
        : context.tr('company_logo');

    return BlocListener<CompleteProfileCubit, CompleteProfileState>(
      listener: (context, state) {
        if (state is CompleteProfileError) {
          AppSnackBar.show(context, context.tr(state.message), error: true);
        } else if (state is CompleteProfileSuccess) {
          context.read<SessionCubit>().setUser(state.user);
          context.go(AppRoutes.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
            children: [
              const AppBackButton(),
              SizedBox(height: 8.h),
              Text(
                context.tr('complete_profile'),
                textAlign: TextAlign.center,
                style: TextStyles.bold20(color: AppColors.text),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 22.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 36.r,
                      backgroundColor: AppColors.primarySoft,
                      child: Icon(Icons.apartment_rounded, color: AppColors.primary, size: 32.r),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(company, style: TextStyles.regular12(color: AppColors.white)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              MyTextFormField(
                controller: _address,
                label: context.tr('company_address'),
                hint: context.tr('address_hint'),
                prefix: Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20.r),
                validator: (value) => Validator.requiredField(context, value, label: context.tr('address_label')),
              ),
              SizedBox(height: 14.h),
              _UploadTile(
                label: context.tr('company_photo'),
                value: _companyImage,
                onTap: () => setState(() => _companyImage = 'company_photo.jpg'),
              ),
              SizedBox(height: 14.h),
              _UploadTile(
                label: context.tr('stamp'),
                value: _stamp,
                onTap: () => setState(() => _stamp = 'stamp.png'),
              ),
              SizedBox(height: 28.h),
              BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
                builder: (context, state) {
                  return MyDefaultButton(
                    text: context.tr('save_data'),
                    isLoading: state is CompleteProfileLoading,
                    onPressed: () {
                      final error = Validator.requiredField(context, _address.text, label: context.tr('address_label'));
                      if (error != null) {
                        AppSnackBar.show(context, error, error: true);
                        return;
                      }
                      context.read<CompleteProfileCubit>().save(
                        CompleteProfileParams(
                          address: _address.text,
                          companyImageName: _companyImage,
                          stampName: _stamp,
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
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.label,
    required this.onTap,
    this.value,
  });

  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, textAlign: TextAlign.start, style: TextStyles.medium14(color: AppColors.text)),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            height: 52.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.35), style: BorderStyle.solid),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value ?? context.tr('upload_photo'),
                  style: TextStyles.medium14(color: AppColors.primary),
                ),
                SizedBox(width: 6.w),
                Icon(Icons.file_upload_outlined, color: AppColors.primary, size: 18.r),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
