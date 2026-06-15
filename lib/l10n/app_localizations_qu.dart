// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Quechua (`qu`).
class AppLocalizationsQu extends AppLocalizations {
  AppLocalizationsQu([String locale = 'qu']) : super(locale);

  @override
  String get appTitle => 'Shimi Inga';

  @override
  String get platformSubtitle => 'Plataforma Educativa Cultural';

  @override
  String get description =>
      'Plataforma pa\' documentar y difundir la lengua Inga';

  @override
  String get loginTitle => 'Ragshi Uruy';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Shina';

  @override
  String get loginButton => 'Uruy';

  @override
  String get registerButton => 'Rrangki Shina Estudiante';

  @override
  String get enterEmail => 'Shina email';

  @override
  String get invalidEmail => 'Email mashi';

  @override
  String get enterPassword => 'Shina shina';

  @override
  String get passwordMinLength => 'Mínimo 6 caracteres';

  @override
  String welcomeMessage(Object nombre) {
    return 'Bunji $nombre!';
  }

  @override
  String get loginError => 'Uruy koshka';

  @override
  String get connectionError => 'Rrekro mashi';

  @override
  String get testUsersTitle => 'Usuarios test:';

  @override
  String get adminUser => 'Admin: admin@inga.com / admin123';

  @override
  String get teacherUser => 'Profesor: profesor@inga.com / profesor123';

  @override
  String get registerScreenTitle => 'Rrangki Estudiante';

  @override
  String get createAccountTitle => 'Rrangki Shina';

  @override
  String get createAccountSubtitle => 'Shina estudiante';

  @override
  String get nameLabel => 'Shina Bunji';

  @override
  String get enterName => 'Shina shina bunji';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get enterRegisterEmail => 'Shina email';

  @override
  String get invalidRegisterEmail => 'Email mashi';

  @override
  String get registerPasswordLabel => 'Shina';

  @override
  String get confirmPasswordLabel => 'Rranga Shina';

  @override
  String get enterRegisterPassword => 'Shina shina';

  @override
  String get confirmPasswordEmpty => 'Rranga shina';

  @override
  String get passwordMismatch => 'Shina mashi';

  @override
  String get registerSuccess => 'Rrangki sukka! Uruy tura';

  @override
  String get registerError => 'Rrangki koshka';

  @override
  String get alreadyHaveAccount => 'Shina shina?';

  @override
  String get loginLinkText => 'Uruy';

  @override
  String get words => 'Shina';

  @override
  String get lessons => 'Leshi';

  @override
  String get aiAssistant => 'Asistente IA';

  @override
  String get vocabulary => 'Shina List';

  @override
  String get games => 'Jueji';

  @override
  String get profile => 'Perfil';

  @override
  String get logoutConfirm => '¿Seguro que deseas cerrar sesión?';

  @override
  String get logout => 'Uruy';

  @override
  String get cancel => 'Kari';

  @override
  String get languageChanged => 'Idioma cambiado correctamente';

  @override
  String get about => 'Acerca';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Shimi';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get inga => 'Shimi Inga';

  @override
  String get palabrasScreenTitle => 'Shina';

  @override
  String get editWord => 'Rranga Shina';

  @override
  String get newWord => 'Shina Nyi';

  @override
  String get wordInInga => 'Shina Inga';

  @override
  String get translation => 'Shina Español';

  @override
  String get category => 'Kategori';

  @override
  String get updateWordButton => 'Actualizar';

  @override
  String get createWordButton => 'Crear';

  @override
  String get deleteWordButton => 'Eliminar';

  @override
  String get wordDeletedToast => 'Shina eliminado';

  @override
  String get wordUpdatedToast => 'Shina actualizado';

  @override
  String get wordCreatedToast => 'Shina creado';

  @override
  String get completeFieldsToast => 'Complete campos';

  @override
  String deleteWordConfirm(Object word) {
    return 'Eliminar \"$word\"?';
  }

  @override
  String get noWordsMessage => 'Shina mashi';

  @override
  String get vocabularioScreenTitle => 'Shina Inga';

  @override
  String get vocabularioScreenSearchHint => 'Rrangi shina...';

  @override
  String get vocabularioScreenAllCategories => 'Todas';

  @override
  String get vocabularioScreenNoResults => 'Shina mashi';

