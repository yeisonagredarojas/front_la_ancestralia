// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Cusco Quechua (`quz`).
class AppLocalizationsQuz extends AppLocalizations {
  AppLocalizationsQuz([String locale = 'quz']) : super(locale);

  @override
  String get appTitle => 'Inga Shimi';

  @override
  String get login => 'Yaicuna';

  @override
  String get email => 'Correo';

  @override
  String get password => 'Yaicui kliabi';

  @override
  String get loginButton => 'Yaicuna';

  @override
  String get logout => 'Llujshina';

  @override
  String get words => 'Shimikuna';

  @override
  String get lessons => 'Iachichikuna';

  @override
  String get profile => 'Nukapa';

  @override
  String get createWord => 'Musu Shimi';

  @override
  String get createLesson => 'Musu Iachichi';

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get wordInInga => 'Palabra en Inga';

  @override
  String get spanishTranslation => 'Traducción al Español';

  @override
  String get category => 'Categoría';

  @override
  String get title => 'Título';

  @override
  String get description => 'Descripción';

  @override
  String welcome(String name) {
    return '¡Allikauimi $name!';
  }

  @override
  String get aiAssistant => 'Asistente IA';

  @override
  String get askAI => 'Pregunta al asistente';

  @override
  String get generateTranslation => 'Generar traducción con IA';
}
