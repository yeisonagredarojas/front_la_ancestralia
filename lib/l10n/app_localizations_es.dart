// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Lengua Inga';

  @override
  String get platformSubtitle => 'Plataforma Educativa Cultural';

  @override
  String get description =>
      'Plataforma educativa para la documentación y difusión de la lengua Inga';

  @override
  String get loginTitle => 'Iniciar Sesión';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginButton => 'Ingresar';

  @override
  String get registerButton => 'Crear cuenta de estudiante';

  @override
  String get enterEmail => 'Ingrese su email';

  @override
  String get invalidEmail => 'Email inválido';

  @override
  String get enterPassword => 'Ingrese su contraseña';

  @override
  String get passwordMinLength => 'Mínimo 6 caracteres';

  @override
  String welcomeMessage(Object nombre) {
    return '¡Bienvenido $nombre!';
  }

  @override
  String get loginError => 'Error al iniciar sesión';

  @override
  String get connectionError => 'Error de conexión';

  @override
  String get testUsersTitle => 'Usuarios de prueba:';

  @override
  String get adminUser => 'Admin: admin@inga.com / admin123';

  @override
  String get teacherUser => 'Profesor: profesor@inga.com / profesor123';

  @override
  String get registerScreenTitle => 'Registro de Estudiante';

  @override
  String get createAccountTitle => 'Crear Cuenta';

  @override
  String get createAccountSubtitle => 'Regístrate como estudiante';

  @override
  String get nameLabel => 'Nombre Completo';

  @override
  String get enterName => 'Ingrese su nombre';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get enterRegisterEmail => 'Ingrese su email';

  @override
  String get invalidRegisterEmail => 'Email inválido';

  @override
  String get registerPasswordLabel => 'Contraseña';

  @override
  String get confirmPasswordLabel => 'Confirmar Contraseña';

  @override
  String get enterRegisterPassword => 'Ingrese su contraseña';

  @override
  String get confirmPasswordEmpty => 'Confirme su contraseña';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String get registerSuccess =>
      '¡Registro exitoso! Ahora puedes iniciar sesión';

  @override
  String get registerError => 'Error al registrarse';

  @override
  String get alreadyHaveAccount => '¿Ya tienes cuenta?';

  @override
  String get loginLinkText => 'Inicia Sesión';

  @override
  String get words => 'Palabras';

  @override
  String get lessons => 'Lecciones';

  @override
  String get aiAssistant => 'Asistente IA';

  @override
  String get vocabulary => 'Vocabulario';

  @override
  String get games => 'Juegos';

  @override
  String get profile => 'Perfil';

  @override
  String get logoutConfirm => '¿Seguro que deseas cerrar sesión?';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get cancel => 'Cancelar';

  @override
  String get languageChanged => 'Idioma cambiado correctamente';

  @override
  String get about => 'Acerca de';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'Inglés';

  @override
  String get inga => 'Inga Shimi';

  @override
  String get palabrasScreenTitle => 'Palabras';

  @override
  String get editWord => 'Editar Palabra';

  @override
  String get newWord => 'Nueva Palabra';

  @override
  String get wordInInga => 'Palabra en Inga';

  @override
  String get translation => 'Traducción al Español';

  @override
  String get category => 'Categoría';

  @override
  String get updateWordButton => 'Actualizar';

  @override
  String get createWordButton => 'Crear';

  @override
  String get deleteWordButton => 'Eliminar';

  @override
  String get wordDeletedToast => 'Palabra eliminada';

  @override
  String get wordUpdatedToast => 'Palabra actualizada';

  @override
  String get wordCreatedToast => 'Palabra creada';

  @override
  String get completeFieldsToast => 'Complete los campos obligatorios';

  @override
  String deleteWordConfirm(Object word) {
    return '¿Eliminar \"$word\"?';
  }

  @override
  String get noWordsMessage => 'No hay palabras registradas';

  @override
  String get vocabularioScreenTitle => 'Vocabulario Inga';

  @override
  String get vocabularioScreenSearchHint => 'Buscar palabra...';

  @override
  String get vocabularioScreenAllCategories => 'Todas';

  @override
  String get vocabularioScreenNoResults => 'No se encontraron palabras';

  @override
  String vocabularioScreenResultCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count palabra$_temp0';
  }

  @override
  String get vocabularioScreenLoadingError => 'Error al cargar vocabulario';

  @override
  String get vocabularioDetailTitle => 'Información adicional';

  @override
  String get vocabularioDetailAudioAvailable => 'Audio disponible';

  @override
  String get vocabularioDetailAudioPlayingMsg =>
      'Función de audio en desarrollo';

  @override
  String get vocabularioDetailCloseButton => 'Cerrar';

  @override
  String get leccionesScreenTitle => 'Lecciones';

  @override
  String get leccionesScreenNoLessons => 'No hay lecciones registradas';

  @override
  String get leccionesScreenLessonWords => 'Palabras en esta lección:';

  @override
  String get leccionesScreenCreateLesson => 'Nueva Lección';

  @override
  String get leccionesScreenEditLesson => 'Editar Lección';

  @override
  String get leccionesScreenLessonTitle => 'Título';

  @override
  String get leccionesScreenLessonDescription => 'Descripción';

  @override
  String get leccionesScreenLessonWordsLabel => 'Palabras de la lección:';

  @override
  String get leccionesScreenCancel => 'Cancelar';

  @override
  String get leccionesScreenCreateButton => 'Crear';

  @override
  String get leccionesScreenUpdateButton => 'Actualizar';

  @override
  String leccionesScreenDeleteConfirmation(Object title) {
    return '¿Eliminar \"$title\"?';
  }

  @override
  String get leccionesScreenLessonCreated => 'Lección creada';

  @override
  String get leccionesScreenLessonUpdated => 'Lección actualizada';

  @override
  String get leccionesScreenLessonDeleted => 'Lección eliminada';

  @override
  String get leccionesScreenEnterTitle => 'Ingrese un título';

  @override
  String get leccionesScreenNoWordsInLesson =>
      'No hay palabras en esta lección';

  @override
  String leccionesScreenWordsCount(Object count) {
    return '$count palabras';
  }

  @override
  String get aiAssistantScreenTitle => 'Asistente IA - Lengua Inga';

  @override
  String get aiAssistantPlaceholder => 'Escribe tu pregunta...';

  @override
  String get aiAssistantThinking => 'Pensando...';

  @override
  String get aiAssistantWelcome =>
      '👋 ¡Hola! Soy tu asistente de la lengua Inga.\n\nPuedo ayudarte a:\n• Traducir palabras (Español ↔ Inga)\n• Explicar gramática y pronunciación\n• Dar ejemplos de uso\n• Compartir aspectos culturales del pueblo Inga\n\n¿Qué deseas aprender hoy?';

  @override
  String get aiAssistantNotReady =>
      '❌ La IA no está lista todavía.\nEspera unos segundos o revisa tu API Key.';

  @override
  String get aiAssistantInitSuccess => '✅ IA inicializada correctamente.';

  @override
  String aiAssistantInitError(Object error) {
    return '❌ No se pudo inicializar la IA.\nVerifica tu conexión o API Key.\n\nDetalles: $error';
  }

  @override
  String get aiAssistantRequestError =>
      '⚠️ Ocurrió un error al procesar tu solicitud.';

  @override
  String get aiAssistantQuickActionsTitle => 'Acciones Rápidas';

  @override
  String get aiAssistantQuickTranslateTitle => 'Traducir palabra';

  @override
  String get aiAssistantQuickTranslateSubtitle => 'Español → Inga';

  @override
  String get aiAssistantQuickPronunciationTitle => 'Pronunciación';

  @override
  String get aiAssistantQuickPronunciationSubtitle =>
      'Aprender cómo se pronuncia';

  @override
  String get aiAssistantQuickExampleTitle => 'Ejemplo de uso';

  @override
  String get aiAssistantQuickExampleSubtitle => 'Oraciones comunes';

  @override
  String get aiAssistantEmptyConversation => 'Inicia una conversación';

  @override
  String get aiAssistantApiKeyMissing =>
      '⚠️ No se detectó una API Key.\nConfigúrala en Google AI Studio: https://aistudio.google.com/app/apikey';

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
