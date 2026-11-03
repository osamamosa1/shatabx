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
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/app_svg.dart';
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
  String? _companyImage;
  String? _stamp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    if (!context.isArabic) _address.text = 'Riyadh, Al Olaya';
  }

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: const Color(0xFFFCFCFC),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24.r),
                  ),
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
                        context.tr('complete_profile'),
                        textAlign: TextAlign.center,
                        style: TextStyles.bold18(color: AppColors.text),
                      ),
                    ),
                    SizedBox(width: 36.w),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                  children: [
                    SoftZoom(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 24.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(24.r),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0F000000),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            FloatingMotion(
                              offset: 6,
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 82.r,
                                    height: 82.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF0B2443),
                                        width: 1.2,
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      ImgAssets.companySetupLogo,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  PositionedDirectional(
                                    bottom: 6.h,
                                    start: -4.w,
                                    child: Container(
                                      width: 30.r,
                                      height: 30.r,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8FAFF),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 16.r,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SoftElastic(
                              delay: const Duration(milliseconds: 180),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.progressBlue,
                                  borderRadius: BorderRadius.circular(100.r),
                                ),
                                child: Text(
                                  context.tr('company_logo'),
                                  style: TextStyles.bold12(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SoftRise(
                      delay: const Duration(milliseconds: 50),
                      child: MyTextFormField(
                        controller: _address,
                        label: context.tr('company_address'),
                        hint: context.tr('address_hint'),
                        prefix: Padding(
                          padding: EdgeInsets.all(12.r),
                          child: AppSvg(
                            SvgAssets.location,
                            color: AppColors.primary,
                            size: 18.r,
                          ),
                        ),
                        validator: (value) => Validator.requiredField(
                          context,
                          value,
                          label: context.tr('address_label'),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    SoftRise(
                      delay: const Duration(milliseconds: 80),
                      child: _UploadTile(
                        label: context.tr('company_photo'),
                        value: _companyImage,
                        onTap: () =>
                            setState(() => _companyImage = 'company_photo.jpg'),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    SoftRise(
                      delay: const Duration(milliseconds: 110),
                      child: _UploadTile(
                        label: context.tr('stamp'),
                        value: _stamp,
                        onTap: () => setState(() => _stamp = 'stamp.png'),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    SoftRise(
                      delay: const Duration(milliseconds: 140),
                      child: BlocBuilder<
                        CompleteProfileCubit,
                        CompleteProfileState
                      >(
                        builder: (context, state) {
                          return MyDefaultButton(
                            text: context.tr('save_data'),
                            height: 48.h,
                            borderRadius: 16.r,
                            isLoading: state is CompleteProfileLoading,
                            onPressed: () {
                              final error = Validator.requiredField(
                                context,
                                _address.text,
                                label: context.tr('address_label'),
                              );
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
                    ),
                  ],
                ),
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
        Text(
          label,
          textAlign: TextAlign.start,
          style: TextStyles.medium14(color: AppColors.text),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            height: 56.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFB0CEDB),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppSvg(SvgAssets.upload, color: AppColors.primary, size: 18.r),
                SizedBox(width: 8.w),
                Text(
                  value ?? context.tr('upload_photo'),
                  style: TextStyles.regular12(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
