import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/dio_consumer.dart';
import 'core/services/local_storage/app_shared_preferences.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_use_cases.dart';
import 'features/auth/presentation/cubit/complete_profile_cubit.dart';
import 'features/auth/presentation/cubit/login_cubit.dart';
import 'features/auth/presentation/cubit/register_company_cubit.dart';
import 'features/auth/presentation/cubit/resend_otp_cubit.dart';
import 'features/auth/presentation/cubit/reset_password_cubit.dart';
import 'features/auth/presentation/cubit/select_account_type_cubit.dart';
import 'features/auth/presentation/cubit/select_join_method_cubit.dart';
import 'features/auth/presentation/cubit/session_cubit.dart';
import 'features/auth/presentation/cubit/verify_otp_cubit.dart';
import 'features/language/presentation/cubit/locale_cubit.dart';
import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'features/onboarding/presentation/cubit/splash_cubit.dart';
import 'features/projects/data/repositories/projects_repository_impl.dart';
import 'features/projects/domain/repositories/projects_repository.dart';
import 'features/projects/domain/usecases/project_use_cases.dart';
import 'features/projects/presentation/cubit/get_project_details_cubit.dart';
import 'features/projects/presentation/cubit/get_projects_cubit.dart';
import 'features/shell/presentation/cubit/bottom_nav_cubit.dart';
import 'features/workspace/data/repositories/workspace_repository_impl.dart';
import 'features/workspace/domain/repositories/workspace_repository.dart';
import 'features/workspace/domain/usecases/workspace_use_cases.dart';
import 'features/workspace/presentation/cubit/get_inspection_template_details_cubit.dart';
import 'features/workspace/presentation/cubit/get_inspection_templates_cubit.dart';
import 'features/workspace/presentation/cubit/get_notifications_cubit.dart';
import 'features/workspace/presentation/cubit/get_report_details_cubit.dart';
import 'features/workspace/presentation/cubit/get_reports_cubit.dart';

abstract class ServiceLocator {
  static final GetIt instance = GetIt.instance;

  static Future<void> init() async {
    final preferences = await SharedPreferences.getInstance();
    instance.registerLazySingleton<AppSharedPreferences>(
      () => AppSharedPreferencesImpl(preferences),
    );
    instance.registerLazySingleton<DioConsumer>(
      () => DioConsumerImpl(client: Dio()),
    );

    instance.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(instance<AppSharedPreferences>()),
    );
    instance.registerLazySingleton(() => RegisterCompanyUseCase(instance()));
    instance.registerLazySingleton(() => LoginUseCase(instance()));
    instance.registerLazySingleton(() => VerifyOtpUseCase(instance()));
    instance.registerLazySingleton(() => ResendOtpUseCase(instance()));
    instance.registerLazySingleton(() => ResetPasswordUseCase(instance()));
    instance.registerLazySingleton(() => CompleteProfileUseCase(instance()));

    instance.registerLazySingleton<ProjectsRepository>(ProjectsRepositoryImpl.new);
    instance.registerLazySingleton(() => GetProjectsUseCase(instance()));
    instance.registerLazySingleton(() => GetProjectDetailsUseCase(instance()));

    instance.registerLazySingleton<WorkspaceRepository>(WorkspaceRepositoryImpl.new);
    instance.registerLazySingleton(() => GetNotificationsUseCase(instance()));
    instance.registerLazySingleton(() => GetReportsUseCase(instance()));
    instance.registerLazySingleton(() => GetReportDetailsUseCase(instance()));
    instance.registerLazySingleton(() => GetInspectionTemplatesUseCase(instance()));
    instance.registerLazySingleton(() => GetInspectionTemplateDetailsUseCase(instance()));

    instance.registerLazySingleton(() => SessionCubit(instance()));
    instance.registerLazySingleton(() => LocaleCubit(instance()));
    instance.registerLazySingleton(BottomNavCubit.new);

    instance.registerFactory(() => SplashCubit(instance()));
    instance.registerFactory(() => OnboardingCubit(instance()));
    instance.registerFactory(SelectAccountTypeCubit.new);
    instance.registerFactory(SelectJoinMethodCubit.new);
    instance.registerFactory(() => RegisterCompanyCubit(instance()));
    instance.registerFactory(() => LoginCubit(instance()));
    instance.registerFactory(() => VerifyOtpCubit(instance()));
    instance.registerFactory(() => ResendOtpCubit(instance()));
    instance.registerFactory(() => ResetPasswordCubit(instance()));
    instance.registerFactory(() => CompleteProfileCubit(instance()));
    instance.registerFactory(() => GetProjectsCubit(instance()));
    instance.registerFactory(() => GetProjectDetailsCubit(instance()));
    instance.registerFactory(() => GetNotificationsCubit(instance()));
    instance.registerFactory(() => GetReportsCubit(instance()));
    instance.registerFactory(() => GetReportDetailsCubit(instance()));
    instance.registerFactory(() => GetInspectionTemplatesCubit(instance()));
    instance.registerFactory(() => GetInspectionTemplateDetailsCubit(instance()));
  }
}

AppSharedPreferences get sharedPreferences =>
    ServiceLocator.instance<AppSharedPreferences>();
