import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/svg_manager.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_motion.dart';
import '../../../../core/widgets/app_svg.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../data/repositories/workspace_repository_impl.dart';
import '../../domain/entities/workspace_entities.dart';
import '../cubit/get_notifications_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetNotificationsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Row(
                children: [
                  const AppBackButton(),
                  Expanded(
                    child: Text(
                      context.tr('notifications'),
                      textAlign: TextAlign.center,
                      style: TextStyles.bold18(color: AppColors.text),
                    ),
                  ),
                  SizedBox(width: 36.w),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<GetNotificationsCubit, GetNotificationsState>(
                builder: (context, state) {
                  if (state is GetNotificationsLoading ||
                      state is GetNotificationsInitial) {
                    return const LoadingView();
                  }
                  if (state is GetNotificationsError) {
                    return ErrorView(
                      message: state.message,
                      onRetry: () =>
                          context.read<GetNotificationsCubit>().load(),
                    );
                  }
                  final items = state is GetNotificationsLoaded
                      ? state.items
                      : <NotificationEntity>[];
                  if (items.isEmpty) {
                    return Center(
                      child: SoftZoom(
                        child: Padding(
                          padding: EdgeInsets.all(32.r),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                ImgAssets.emptyNotifications,
                                width: 170.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(height: 14.h),
                              Text(
                                context.tr('notifications'),
                                style: TextStyles.bold16(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    children: [
                      Row(
                        children: [
                          Text(
                            context.tr('today'),
                            style: TextStyles.bold14(color: AppColors.text),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              WorkspaceRepositoryImpl.clearNotifications();
                              context.read<GetNotificationsCubit>().load();
                            },
                            child: Text(
                              context.tr('delete_all'),
                              style: TextStyles.medium12(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...List.generate(items.length, (index) {
                        final item = items[index];
                        return SoftRise(
                          delay: Duration(milliseconds: 40 + (index * 45)),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12.h),
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
                                Row(
                                  children: [
                                    Container(
                                      width: 32.r,
                                      height: 32.r,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.primarySoft,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: AppSvg(
                                        SvgAssets.notification,
                                        size: 16.r,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        item.title.tr(context),
                                        style: TextStyles.bold14(
                                          color: AppColors.text,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        WorkspaceRepositoryImpl
                                            .removeNotification(item.id);
                                        context
                                            .read<GetNotificationsCubit>()
                                            .load();
                                      },
                                      child: Icon(
                                        Icons.delete_outline_rounded,
                                        size: 18.r,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  item.body.tr(context),
                                  textAlign: TextAlign.start,
                                  style: TextStyles.regular12(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    AppSvg(
                                      SvgAssets.clock,
                                      size: 12.r,
                                      color: AppColors.hint,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      item.timeLabel.tr(context),
                                      style: TextStyles.regular12(
                                        color: AppColors.hint,
                                      ).copyWith(fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
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
