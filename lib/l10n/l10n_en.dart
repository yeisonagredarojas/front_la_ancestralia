// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Inga Language';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get logout => 'Logout';

  @override
  String get words => 'Words';

  @override
  String get lessons => 'Lessons';

  @override
  String get profile => 'Profile';

  @override
  String get createWord => 'New Word';

  @override
  String get createLesson => 'New Lesson';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get wordInInga => 'Word in Inga';

  @override
  String get spanishTranslation => 'Spanish Translation';

  @override
  String get category => 'Category';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String welcome(String name) {
    return 'Welcome $name!';
  }

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get askAI => 'Ask the assistant';

  @override
  String get generateTranslation => 'Generate translation with AI';
}
