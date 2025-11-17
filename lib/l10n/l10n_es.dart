// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Lengua Inga';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get email => 'Email';

  @override
  String get password => 'Contraseña';

  @override
  String get loginButton => 'Ingresar';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get words => 'Palabras';

  @override
  String get lessons => 'Lecciones';

  @override
  String get profile => 'Perfil';

  @override
  String get createWord => 'Nueva Palabra';

  @override
  String get createLesson => 'Nueva Lección';

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
    return '¡Bienvenido $name!';
  }

  @override
  String get aiAssistant => 'Asistente IA';

  @override
  String get askAI => 'Pregunta al asistente';

  @override
  String get generateTranslation => 'Generar traducción con IA';
}
