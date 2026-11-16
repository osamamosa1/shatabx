import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/dio_consumer.dart';
import '../../../../core/services/local_storage/app_shared_preferences.dart';
import '../../../../injection_container.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this.preferences)
    : super(LocaleState(Locale(preferences.languageCode)));

  final AppSharedPreferences preferences;

  Future<void> setLocale(String code) async {
    await preferences.saveLanguageCode(code);
    if (ServiceLocator.instance.isRegistered<DioConsumer>()) {
      ServiceLocator.instance<DioConsumer>().updateLanguageHeader(code);
    }
    emit(LocaleState(Locale(code)));
  }
}

class LocaleState extends Equatable {
  const LocaleState(this.locale);

  final Locale locale;

  @override
  List<Object?> get props => [locale];
}
