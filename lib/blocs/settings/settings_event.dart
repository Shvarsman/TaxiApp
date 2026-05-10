import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ChangeTheme extends SettingsEvent {
  final bool isDark;
  const ChangeTheme(this.isDark);
  @override
  List<Object?> get props => [isDark];
}

class ChangeLanguage extends SettingsEvent {
  final String languageCode;
  const ChangeLanguage(this.languageCode);
  @override
  List<Object?> get props => [languageCode];
}

class ClearCache extends SettingsEvent {}