  @override
  String vocabularioScreenResultCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count shina$_temp0';
  }

  @override
  String get vocabularioScreenLoadingError => 'Koshka shina';

  @override
  String get vocabularioDetailTitle => 'Shina información';

  @override
  String get vocabularioDetailAudioAvailable => 'Audio disponible';

  @override
  String get vocabularioDetailAudioPlayingMsg => 'Audio en desarrollo';

  @override
  String get vocabularioDetailCloseButton => 'Chukki';

  @override
  String get leccionesScreenTitle => 'Leshi';

  @override
  String get leccionesScreenNoLessons => 'Leshi mashi';

  @override
  String get leccionesScreenLessonWords => 'Shina de leshi:';

  @override
  String get leccionesScreenCreateLesson => 'Leshi Nyi';

  @override
  String get leccionesScreenEditLesson => 'Rranga Leshi';

  @override
  String get leccionesScreenLessonTitle => 'Bunji';

  @override
  String get leccionesScreenLessonDescription => 'Descripción';

  @override
  String get leccionesScreenLessonWordsLabel => 'Shina de leshi:';

  @override
  String get leccionesScreenCancel => 'Kari';

  @override
  String get leccionesScreenCreateButton => 'Crear';

  @override
  String get leccionesScreenUpdateButton => 'Actualizar';

  @override
  String leccionesScreenDeleteConfirmation(Object title) {
    return 'Eliminar \"$title\"?';
  }

  @override
  String get leccionesScreenLessonCreated => 'Leshi creado';

  @override
  String get leccionesScreenLessonUpdated => 'Leshi actualizado';

  @override
  String get leccionesScreenLessonDeleted => 'Leshi eliminado';

  @override
  String get leccionesScreenEnterTitle => 'Shina bunji';

  @override
  String get leccionesScreenNoWordsInLesson => 'Shina mashi';

  @override
  String leccionesScreenWordsCount(Object count) {
    return '$count shina';
  }

  @override
  String get aiAssistantScreenTitle => 'Asistente IA - Shimi Inga';

  @override
  String get aiAssistantPlaceholder => 'Rrangi pregunta...';

  @override
  String get aiAssistantThinking => 'Shina mashi...';

  @override
  String get aiAssistantWelcome =>
      '👋 Bunji! Shimi nki shina Inga.\n\nNki rranga:\n• Rrangi shina (Español ↔ Inga)\n• Rrangi gramática y pronunciación\n• Shina ejemplo\n• Shina cultura Inga\n\n¿Kashi rrangi tura?';

  @override
  String get aiAssistantNotReady => '❌ IA mashi.\nEsperi o revisi API Key.';

  @override
  String get aiAssistantInitSuccess => '✅ IA rrangi';

  @override
  String aiAssistantInitError(Object error) {
    return '❌ IA mashi.\nRevisi conexión o API Key.\n\nDetalles: $error';
  }

  @override
  String get aiAssistantRequestError => '⚠️ Koshka procesando';

  @override
  String get aiAssistantQuickActionsTitle => 'Acciones Rápidas';

  @override
  String get aiAssistantQuickTranslateTitle => 'Rrangi Shina';

  @override
  String get aiAssistantQuickTranslateSubtitle => 'Español → Inga';

  @override
  String get aiAssistantQuickPronunciationTitle => 'Pronunciación';

  @override
  String get aiAssistantQuickPronunciationSubtitle =>
      'Aprender cómo se pronuncia';

  @override
  String get aiAssistantQuickExampleTitle => 'Ejemplo de Uso';

  @override
  String get aiAssistantQuickExampleSubtitle => 'Oraciones comunes';

  @override
  String get aiAssistantEmptyConversation => 'Inicia conversación';

  @override
  String get aiAssistantApiKeyMissing =>
      '⚠️ API Key mashi.\nConfigura en: https://aistudio.google.com/app/apikey';

  @override
  String get juegosScreenTitle => 'Juegos Interactivos';

  @override
  String get juegosScreenGameMemoriaTitle => 'Memoria';

  @override
  String get juegosScreenGameMemoriaDesc => 'Encuentra las parejas';

  @override
  String get juegosScreenGameQuizTitle => 'Quiz';

  @override
  String get juegosScreenGameQuizDesc => 'Prueba tus conocimientos';

  @override
  String get juegosScreenGameFlashcardsTitle => 'Flashcards';

  @override
  String get juegosScreenGameFlashcardsDesc => 'Repasa vocabulario';

  @override
  String get juegosScreenGameCompletarTitle => 'Completar';

  @override
  String get juegosScreenGameCompletarDesc => 'Completa la palabra';

  @override
  String get quizGameTitle => 'Quiz de Vocabulario';

  @override
  String quizGameScore(Object score) {
    return 'Puntuación: $score';
  }

  @override
  String get quizGameQuestion => '¿Cómo se traduce?';

  @override
  String get quizGameFinishedTitle => '¡Juego Terminado!';

  @override
  String get quizGameExcellent => '¡Excelente!';

  @override
  String get quizGameKeepPracticing => '¡Sigue practicando!';

  @override
  String get quizGameExit => 'Salir';

  @override
  String get quizGameRestart => 'Reiniciar';

  @override
  String get quizGameNeedWords => 'Se necesitan al menos 4 palabras';

  @override
  String get flashcardsGameTitle => 'Flashcards';

  @override
  String get flashcardsShowTranslationHint =>
      'Toca la tarjeta para ver la traducción';

  @override
  String get flashcardsNext => 'Siguiente';

  @override
  String get flashcardsPrevious => 'Anterior';

  @override
  String get memoriaGameTitle => 'Memoria';

  @override
  String get memoriaGameWinTitle => '¡Ganaste!';

  @override
  String get memoriaGameWinMsg => 'Has encontrado todas las parejas 🎉';

  @override
  String get memoriaGameExit => 'Salir';

  @override
  String get memoriaGameRestart => 'Reiniciar';

  @override
  String get memoriaGameLoadingError => 'Error al cargar juego';

  @override
  String get completarGameTitle => 'Completar la Palabra';

  @override
  String get completarGameInputHint => 'Escribe la traducción en español...';

  @override
  String get completarGameCheckButton => 'Comprobar';

  @override
  String get completarGameFinishedTitle => 'Juego Terminado';

  @override
  String completarGameScoreMsg(Object score, Object total) {
    return 'Puntuación: $score/$total';
  }

  @override
  String get completarGameExit => 'Salir';

  @override
  String get completarGameRestart => 'Reiniciar';

  @override
  String get completarGameCorrect => '¡Correcto!';

  @override
  String get completarGameIncorrect => 'Incorrecto';

  @override
  String get emailLabel => 'Email';

  @override
  String get userIdLabel => 'ID de Usuario';

  @override
  String get roleLabel => 'Rol';

  @override
  String get rolePermissions => 'Permisos de tu rol:';

  @override
  String get noRole => 'Sin rol';

  @override
  String get noPermissions => 'Sin permisos asignados';

  @override
  String get adminPermissions1 => 'Gestión completa de usuarios';

  @override
  String get adminPermissions2 =>
      'Crear, editar y eliminar cualquier contenido';

  @override
  String get adminPermissions3 => 'Acceso total al sistema';

  @override
  String get adminPermissions4 => 'Gestión de roles';

  @override
  String get teacherPermissions1 => 'Crear palabras y lecciones';

  @override
  String get teacherPermissions2 => 'Editar tu propio contenido';

  @override
  String get teacherPermissions3 => 'Eliminar tu propio contenido';

  @override
  String get teacherPermissions4 => 'Ver todo el contenido publicado';

  @override
  String get studentPermissions1 => 'Ver palabras publicadas';

  @override
  String get studentPermissions2 => 'Ver lecciones publicadas';

  @override
  String get studentPermissions3 => 'Acceso de solo lectura';

  @override
  String get appInfoTitle => 'Plataforma Educativa';

  @override
  String get appInfoSubtitle => 'Documentación y difusión de la lengua Inga';

  @override
  String get appVersion => 'Versión 1.0.0';

  @override
  String get settingsLanguageSection => 'Idioma';

  @override
  String get settingsThemeSection => 'Tema';

  @override
  String get settingsPreviewSection => 'Vista Previa';

  @override
  String get settingsLanguageDefault => 'Idioma predeterminado';

  @override
  String get settingsLanguageEnglish => 'Default language';

  @override
  String get settingsLanguageInga => 'Lengua nativa';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeLightDesc => 'Tema con fondo blanco';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsThemeDarkDesc => 'Tema con fondo negro';

  @override
  String get settingsThemeBackground => 'Imagen de Fondo';

  @override
  String get settingsThemeBackgroundDesc => 'Tema con imagen cultural';

  @override
  String get settingsChangesApplied => 'Los cambios se aplican inmediatamente';

  @override
  String toastLanguageChanged(Object name) {
    return 'Idioma cambiado a $name';
  }

  @override
  String toastThemeChanged(Object name) {
    return 'Tema cambiado a $name';
  }

  @override
  String get exampleCardTitle => 'Ejemplo de Tarjeta';

  @override
  String get exampleCardSubtitle => 'Así se ve el tema seleccionado';

  @override
  String get exampleCardInfo => 'Esta es una vista previa del tema actual';

  @override
  String get exit => 'Salir';

  @override
  String get play_again => 'Jugar de nuevo';

  @override
  String get game_completed_title => '¡Juego Completado! 🎉';

  @override
  String get score_label => 'Puntuación';

  @override
  String get correct_label => 'Aciertos';

  @override
  String get wrong_label => 'Errores';

  @override
  String get time_label => 'Tiempo';
}
