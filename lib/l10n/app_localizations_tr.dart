// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Pomodoro';

  @override
  String get start => 'Başlat';

  @override
  String get pause => 'Duraklat';

  @override
  String get reset => 'Sıfırla';

  @override
  String get settings => 'Ayarlar';

  @override
  String get focusTime => 'Odaklanma Zamanı!';

  @override
  String get pomodoroDuration => 'Pomodoro Süresi (dakika):';

  @override
  String get breakDuration => 'Mola Süresi (dakika):';

  @override
  String minutes(Object value) {
    return '$value dakika';
  }

  @override
  String get fullFocusMode => 'Tam Odaklanma Modu';
}
