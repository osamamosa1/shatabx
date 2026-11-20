import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/error_message.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../../../injection_container.dart';
import '../../../content/data/datasources/content_remote_data_source.dart';
import '../cubit/session_cubit.dart';
import '../widgets/subscriptions_header.dart';

class PackageDetailsScreen extends StatefulWidget {
  const PackageDetailsScreen({super.key, required this.package});

  final Map<String, dynamic> package;

  @override
  State<PackageDetailsScreen> createState() => _PackageDetailsScreenState();
}

class _PackageDetailsScreenState extends State<PackageDetailsScreen> {
  bool _yearly = false;
  bool _saving = false;

  num get _monthlyPrice =>
      num.tryParse(widget.package['price']?.toString() ?? '') ?? 0;

  num get _yearlyPrice => (_monthlyPrice * 10).round();

  String _formatPrice(num value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  String get _displayPrice =>
      _formatPrice(_yearly ? _yearlyPrice : _monthlyPrice);

  Future<void> _confirm() async {
    final id = widget.package['id']?.toString() ?? '';
    if (id.isEmpty) return;
    setState(() => _saving = true);
    try {
      await ServiceLocator.instance<ContentRemoteDataSource>()
          .requestSubscription(id);
    } catch (_) {}
    if (!mounted) return;
    final email = context.read<SessionCubit>().state is SessionAuthenticated
        ? (context.read<SessionCubit>().state as SessionAuthenticated)
            .user
            .email
        : null;
    await context.read<SessionCubit>().forceLocalLogout();
    if (!mounted) return;
    setState(() => _saving = false);
    context.go(AppRoutes.pendingApproval, extra: email);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.package['name']?.toString() ?? '-';
    final projects = widget.package['num_projects']?.toString() ?? '0';
    final engineers = widget.package['num_engineers']?.toString() ?? '0';
    final description = widget.package['description']?.toString().trim();
    final fallbackDesc = context.isArabic
        ? 'للشركات الناشئة والفرق الصغيرة'
        : 'For startups and small teams';
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final buttonHeight = 50.h.clamp(46.0, 56.0);
    final iconSize = 40.r.clamp(34.0, 44.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: Column(
        children: [
          const SubscriptionsHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 360;
                return ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                  children: [
                    SoftDrop(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            context.tr('package_details'),
                            textAlign: TextAlign.start,
                            style: TextStyles.bold22(color: AppColors.text),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            context.tr('package_details_sub'),
                            textAlign: TextAlign.start,
                            softWrap: true,
                            style: TextStyles.regular14(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SoftRise(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.r.clamp(12.0, 16.0)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF6FA),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  context.tr('most_popular'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyles.bold10(
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 22.r.clamp(20.0, 24.0),
                                  height: 22.r.clamp(20.0, 24.0),
                                  margin: EdgeInsets.only(top: 2.h),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 14.r.clamp(12.0, 16.0),
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        softWrap: true,
                                        style: TextStyles.bold16(),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        (description == null ||
                                                description.isEmpty)
                                            ? fallbackDesc
                                            : description,
                                        softWrap: true,
                                        style: TextStyles.regular12(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        context.isArabic
                                            ? 'خاصه بالابليكيشن والداش بورد'
                                            : 'App & dashboard access',
                                        softWrap: true,
                                        style: TextStyles.regular12(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Text(
                                          context.isArabic
                                              ? '$_displayPrice / ${_yearly ? "سنوياً" : "شهرياً"}'
                                              : '$_displayPrice / ${_yearly ? "year" : "month"}',
                                          maxLines: 1,
                                          style: TextStyles.bold18(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  width: iconSize,
                                  height: iconSize,
                                  padding:
                                      EdgeInsets.all(8.r.clamp(6.0, 10.0)),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Image.asset(
                                    ImgAssets.logoDark,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (narrow)
                      Column(
                        children: [
                          _BillingOption(
                            label: context.tr('billing_monthly'),
                            price: _formatPrice(_monthlyPrice),
                            selected: !_yearly,
                            onTap: () => setState(() => _yearly = false),
                          ),
                          SizedBox(height: 12.h),
                          _BillingOption(
                            label: context.tr('billing_yearly'),
                            price: _formatPrice(_yearlyPrice),
                            selected: _yearly,
                            badge: context.tr('save_two_months'),
                            onTap: () => setState(() => _yearly = true),
                          ),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _BillingOption(
                              label: context.tr('billing_monthly'),
                              price: _formatPrice(_monthlyPrice),
                              selected: !_yearly,
                              onTap: () => setState(() => _yearly = false),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _BillingOption(
                              label: context.tr('billing_yearly'),
                              price: _formatPrice(_yearlyPrice),
                              selected: _yearly,
                              badge: context.tr('save_two_months'),
                              onTap: () => setState(() => _yearly = true),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 18.h),
                    Text(
                      context.tr('package_limits'),
                      style: TextStyles.bold16(),
                    ),
                    SizedBox(height: 10.h),
                    SoftRise(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            _LimitRow(
                              label: context.tr('projects'),
                              value: context.isArabic
                                  ? '$projects مشروعاً'
                                  : '$projects projects',
                            ),
                            Divider(height: 20.h, color: AppColors.border),
                            _LimitRow(
                              label: context.tr('engineers_stat'),
                              value: context.isArabic
                                  ? '$engineers مهندساً'
                                  : '$engineers engineers',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Text(
                      context.tr('package_features_included'),
                      style: TextStyles.bold16(),
                    ),
                    SizedBox(height: 10.h),
                    SoftRise(
                      delay: const Duration(milliseconds: 60),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.r.clamp(12.0, 16.0)),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            _FeatureRow(
                              text: context.tr('package_feature_base'),
                            ),
                            SizedBox(height: 12.h),
                            _FeatureRow(
                              text: context.tr('package_feature_reports'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Material(
            color: const Color(0xFFF5F7F9),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                16.w,
                8.h,
                16.w,
                12.h + bottomInset,
              ),
              child: MyDefaultButton(
                text: context.tr('confirm_package'),
                height: buttonHeight,
                borderRadius: 14.r,
                color: AppColors.primaryDark,
                isLoading: _saving,
                onPressed: _saving
                    ? null
                    : () async {
                        try {
                          await _confirm();
                        } catch (error) {
                          if (!context.mounted) return;
                          setState(() => _saving = false);
                          final message =
                              resolveErrorMessage(context, error.toString());
                          AppSnackBar.show(context, message, error: true);
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillingOption extends StatelessWidget {
  const _BillingOption({
    required this.label,
    required this.price,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  final String label;
  final String price;
  final bool selected;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14.r),
            child: Ink(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h.clamp(12.0, 16.0),
              ),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFEEF6FA) : AppColors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20.r.clamp(18.0, 22.0),
                    height: 20.r.clamp(18.0, 22.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? AppColors.primary : AppColors.white,
                      border: Border.all(
                        color:
                            selected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: selected
                        ? Icon(
                            Icons.check_rounded,
                            size: 12.r.clamp(10.0, 14.0),
                            color: AppColors.white,
                          )
                        : null,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.medium12(),
                        ),
                        SizedBox(height: 4.h),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            price,
                            maxLines: 1,
                            style: TextStyles.bold14(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (badge != null)
          PositionedDirectional(
            top: -10.h,
            start: 8.w,
            child: Container(
              constraints: BoxConstraints(maxWidth: 120.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                badge!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.bold10(color: AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }
}

class _LimitRow extends StatelessWidget {
  const _LimitRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 4,
          child: Text(
            label,
            softWrap: true,
            style: TextStyles.regular14(),
          ),
        ),
        SizedBox(width: 8.w),
        Flexible(
          flex: 5,
          child: Text(
            value,
            textAlign: TextAlign.end,
            softWrap: true,
            style: TextStyles.bold14(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 18.r.clamp(16.0, 20.0),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            softWrap: true,
            style: TextStyles.regular14(),
          ),
        ),
      ],
    );
  }
}
