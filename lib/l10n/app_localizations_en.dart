// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pause';

  @override
  String get reset => 'Reset';

  @override
  String get settings => 'Settings';

  @override
  String get focusTime => 'Focus Time!';

  @override
  String get pomodoroDuration => 'Pomodoro Duration (minutes):';

  @override
  String get breakDuration => 'Break Duration (minutes):';

  @override
  String minutes(Object value) {
    return '$value minutes';
  }

  @override
  String get fullFocusMode => 'Full Focus Mode';
}
