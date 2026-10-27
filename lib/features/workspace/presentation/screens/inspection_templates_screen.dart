import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/values/app_colors.dart';
import '../../../../core/utils/values/text_styles.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/entities/workspace_entities.dart';
import '../cubit/get_inspection_templates_cubit.dart';

class InspectionTemplatesScreen extends StatefulWidget {
  const InspectionTemplatesScreen({super.key});

  @override
  State<InspectionTemplatesScreen> createState() => _InspectionTemplatesScreenState();
}

class _InspectionTemplatesScreenState extends State<InspectionTemplatesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetInspectionTemplatesCubit>().load();
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
            Text(context.tr('templates'), style: TextStyles.bold22()),
            Expanded(
              child: BlocBuilder<GetInspectionTemplatesCubit, GetInspectionTemplatesState>(
                builder: (context, state) {
                  if (state is GetInspectionTemplatesLoading ||
                      state is GetInspectionTemplatesInitial) {
                    return const LoadingView();
                  }
                  if (state is GetInspectionTemplatesError) {
                    return ErrorView(
                      message: state.message,
                      onRetry: () => context.read<GetInspectionTemplatesCubit>().load(),
                    );
                  }
                  final items = state is GetInspectionTemplatesLoaded
                      ? state.items
                      : <InspectionTemplateEntity>[];
                  return ListView.separated(
                    padding: EdgeInsets.all(16.r),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        onTap: () => context.push('/templates/${item.id}'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        title: Text(item.name.tr(context), textAlign: TextAlign.start, style: TextStyles.bold18()),
                        subtitle: Text(
                          '${item.category.tr(context)} • ${item.itemsCount} ${context.tr('items_word')}',
                          textAlign: TextAlign.start,
                          style: TextStyles.regular12(color: AppColors.textSecondary),
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
