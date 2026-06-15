import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_qu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('qu')
  ];

  /// No description provided for @appTitle.
  ///
  /// In es, this message translates to:
  /// **'Lengua Inga'**
  String get appTitle;

  /// No description provided for @platformSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Plataforma Educativa Cultural'**
  String get platformSubtitle;

  /// No description provided for @description.
  ///
  /// In es, this message translates to:
  /// **'Plataforma educativa para la documentación y difusión de la lengua Inga'**
  String get description;

  /// No description provided for @loginTitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get loginTitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get loginPasswordLabel;

  /// No description provided for @loginButton.
  ///
  /// In es, this message translates to:
  /// **'Ingresar'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta de estudiante'**
  String get registerButton;

  /// No description provided for @enterEmail.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su email'**
  String get enterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In es, this message translates to:
  /// **'Email inválido'**
  String get invalidEmail;

  /// No description provided for @enterPassword.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su contraseña'**
  String get enterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get passwordMinLength;

  /// No description provided for @welcomeMessage.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido {nombre}!'**
  String welcomeMessage(Object nombre);

  /// No description provided for @loginError.
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión'**
  String get loginError;

  /// No description provided for @connectionError.
  ///
  /// In es, this message translates to:
  /// **'Error de conexión'**
  String get connectionError;

  /// No description provided for @testUsersTitle.
  ///
  /// In es, this message translates to:
  /// **'Usuarios de prueba:'**
  String get testUsersTitle;

  /// No description provided for @adminUser.
  ///
  /// In es, this message translates to:
  /// **'Admin: admin@inga.com / admin123'**
  String get adminUser;

  /// No description provided for @teacherUser.
  ///
  /// In es, this message translates to:
  /// **'Profesor: profesor@inga.com / profesor123'**
  String get teacherUser;

  /// No description provided for @registerScreenTitle.
  ///
  /// In es, this message translates to:
  /// **'Registro de Estudiante'**
  String get registerScreenTitle;

  /// No description provided for @createAccountTitle.
  ///
  /// In es, this message translates to:
  /// **'Crear Cuenta'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Regístrate como estudiante'**
  String get createAccountSubtitle;

  /// No description provided for @nameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre Completo'**
  String get nameLabel;

  /// No description provided for @enterName.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su nombre'**
  String get enterName;

  /// No description provided for @registerEmailLabel.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get registerEmailLabel;

  /// No description provided for @enterRegisterEmail.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su email'**
  String get enterRegisterEmail;

  /// No description provided for @invalidRegisterEmail.
  ///
  /// In es, this message translates to:
  /// **'Email inválido'**
  String get invalidRegisterEmail;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get registerPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In es, this message translates to:
  /// **'Confirmar Contraseña'**
  String get confirmPasswordLabel;

  /// No description provided for @enterRegisterPassword.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su contraseña'**
  String get enterRegisterPassword;

  /// No description provided for @confirmPasswordEmpty.
  ///
  /// In es, this message translates to:
  /// **'Confirme su contraseña'**
  String get confirmPasswordEmpty;

  /// No description provided for @passwordMismatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordMismatch;

  /// No description provided for @registerSuccess.
  ///
  /// In es, this message translates to:
  /// **'¡Registro exitoso! Ahora puedes iniciar sesión'**
  String get registerSuccess;

  /// No description provided for @registerError.
  ///
  /// In es, this message translates to:
  /// **'Error al registrarse'**
  String get registerError;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In es, this message translates to:
  /// **'¿Ya tienes cuenta?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginLinkText.
  ///
  /// In es, this message translates to:
  /// **'Inicia Sesión'**
  String get loginLinkText;

  /// No description provided for @words.
  ///
  /// In es, this message translates to:
  /// **'Palabras'**
  String get words;

  /// No description provided for @lessons.
  ///
  /// In es, this message translates to:
  /// **'Lecciones'**
  String get lessons;

  /// No description provided for @aiAssistant.
  ///
  /// In es, this message translates to:
  /// **'Asistente IA'**
  String get aiAssistant;

  /// No description provided for @vocabulary.
  ///
  /// In es, this message translates to:
  /// **'Vocabulario'**
  String get vocabulary;

  /// No description provided for @games.
  ///
  /// In es, this message translates to:
  /// **'Juegos'**
  String get games;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @logoutConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que deseas cerrar sesión?'**
  String get logoutConfirm;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @languageChanged.
  ///
  /// In es, this message translates to:
  /// **'Idioma cambiado correctamente'**
  String get languageChanged;

  /// No description provided for @about.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get about;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @spanish.
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get english;

  /// No description provided for @inga.
  ///
  /// In es, this message translates to:
  /// **'Inga Shimi'**
  String get inga;

  /// No description provided for @palabrasScreenTitle.
  ///
  /// In es, this message translates to:
  /// **'Palabras'**
  String get palabrasScreenTitle;

  /// No description provided for @editWord.
  ///
  /// In es, this message translates to:
  /// **'Editar Palabra'**
  String get editWord;

  /// No description provided for @newWord.
  ///
  /// In es, this message translates to:
  /// **'Nueva Palabra'**
  String get newWord;

  /// No description provided for @wordInInga.
  ///
  /// In es, this message translates to:
  /// **'Palabra en Inga'**
  String get wordInInga;

  /// No description provided for @translation.
  ///
  /// In es, this message translates to:
  /// **'Traducción al Español'**
  String get translation;

  /// No description provided for @category.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get category;

  /// No description provided for @updateWordButton.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get updateWordButton;

  /// No description provided for @createWordButton.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get createWordButton;

  /// No description provided for @deleteWordButton.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get deleteWordButton;

  /// No description provided for @wordDeletedToast.
  ///
  /// In es, this message translates to:
  /// **'Palabra eliminada'**
  String get wordDeletedToast;

  /// No description provided for @wordUpdatedToast.
  ///
  /// In es, this message translates to:
  /// **'Palabra actualizada'**
  String get wordUpdatedToast;

  /// No description provided for @wordCreatedToast.
  ///
  /// In es, this message translates to:
  /// **'Palabra creada'**
  String get wordCreatedToast;

  /// No description provided for @completeFieldsToast.
  ///
  /// In es, this message translates to:
  /// **'Complete los campos obligatorios'**
  String get completeFieldsToast;

  /// No description provided for @deleteWordConfirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar \"{word}\"?'**
  String deleteWordConfirm(Object word);

  /// No description provided for @noWordsMessage.
  ///
  /// In es, this message translates to:
  /// **'No hay palabras registradas'**
  String get noWordsMessage;

  /// No description provided for @vocabularioScreenTitle.
  ///
  /// In es, this message translates to:
  /// **'Vocabulario Inga'**
  String get vocabularioScreenTitle;

  /// No description provided for @vocabularioScreenSearchHint.
  ///
  /// In es, this message translates to:
  /// **'Buscar palabra...'**
  String get vocabularioScreenSearchHint;

  /// No description provided for @vocabularioScreenAllCategories.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get vocabularioScreenAllCategories;

  /// No description provided for @vocabularioScreenNoResults.
  ///
  /// In es, this message translates to:
  /// **'No se encontraron palabras'**
  String get vocabularioScreenNoResults;

  /// No description provided for @vocabularioScreenResultCount.
  ///
  /// In es, this message translates to:
  /// **'{count} palabra{count, plural, =1{} other{s}}'**
  String vocabularioScreenResultCount(num count);

  /// No description provided for @vocabularioScreenLoadingError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar vocabulario'**
  String get vocabularioScreenLoadingError;

  /// No description provided for @vocabularioDetailTitle.
  ///
  /// In es, this message translates to:
  /// **'Información adicional'**
  String get vocabularioDetailTitle;

  /// No description provided for @vocabularioDetailAudioAvailable.
  ///
  /// In es, this message translates to:
  /// **'Audio disponible'**
  String get vocabularioDetailAudioAvailable;

  /// No description provided for @vocabularioDetailAudioPlayingMsg.
  ///
  /// In es, this message translates to:
  /// **'Función de audio en desarrollo'**
  String get vocabularioDetailAudioPlayingMsg;

  /// No description provided for @vocabularioDetailCloseButton.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get vocabularioDetailCloseButton;

  /// No description provided for @leccionesScreenTitle.
  ///
  /// In es, this message translates to:
  /// **'Lecciones'**
  String get leccionesScreenTitle;

  /// No description provided for @leccionesScreenNoLessons.
  ///
  /// In es, this message translates to:
  /// **'No hay lecciones registradas'**
  String get leccionesScreenNoLessons;

  /// No description provided for @leccionesScreenLessonWords.
  ///
  /// In es, this message translates to:
  /// **'Palabras en esta lección:'**
  String get leccionesScreenLessonWords;

  /// No description provided for @leccionesScreenCreateLesson.
  ///
  /// In es, this message translates to:
  /// **'Nueva Lección'**
  String get leccionesScreenCreateLesson;

  /// No description provided for @leccionesScreenEditLesson.
  ///
  /// In es, this message translates to:
  /// **'Editar Lección'**
  String get leccionesScreenEditLesson;

  /// No description provided for @leccionesScreenLessonTitle.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get leccionesScreenLessonTitle;

  /// No description provided for @leccionesScreenLessonDescription.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get leccionesScreenLessonDescription;

  /// No description provided for @leccionesScreenLessonWordsLabel.
  ///
  /// In es, this message translates to:
  /// **'Palabras de la lección:'**
  String get leccionesScreenLessonWordsLabel;

  /// No description provided for @leccionesScreenCancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get leccionesScreenCancel;

  /// No description provided for @leccionesScreenCreateButton.
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get leccionesScreenCreateButton;

  /// No description provided for @leccionesScreenUpdateButton.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get leccionesScreenUpdateButton;

  /// No description provided for @leccionesScreenDeleteConfirmation.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar \"{title}\"?'**
  String leccionesScreenDeleteConfirmation(Object title);

  /// No description provided for @leccionesScreenLessonCreated.
  ///
  /// In es, this message translates to:
  /// **'Lección creada'**
  String get leccionesScreenLessonCreated;

  /// No description provided for @leccionesScreenLessonUpdated.
  ///
  /// In es, this message translates to:
  /// **'Lección actualizada'**
  String get leccionesScreenLessonUpdated;

  /// No description provided for @leccionesScreenLessonDeleted.
  ///
  /// In es, this message translates to:
  /// **'Lección eliminada'**
  String get leccionesScreenLessonDeleted;

  /// No description provided for @leccionesScreenEnterTitle.
  ///
  /// In es, this message translates to:
  /// **'Ingrese un título'**
  String get leccionesScreenEnterTitle;

  /// No description provided for @leccionesScreenNoWordsInLesson.
  ///
  /// In es, this message translates to:
  /// **'No hay palabras en esta lección'**
  String get leccionesScreenNoWordsInLesson;

  /// No description provided for @leccionesScreenWordsCount.
  ///
  /// In es, this message translates to:
  /// **'{count} palabras'**
  String leccionesScreenWordsCount(Object count);

  /// No description provided for @aiAssistantScreenTitle.
  ///
  /// In es, this message translates to:
  /// **'Asistente IA - Lengua Inga'**
  String get aiAssistantScreenTitle;

  /// No description provided for @aiAssistantPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Escribe tu pregunta...'**
  String get aiAssistantPlaceholder;

  /// No description provided for @aiAssistantThinking.
  ///
  /// In es, this message translates to:
  /// **'Pensando...'**
  String get aiAssistantThinking;

  /// No description provided for @aiAssistantWelcome.
  ///
  /// In es, this message translates to:
  /// **'👋 ¡Hola! Soy tu asistente de la lengua Inga.\n\nPuedo ayudarte a:\n• Traducir palabras (Español ↔ Inga)\n• Explicar gramática y pronunciación\n• Dar ejemplos de uso\n• Compartir aspectos culturales del pueblo Inga\n\n¿Qué deseas aprender hoy?'**
  String get aiAssistantWelcome;

  /// No description provided for @aiAssistantNotReady.
  ///
  /// In es, this message translates to:
  /// **'❌ La IA no está lista todavía.\nEspera unos segundos o revisa tu API Key.'**
  String get aiAssistantNotReady;

  /// No description provided for @aiAssistantInitSuccess.
  ///
  /// In es, this message translates to:
  /// **'✅ IA inicializada correctamente.'**
  String get aiAssistantInitSuccess;

  /// No description provided for @aiAssistantInitError.
  ///
  /// In es, this message translates to:
  /// **'❌ No se pudo inicializar la IA.\nVerifica tu conexión o API Key.\n\nDetalles: {error}'**
  String aiAssistantInitError(Object error);

  /// No description provided for @aiAssistantRequestError.
  ///
  /// In es, this message translates to:
  /// **'⚠️ Ocurrió un error al procesar tu solicitud.'**
  String get aiAssistantRequestError;

  /// No description provided for @aiAssistantQuickActionsTitle.
  ///
  /// In es, this message translates to:
  /// **'Acciones Rápidas'**
  String get aiAssistantQuickActionsTitle;

  /// No description provided for @aiAssistantQuickTranslateTitle.
  ///
  /// In es, this message translates to:
  /// **'Traducir palabra'**
  String get aiAssistantQuickTranslateTitle;

  /// No description provided for @aiAssistantQuickTranslateSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Español → Inga'**
  String get aiAssistantQuickTranslateSubtitle;

  /// No description provided for @aiAssistantQuickPronunciationTitle.
  ///
  /// In es, this message translates to:
  /// **'Pronunciación'**
  String get aiAssistantQuickPronunciationTitle;

  /// No description provided for @aiAssistantQuickPronunciationSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Aprender cómo se pronuncia'**
  String get aiAssistantQuickPronunciationSubtitle;

  /// No description provided for @aiAssistantQuickExampleTitle.
  ///
  /// In es, this message translates to:
  /// **'Ejemplo de uso'**
  String get aiAssistantQuickExampleTitle;

  /// No description provided for @aiAssistantQuickExampleSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Oraciones comunes'**
  String get aiAssistantQuickExampleSubtitle;

  /// No description provided for @aiAssistantEmptyConversation.
  ///
  /// In es, this message translates to:
  /// **'Inicia una conversación'**
  String get aiAssistantEmptyConversation;

  /// No description provided for @aiAssistantApiKeyMissing.
  ///
  /// In es, this message translates to:
  /// **'⚠️ No se detectó una API Key.\nConfigúrala en Google AI Studio: https://aistudio.google.com/app/apikey'**
  String get aiAssistantApiKeyMissing;

  /// No description provided for @juegosScreenTitle.
  ///
  /// In es, this message translates to:
  /// **'Juegos Interactivos'**
  String get juegosScreenTitle;

  /// No description provided for @juegosScreenGameMemoriaTitle.
  ///
  /// In es, this message translates to:
  /// **'Memoria'**
  String get juegosScreenGameMemoriaTitle;

  /// No description provided for @juegosScreenGameMemoriaDesc.
  ///
  /// In es, this message translates to:
  /// **'Encuentra las parejas'**
  String get juegosScreenGameMemoriaDesc;

  /// No description provided for @juegosScreenGameQuizTitle.
  ///
  /// In es, this message translates to:
  /// **'Quiz'**
  String get juegosScreenGameQuizTitle;

  /// No description provided for @juegosScreenGameQuizDesc.
  ///
  /// In es, this message translates to:
  /// **'Prueba tus conocimientos'**
  String get juegosScreenGameQuizDesc;

  /// No description provided for @juegosScreenGameFlashcardsTitle.
  ///
  /// In es, this message translates to:
  /// **'Flashcards'**
  String get juegosScreenGameFlashcardsTitle;

  /// No description provided for @juegosScreenGameFlashcardsDesc.
  ///
  /// In es, this message translates to:
  /// **'Repasa vocabulario'**
  String get juegosScreenGameFlashcardsDesc;

  /// No description provided for @juegosScreenGameCompletarTitle.
  ///
  /// In es, this message translates to:
  /// **'Completar'**
  String get juegosScreenGameCompletarTitle;

  /// No description provided for @juegosScreenGameCompletarDesc.
  ///
  /// In es, this message translates to:
  /// **'Completa la palabra'**
  String get juegosScreenGameCompletarDesc;

  /// No description provided for @quizGameTitle.
  ///
  /// In es, this message translates to:
  /// **'Quiz de Vocabulario'**
  String get quizGameTitle;

  /// No description provided for @quizGameScore.
  ///
  /// In es, this message translates to:
  /// **'Puntuación: {score}'**
  String quizGameScore(Object score);

  /// No description provided for @quizGameQuestion.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo se traduce?'**
  String get quizGameQuestion;

  /// No description provided for @quizGameFinishedTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Juego Terminado!'**
  String get quizGameFinishedTitle;

  /// No description provided for @quizGameExcellent.
  ///
  /// In es, this message translates to:
  /// **'¡Excelente!'**
  String get quizGameExcellent;

  /// No description provided for @quizGameKeepPracticing.
  ///
  /// In es, this message translates to:
  /// **'¡Sigue practicando!'**
  String get quizGameKeepPracticing;

  /// No description provided for @quizGameExit.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get quizGameExit;

  /// No description provided for @quizGameRestart.
  ///
  /// In es, this message translates to:
  /// **'Reiniciar'**
  String get quizGameRestart;

  /// No description provided for @quizGameNeedWords.
  ///
  /// In es, this message translates to:
  /// **'Se necesitan al menos 4 palabras'**
  String get quizGameNeedWords;

  /// No description provided for @flashcardsGameTitle.
  ///
  /// In es, this message translates to:
  /// **'Flashcards'**
  String get flashcardsGameTitle;

  /// No description provided for @flashcardsShowTranslationHint.
  ///
  /// In es, this message translates to:
  /// **'Toca la tarjeta para ver la traducción'**
  String get flashcardsShowTranslationHint;

  /// No description provided for @flashcardsNext.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get flashcardsNext;

  /// No description provided for @flashcardsPrevious.
  ///
  /// In es, this message translates to:
  /// **'Anterior'**
  String get flashcardsPrevious;

  /// No description provided for @memoriaGameTitle.
  ///
  /// In es, this message translates to:
  /// **'Memoria'**
  String get memoriaGameTitle;

  /// No description provided for @memoriaGameWinTitle.
  ///
  /// In es, this message translates to:
  /// **'¡Ganaste!'**
  String get memoriaGameWinTitle;

  /// No description provided for @memoriaGameWinMsg.
  ///
  /// In es, this message translates to:
  /// **'Has encontrado todas las parejas 🎉'**
  String get memoriaGameWinMsg;

  /// No description provided for @memoriaGameExit.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get memoriaGameExit;

  /// No description provided for @memoriaGameRestart.
  ///
  /// In es, this message translates to:
  /// **'Reiniciar'**
  String get memoriaGameRestart;

  /// No description provided for @memoriaGameLoadingError.
  ///
  /// In es, this message translates to:
  /// **'Error al cargar juego'**
  String get memoriaGameLoadingError;

  /// No description provided for @completarGameTitle.
  ///
  /// In es, this message translates to:
  /// **'Completar la Palabra'**
  String get completarGameTitle;

  /// No description provided for @completarGameInputHint.
  ///
  /// In es, this message translates to:
  /// **'Escribe la traducción en español...'**
  String get completarGameInputHint;

  /// No description provided for @completarGameCheckButton.
  ///
  /// In es, this message translates to:
  /// **'Comprobar'**
  String get completarGameCheckButton;

  /// No description provided for @completarGameFinishedTitle.
  ///
  /// In es, this message translates to:
  /// **'Juego Terminado'**
  String get completarGameFinishedTitle;

  /// No description provided for @completarGameScoreMsg.
  ///
  /// In es, this message translates to:
  /// **'Puntuación: {score}/{total}'**
  String completarGameScoreMsg(Object score, Object total);

  /// No description provided for @completarGameExit.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get completarGameExit;

  /// No description provided for @completarGameRestart.
  ///
  /// In es, this message translates to:
  /// **'Reiniciar'**
  String get completarGameRestart;

  /// No description provided for @completarGameCorrect.
  ///
  /// In es, this message translates to:
  /// **'¡Correcto!'**
  String get completarGameCorrect;

  /// No description provided for @completarGameIncorrect.
  ///
  /// In es, this message translates to:
  /// **'Incorrecto'**
  String get completarGameIncorrect;

  /// No description provided for @emailLabel.
  ///
  /// In es, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @userIdLabel.
  ///
  /// In es, this message translates to:
  /// **'ID de Usuario'**
  String get userIdLabel;

  /// No description provided for @roleLabel.
  ///
  /// In es, this message translates to:
  /// **'Rol'**
  String get roleLabel;

  /// No description provided for @rolePermissions.
  ///
  /// In es, this message translates to:
  /// **'Permisos de tu rol:'**
  String get rolePermissions;

  /// No description provided for @noRole.
  ///
  /// In es, this message translates to:
  /// **'Sin rol'**
  String get noRole;

  /// No description provided for @noPermissions.
  ///
  /// In es, this message translates to:
  /// **'Sin permisos asignados'**
  String get noPermissions;

  /// No description provided for @adminPermissions1.
  ///
  /// In es, this message translates to:
  /// **'Gestión completa de usuarios'**
  String get adminPermissions1;

  /// No description provided for @adminPermissions2.
  ///
  /// In es, this message translates to:
  /// **'Crear, editar y eliminar cualquier contenido'**
  String get adminPermissions2;

  /// No description provided for @adminPermissions3.
  ///
  /// In es, this message translates to:
  /// **'Acceso total al sistema'**
  String get adminPermissions3;

  /// No description provided for @adminPermissions4.
  ///
  /// In es, this message translates to:
  /// **'Gestión de roles'**
  String get adminPermissions4;

  /// No description provided for @teacherPermissions1.
  ///
  /// In es, this message translates to:
  /// **'Crear palabras y lecciones'**
  String get teacherPermissions1;

  /// No description provided for @teacherPermissions2.
  ///
  /// In es, this message translates to:
  /// **'Editar tu propio contenido'**
  String get teacherPermissions2;

  /// No description provided for @teacherPermissions3.
  ///
  /// In es, this message translates to:
  /// **'Eliminar tu propio contenido'**
  String get teacherPermissions3;

  /// No description provided for @teacherPermissions4.
  ///
  /// In es, this message translates to:
  /// **'Ver todo el contenido publicado'**
  String get teacherPermissions4;

  /// No description provided for @studentPermissions1.
  ///
  /// In es, this message translates to:
  /// **'Ver palabras publicadas'**
  String get studentPermissions1;

  /// No description provided for @studentPermissions2.
  ///
  /// In es, this message translates to:
  /// **'Ver lecciones publicadas'**
  String get studentPermissions2;

  /// No description provided for @studentPermissions3.
  ///
  /// In es, this message translates to:
  /// **'Acceso de solo lectura'**
  String get studentPermissions3;

  /// No description provided for @appInfoTitle.
  ///
  /// In es, this message translates to:
  /// **'Plataforma Educativa'**
  String get appInfoTitle;

  /// No description provided for @appInfoSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Documentación y difusión de la lengua Inga'**
  String get appInfoSubtitle;

  /// No description provided for @appVersion.
  ///
  /// In es, this message translates to:
  /// **'Versión 1.0.0'**
  String get appVersion;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get settingsLanguageSection;

  /// No description provided for @settingsThemeSection.
  ///
  /// In es, this message translates to:
  /// **'Tema'**
  String get settingsThemeSection;

  /// No description provided for @settingsPreviewSection.
  ///
  /// In es, this message translates to:
  /// **'Vista Previa'**
  String get settingsPreviewSection;

  /// No description provided for @settingsLanguageDefault.
  ///
  /// In es, this message translates to:
  /// **'Idioma predeterminado'**
  String get settingsLanguageDefault;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In es, this message translates to:
  /// **'Default language'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageInga.
  ///
  /// In es, this message translates to:
  /// **'Lengua nativa'**
  String get settingsLanguageInga;

  /// No description provided for @settingsThemeLight.
  ///
  /// In es, this message translates to:
  /// **'Claro'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeLightDesc.
  ///
  /// In es, this message translates to:
  /// **'Tema con fondo blanco'**
  String get settingsThemeLightDesc;

  /// No description provided for @settingsThemeDark.
  ///
  /// In es, this message translates to:
  /// **'Oscuro'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeDarkDesc.
  ///
  /// In es, this message translates to:
  /// **'Tema con fondo negro'**
  String get settingsThemeDarkDesc;

  /// No description provided for @settingsThemeBackground.
  ///
  /// In es, this message translates to:
  /// **'Imagen de Fondo'**
  String get settingsThemeBackground;

  /// No description provided for @settingsThemeBackgroundDesc.
  ///
  /// In es, this message translates to:
  /// **'Tema con imagen cultural'**
  String get settingsThemeBackgroundDesc;

  /// No description provided for @settingsChangesApplied.
  ///
  /// In es, this message translates to:
  /// **'Los cambios se aplican inmediatamente'**
  String get settingsChangesApplied;

  /// No description provided for @toastLanguageChanged.
  ///
  /// In es, this message translates to:
  /// **'Idioma cambiado a {name}'**
  String toastLanguageChanged(Object name);

  /// No description provided for @toastThemeChanged.
  ///
  /// In es, this message translates to:
  /// **'Tema cambiado a {name}'**
  String toastThemeChanged(Object name);

  /// No description provided for @exampleCardTitle.
  ///
  /// In es, this message translates to:
  /// **'Ejemplo de Tarjeta'**
  String get exampleCardTitle;

  /// No description provided for @exampleCardSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Así se ve el tema seleccionado'**
  String get exampleCardSubtitle;

  /// No description provided for @exampleCardInfo.
  ///
  /// In es, this message translates to:
  /// **'Esta es una vista previa del tema actual'**
  String get exampleCardInfo;

  /// No description provided for @exit.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get exit;

  /// No description provided for @play_again.
  ///
  /// In es, this message translates to:
  /// **'Jugar de nuevo'**
  String get play_again;

  /// No description provided for @game_completed_title.
  ///
  /// In es, this message translates to:
  /// **'¡Juego Completado! 🎉'**
  String get game_completed_title;

  /// No description provided for @score_label.
  ///
  /// In es, this message translates to:
  /// **'Puntuación'**
  String get score_label;

  /// No description provided for @correct_label.
  ///
  /// In es, this message translates to:
  /// **'Aciertos'**
  String get correct_label;

  /// No description provided for @wrong_label.
  ///
  /// In es, this message translates to:
  /// **'Errores'**
  String get wrong_label;

  /// No description provided for @time_label.
  ///
  /// In es, this message translates to:
  /// **'Tiempo'**
  String get time_label;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'qu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'qu':
      return AppLocalizationsQu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
