import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_snack_bar.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/my_default_button.dart';
import '../../../../injection_container.dart';
import '../../../content/data/datasources/content_remote_data_source.dart';
import '../widgets/subscriptions_header.dart';

class SelectPackageScreen extends StatefulWidget {
  const SelectPackageScreen({super.key});

  @override
  State<SelectPackageScreen> createState() => _SelectPackageScreenState();
}

class _SelectPackageScreenState extends State<SelectPackageScreen> {
  late final Future<List<Map<String, dynamic>>> _future =
      ServiceLocator.instance<ContentRemoteDataSource>().getPackages();
  String? _selectedId;
  bool _seededSelection = false;

  List<Map<String, dynamic>> _companyPackages(List<Map<String, dynamic>> all) {
    return all.where((p) {
      final type = p['type']?.toString().toLowerCase() ?? '';
      return type.isEmpty || type == 'company';
    }).toList();
  }

  bool _isPopular(Map<String, dynamic> item, int index, int total) {
    final payment = item['payment_type']?.toString().toLowerCase() ?? '';
    final price = num.tryParse(item['price']?.toString() ?? '') ?? -1;
    final name = item['name']?.toString().toLowerCase() ?? '';
    if (payment == 'free' || price == 0) return true;
    if (name.contains('أساس') || name.contains('basic')) return true;
    if (total >= 2 && index == 1) return true;
    return false;
  }

  void _seedSelection(List<Map<String, dynamic>> items) {
    if (_seededSelection || items.isEmpty) return;
    _seededSelection = true;
    String? id;
    for (var i = 0; i < items.length; i++) {
      if (_isPopular(items[i], i, items.length)) {
        id = items[i]['id']?.toString();
        break;
      }
    }
    id ??= items.first['id']?.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selectedId != null) return;
      setState(() => _selectedId = id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final buttonHeight = 50.h.clamp(46.0, 56.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Column(
              children: [
                SubscriptionsHeader(),
                Expanded(child: LoadingView()),
              ],
            );
          }
          final items = _companyPackages(
            snapshot.data ?? const <Map<String, dynamic>>[],
          );
          _seedSelection(items);

          return Column(
            children: [
              const SubscriptionsHeader(),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Text(
                            context.isArabic
                                ? 'لا توجد باقات متاحة'
                                : 'No packages available',
                            textAlign: TextAlign.center,
                            style: TextStyles.regular14(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
                        itemCount: items.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return SoftDrop(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      context.tr('choose_package'),
                                      textAlign: TextAlign.start,
                                      style: TextStyles.bold22(
                                        color: AppColors.text,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      context.tr('choose_package_sub'),
                                      textAlign: TextAlign.start,
                                      style: TextStyles.regular14(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          final item = items[index - 1];
                          final id =
                              item['id']?.toString() ?? '${index - 1}';
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: SoftRise(
                              delay: Duration(milliseconds: 40 * (index - 1)),
                              child: _PackageCard(
                                item: item,
                                selected: _selectedId == id,
                                popular: _isPopular(
                                  item,
                                  index - 1,
                                  items.length,
                                ),
                                onTap: () =>
                                    setState(() => _selectedId = id),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Material(
                color: const Color(0xFFF5F7F9),
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16.w,
                    8.h,
                    16.w,
                    12.h + bottomInset,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyDefaultButton(
                        text: context.tr('select_package'),
                        height: buttonHeight,
                        borderRadius: 14.r,
                        color: AppColors.primaryDark,
                        onPressed: () {
                          if (_selectedId == null) {
                            AppSnackBar.show(
                              context,
                              context.tr('choose_package_required'),
                              error: true,
                            );
                            return;
                          }
                          final selected = items.firstWhere(
                            (e) => e['id']?.toString() == _selectedId,
                            orElse: () => items.first,
                          );
                          context.push(
                            AppRoutes.packageDetails,
                            extra: selected,
                          );
                        },
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        context.tr('package_change_later'),
                        textAlign: TextAlign.center,
                        softWrap: true,
                        style: TextStyles.regular12(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.item,
    required this.selected,
    required this.popular,
    required this.onTap,
  });

  final Map<String, dynamic> item;
  final bool selected;
  final bool popular;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = item['name']?.toString() ?? '-';
    final price = item['price']?.toString() ?? '0';
    final projects = item['num_projects']?.toString() ?? '0';
    final engineers = item['num_engineers']?.toString() ?? '0';
    final description = item['description']?.toString().trim();
    final fallbackDesc = context.isArabic
        ? 'الأنسب لشركات المقاولات والتشطيبات'
        : 'Best for finishing & contracting companies';
    final iconSize = 40.r.clamp(34.0, 44.0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          padding: EdgeInsets.all(14.r.clamp(12.0, 16.0)),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEEF6FA) : AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.6 : 1,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x1400608B),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ]
                : AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (popular) ...[
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
                      style: TextStyles.bold10(color: AppColors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22.r.clamp(20.0, 24.0),
                    height: 22.r.clamp(20.0, 24.0),
                    margin: EdgeInsets.only(top: 2.h),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? AppColors.primary : AppColors.white,
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: selected
                        ? Icon(
                            Icons.check_rounded,
                            size: 14.r.clamp(12.0, 16.0),
                            color: AppColors.white,
                          )
                        : null,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          softWrap: true,
                          style: TextStyles.bold16(),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          (description == null || description.isEmpty)
                              ? fallbackDesc
                              : description,
                          softWrap: true,
                          style: TextStyles.regular12(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 8.h),
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
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            context.isArabic
                                ? '$price / شهرياً'
                                : '$price / month',
                            maxLines: 1,
                            style: TextStyles.bold18(color: AppColors.primary),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          context.isArabic
                              ? '$projects مشروع • $engineers مهندس'
                              : '$projects projects • $engineers engineers',
                          softWrap: true,
                          style: TextStyles.medium12(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    width: iconSize,
                    height: iconSize,
                    padding: EdgeInsets.all(8.r.clamp(6.0, 10.0)),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
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
    );
  }
}
