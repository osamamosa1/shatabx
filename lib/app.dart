import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';
import 'core/utils/values/app_colors.dart';
import 'features/auth/presentation/cubit/session_cubit.dart';
import 'features/language/presentation/cubit/locale_cubit.dart';
import 'features/shell/presentation/cubit/bottom_nav_cubit.dart';
import 'injection_container.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: ServiceLocator.instance<LocaleCubit>()),
        BlocProvider.value(value: ServiceLocator.instance<SessionCubit>()),
        BlocProvider.value(value: ServiceLocator.instance<BottomNavCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                title: 'ShatabX',
                debugShowCheckedModeBanner: false,
                locale: state.locale,
                theme: getAppTheme(state.locale),
                routerConfig: AppRouter.router,
                supportedLocales: const [Locale('ar'), Locale('en')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                builder: (context, child) => _ResponsiveFrame(
                  locale: state.locale,
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ResponsiveFrame extends StatelessWidget {
  const _ResponsiveFrame({required this.locale, required this.child});

  final Locale locale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final wide = media.size.width >= 700;
    final frameWidth = wide ? 390.0 : media.size.width;
    final frameHeight = media.size.height;

    ScreenUtil.configure(
      data: media.copyWith(size: Size(frameWidth, frameHeight)),
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    final framed = Directionality(
      textDirection: locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: child,
    );

    if (!wide) return framed;

    return ColoredBox(
      color: AppColors.canvas,
      child: Center(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x1A101828),
                blurRadius: 32,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: SizedBox(width: frameWidth, height: frameHeight, child: framed),
        ),
      ),
    );
  }
}
