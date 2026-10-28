import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app.dart';
import 'config/locale/app_localizations.dart';
import 'core/services/bloc_observer/bloc_observer.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.init();
  await AppLocalizations.ensureLoaded();
  await GoogleFonts.pendingFonts([
    GoogleFonts.cairo(),
    GoogleFonts.dmSans(),
    GoogleFonts.poppins(),
    GoogleFonts.montserrat(),
  ]);
  Bloc.observer = AppBlocObserver();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const App());
}
