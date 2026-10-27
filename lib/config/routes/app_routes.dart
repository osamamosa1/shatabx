import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/cubit/complete_profile_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_company_cubit.dart';
import '../../features/auth/presentation/cubit/resend_otp_cubit.dart';
import '../../features/auth/presentation/cubit/reset_password_cubit.dart';
import '../../features/auth/presentation/cubit/select_account_type_cubit.dart';
import '../../features/auth/presentation/cubit/select_join_method_cubit.dart';
import '../../features/auth/presentation/cubit/verify_otp_cubit.dart';
import '../../features/auth/presentation/models/auth_flow_args.dart';
import '../../features/auth/presentation/screens/account_type_screen.dart';
import '../../features/auth/presentation/screens/complete_profile_screen.dart';
import '../../features/auth/presentation/screens/join_method_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_company_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/terms_screen.dart';
import '../../features/auth/presentation/screens/verify_otp_screen.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/onboarding/presentation/cubit/splash_cubit.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/onboarding/presentation/screens/splash_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/projects/presentation/cubit/get_project_details_cubit.dart';
import '../../features/projects/presentation/cubit/get_projects_cubit.dart';
import '../../features/projects/presentation/screens/home_screen.dart';
import '../../features/projects/presentation/screens/project_details_screen.dart';
import '../../features/projects/presentation/screens/projects_screen.dart';
import '../../features/shell/presentation/screens/main_shell.dart';
import '../../features/workspace/presentation/cubit/get_inspection_template_details_cubit.dart';
import '../../features/workspace/presentation/cubit/get_inspection_templates_cubit.dart';
import '../../features/workspace/presentation/cubit/get_notifications_cubit.dart';
import '../../features/workspace/presentation/cubit/get_report_details_cubit.dart';
import '../../features/workspace/presentation/cubit/get_reports_cubit.dart';
import '../../features/workspace/presentation/screens/inspection_template_details_screen.dart';
import '../../features/workspace/presentation/screens/inspection_templates_screen.dart';
import '../../features/workspace/presentation/screens/notifications_screen.dart';
import '../../features/workspace/presentation/screens/report_details_screen.dart';
import '../../features/workspace/presentation/screens/reports_screen.dart';
import '../../injection_container.dart';
import 'app_page.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const accountType = '/account-type';
  static const joinMethod = '/join-method';
  static const register = '/register';
  static const login = '/login';
  static const otp = '/otp';
  static const resetPassword = '/reset-password';
  static const completeProfile = '/complete-profile';
  static const terms = '/terms';
  static const home = '/home';
  static const projects = '/projects';
  static const reports = '/reports';
  static const profile = '/profile';
  static const notifications = '/notifications';
  static const templates = '/templates';
}

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<SplashCubit>(),
            child: const SplashScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<OnboardingCubit>(),
            child: const OnboardingScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.accountType,
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<SelectAccountTypeCubit>(),
            child: const AccountTypeScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.joinMethod,
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<SelectJoinMethodCubit>(),
            child: const JoinMethodScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<RegisterCompanyCubit>(),
            child: const RegisterCompanyScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) {
          final roleName = state.uri.queryParameters['role'];
          final role = roleName == AccountRole.engineer.name
              ? AccountRole.engineer
              : AccountRole.company;
          return fadePage(
            state,
            BlocProvider(
              create: (_) => ServiceLocator.instance<LoginCubit>(),
              child: LoginScreen(role: role),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.otp,
        pageBuilder: (context, state) {
          final extra = state.extra;
          final args = extra is OtpArgs
              ? extra
              : OtpArgs(
                  email: state.uri.queryParameters['email'] ?? '',
                  purpose: OtpPurpose.resetPassword,
                );
          return fadePage(
            state,
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => ServiceLocator.instance<VerifyOtpCubit>()),
                BlocProvider(create: (_) => ServiceLocator.instance<ResendOtpCubit>()),
              ],
              child: VerifyOtpScreen(args: args),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<ResetPasswordCubit>(),
            child: ResetPasswordScreen(email: state.extra as String? ?? ''),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.completeProfile,
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<CompleteProfileCubit>(),
            child: const CompleteProfileScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.terms,
        pageBuilder: (context, state) => fadePage(state, const TermsScreen()),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<GetNotificationsCubit>(),
            child: const NotificationsScreen(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.templates,
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<GetInspectionTemplatesCubit>(),
            child: const InspectionTemplatesScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.templates}/:id',
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<GetInspectionTemplateDetailsCubit>(),
            child: InspectionTemplateDetailsScreen(id: state.pathParameters['id']!),
          ),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.projects}/:id',
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<GetProjectDetailsCubit>(),
            child: ProjectDetailsScreen(id: state.pathParameters['id']!),
          ),
        ),
      ),
      GoRoute(
        path: '${AppRoutes.reports}/:id',
        pageBuilder: (context, state) => fadePage(
          state,
          BlocProvider(
            create: (_) => ServiceLocator.instance<GetReportDetailsCubit>(),
            child: ReportDetailsScreen(id: state.pathParameters['id']!),
          ),
        ),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) {
          return fadePage(
            state,
            BlocProvider(
              create: (_) => ServiceLocator.instance<GetProjectsCubit>(),
              child: MainShell(navigationShell: navigationShell),
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.projects,
                builder: (context, state) => const ProjectsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.reports,
                builder: (context, state) => BlocProvider(
                  create: (_) => ServiceLocator.instance<GetReportsCubit>(),
                  child: const ReportsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
