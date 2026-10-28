import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/assets.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
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
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: const AppBackButton(),
            ),
            Text(context.tr('notifications'), style: TextStyles.bold22()),
            SizedBox(height: 8.h),
            Expanded(
              child: BlocBuilder<GetNotificationsCubit, GetNotificationsState>(
                builder: (context, state) {
                  if (state is GetNotificationsLoading || state is GetNotificationsInitial) {
                    return const LoadingView();
                  }
                  if (state is GetNotificationsError) {
                    return ErrorView(
                      message: state.message,
                      onRetry: () => context.read<GetNotificationsCubit>().load(),
                    );
                  }
                  final items = state is GetNotificationsLoaded
                      ? state.items
                      : <NotificationEntity>[];
                  if (items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.r),
                        child: Image.asset(
                          ImgAssets.emptyNotifications,
                          width: 160.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.all(16.r),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Container(
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: item.read ? AppColors.white : AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title.tr(context), style: TextStyles.bold18()),
                            SizedBox(height: 4.h),
                            Text(
                              item.body.tr(context),
                              textAlign: TextAlign.start,
                              style: TextStyles.regular14(color: AppColors.textSecondary),
                            ),
                            SizedBox(height: 6.h),
                            Text(item.timeLabel.tr(context), style: TextStyles.regular12(color: AppColors.hint)),
                          ],
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
    );
  }
}
