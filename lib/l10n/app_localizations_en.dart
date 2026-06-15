// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Inga Language';

  @override
  String get platformSubtitle => 'Cultural Educational Platform';

  @override
  String get description =>
      'Educational platform for the documentation and dissemination of the Inga language';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get registerButton => 'Create Student Account';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get passwordMinLength => 'Minimum 6 characters';

  @override
  String welcomeMessage(Object nombre) {
    return 'Welcome $nombre!';
  }

  @override
  String get loginError => 'Login error';

  @override
  String get connectionError => 'Connection error';

  @override
  String get testUsersTitle => 'Test Users:';

  @override
  String get adminUser => 'Admin: admin@inga.com / admin123';

  @override
  String get teacherUser => 'Teacher: profesor@inga.com / profesor123';

  @override
  String get registerScreenTitle => 'Student Registration';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get createAccountSubtitle => 'Sign up as a student';

  @override
  String get nameLabel => 'Full Name';

  @override
  String get enterName => 'Enter your name';

  @override
  String get registerEmailLabel => 'Email';

  @override
  String get enterRegisterEmail => 'Enter your email';

  @override
  String get invalidRegisterEmail => 'Invalid email';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get enterRegisterPassword => 'Enter your password';

  @override
  String get confirmPasswordEmpty => 'Confirm your password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get registerSuccess => 'Registration successful! You can now log in';

  @override
  String get registerError => 'Registration error';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get loginLinkText => 'Log In';

  @override
  String get words => 'Words';

  @override
  String get lessons => 'Lessons';

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get vocabulary => 'Vocabulary';

  @override
  String get games => 'Games';

  @override
  String get profile => 'Profile';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get logout => 'Log out';

  @override
  String get cancel => 'Cancel';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get about => 'About';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Spanish';

  @override
  String get english => 'English';

  @override
  String get inga => 'Inga Shimi';

  @override
  String get palabrasScreenTitle => 'Words';

  @override
  String get editWord => 'Edit Word';

  @override
  String get newWord => 'New Word';

  @override
  String get wordInInga => 'Word in Inga';

  @override
  String get translation => 'Translation to Spanish';

  @override
  String get category => 'Category';

  @override
  String get updateWordButton => 'Update';

  @override
  String get createWordButton => 'Create';

  @override
  String get deleteWordButton => 'Delete';

  @override
  String get wordDeletedToast => 'Word deleted';

  @override
  String get wordUpdatedToast => 'Word updated';

  @override
  String get wordCreatedToast => 'Word created';

  @override
  String get completeFieldsToast => 'Complete required fields';

  @override
  String deleteWordConfirm(Object word) {
    return 'Delete \"$word\"?';
  }

  @override
  String get noWordsMessage => 'No words registered';

  @override
  String get vocabularioScreenTitle => 'Inga Vocabulary';

  @override
  String get vocabularioScreenSearchHint => 'Search word...';

  @override
  String get vocabularioScreenAllCategories => 'All';

  @override
  String get vocabularioScreenNoResults => 'No words found';

  @override
  String vocabularioScreenResultCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count word$_temp0';
  }

  @override
  String get vocabularioScreenLoadingError => 'Error loading vocabulary';

  @override
  String get vocabularioDetailTitle => 'Additional Information';

  @override
  String get vocabularioDetailAudioAvailable => 'Audio available';

  @override
  String get vocabularioDetailAudioPlayingMsg =>
      'Audio function under development';

  @override
  String get vocabularioDetailCloseButton => 'Close';

  @override
  String get leccionesScreenTitle => 'Lessons';

  @override
  String get leccionesScreenNoLessons => 'No lessons registered';

  @override
  String get leccionesScreenLessonWords => 'Words in this lesson:';

  @override
  String get leccionesScreenCreateLesson => 'New Lesson';

  @override
  String get leccionesScreenEditLesson => 'Edit Lesson';

  @override
  String get leccionesScreenLessonTitle => 'Title';

  @override
  String get leccionesScreenLessonDescription => 'Description';

  @override
  String get leccionesScreenLessonWordsLabel => 'Lesson words:';

  @override
  String get leccionesScreenCancel => 'Cancel';

  @override
  String get leccionesScreenCreateButton => 'Create';

  @override
  String get leccionesScreenUpdateButton => 'Update';

  @override
  String leccionesScreenDeleteConfirmation(Object title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get leccionesScreenLessonCreated => 'Lesson created';

  @override
  String get leccionesScreenLessonUpdated => 'Lesson updated';

  @override
  String get leccionesScreenLessonDeleted => 'Lesson deleted';

  @override
  String get leccionesScreenEnterTitle => 'Enter a title';

  @override
  String get leccionesScreenNoWordsInLesson => 'No words in this lesson';

  @override
  String leccionesScreenWordsCount(Object count) {
    return '$count words';
  }

  @override
  String get aiAssistantScreenTitle => 'AI Assistant - Inga Language';

  @override
  String get aiAssistantPlaceholder => 'Type your question...';

  @override
  String get aiAssistantThinking => 'Thinking...';

  @override
  String get aiAssistantWelcome =>
      '👋 Hello! I am your Inga language assistant.\n\nI can help you:\n• Translate words (Spanish ↔ Inga)\n• Explain grammar and pronunciation\n• Give usage examples\n• Share cultural aspects of the Inga people\n\nWhat would you like to learn today?';

  @override
  String get aiAssistantNotReady =>
      '❌ AI is not ready yet.\nPlease wait a few seconds or check your API Key.';

  @override
  String get aiAssistantInitSuccess => '✅ AI initialized successfully.';

  @override
  String aiAssistantInitError(Object error) {
    return '❌ AI could not be initialized.\nCheck your connection or API Key.\n\nDetails: $error';
  }

  @override
  String get aiAssistantRequestError =>
      '⚠️ An error occurred while processing your request.';

  @override
  String get aiAssistantQuickActionsTitle => 'Quick Actions';

  @override
  String get aiAssistantQuickTranslateTitle => 'Translate Word';

  @override
  String get aiAssistantQuickTranslateSubtitle => 'Spanish → Inga';

  @override
  String get aiAssistantQuickPronunciationTitle => 'Pronunciation';

  @override
  String get aiAssistantQuickPronunciationSubtitle => 'Learn how to pronounce';

  @override
  String get aiAssistantQuickExampleTitle => 'Usage Example';

  @override
  String get aiAssistantQuickExampleSubtitle => 'Common sentences';

  @override
  String get aiAssistantEmptyConversation => 'Start a conversation';

  @override
  String get aiAssistantApiKeyMissing =>
      '⚠️ No API Key detected.\nConfigure it in Google AI Studio: https://aistudio.google.com/app/apikey';

  @override
  String get juegosScreenTitle => 'Interactive Games';

  @override
  String get juegosScreenGameMemoriaTitle => 'Memory';

  @override
  String get juegosScreenGameMemoriaDesc => 'Find the pairs';

  @override
  String get juegosScreenGameQuizTitle => 'Quiz';

  @override
  String get juegosScreenGameQuizDesc => 'Test your knowledge';

  @override
  String get juegosScreenGameFlashcardsTitle => 'Flashcards';

  @override
  String get juegosScreenGameFlashcardsDesc => 'Review vocabulary';

  @override
  String get juegosScreenGameCompletarTitle => 'Complete';

  @override
  String get juegosScreenGameCompletarDesc => 'Complete the word';

  @override
  String get quizGameTitle => 'Vocabulary Quiz';

  @override
  String quizGameScore(Object score) {
    return 'Score: $score';
  }

  @override
  String get quizGameQuestion => 'How is it translated?';

  @override
  String get quizGameFinishedTitle => 'Game Over!';

  @override
  String get quizGameExcellent => 'Excellent!';

  @override
  String get quizGameKeepPracticing => 'Keep practicing!';

  @override
  String get quizGameExit => 'Exit';

  @override
  String get quizGameRestart => 'Restart';

  @override
  String get quizGameNeedWords => 'At least 4 words required';

  @override
  String get flashcardsGameTitle => 'Flashcards';

  @override
  String get flashcardsShowTranslationHint =>
      'Tap the card to see the translation';

  @override
  String get flashcardsNext => 'Next';

  @override
  String get flashcardsPrevious => 'Previous';

  @override
  String get memoriaGameTitle => 'Memory';

  @override
  String get memoriaGameWinTitle => 'You Won!';

  @override
  String get memoriaGameWinMsg => 'You found all pairs 🎉';

  @override
  String get memoriaGameExit => 'Exit';

  @override
  String get memoriaGameRestart => 'Restart';

  @override
  String get memoriaGameLoadingError => 'Error loading game';

  @override
  String get completarGameTitle => 'Complete the Word';

  @override
  String get completarGameInputHint => 'Type the Spanish translation...';

  @override
  String get completarGameCheckButton => 'Check';

  @override
  String get completarGameFinishedTitle => 'Game Over';

  @override
  String completarGameScoreMsg(Object score, Object total) {
    return 'Score: $score/$total';
  }

  @override
  String get completarGameExit => 'Exit';

  @override
  String get completarGameRestart => 'Restart';

  @override
  String get completarGameCorrect => 'Correct!';

  @override
  String get completarGameIncorrect => 'Incorrect';

  @override
  String get emailLabel => 'Email';

  @override
  String get userIdLabel => 'User ID';

  @override
  String get roleLabel => 'Role';

  @override
  String get rolePermissions => 'Your role permissions:';

  @override
  String get noRole => 'No role';

  @override
  String get noPermissions => 'No permissions assigned';

  @override
  String get adminPermissions1 => 'Full user management';

  @override
  String get adminPermissions2 => 'Create, edit and delete any content';

  @override
  String get adminPermissions3 => 'Full system access';

  @override
  String get adminPermissions4 => 'Role management';

  @override
  String get teacherPermissions1 => 'Create words and lessons';

  @override
  String get teacherPermissions2 => 'Edit your own content';

  @override
  String get teacherPermissions3 => 'Delete your own content';

  @override
  String get teacherPermissions4 => 'View all published content';

  @override
  String get studentPermissions1 => 'View published words';

  @override
  String get studentPermissions2 => 'View published lessons';

  @override
  String get studentPermissions3 => 'Read-only access';

  @override
  String get appInfoTitle => 'Educational Platform';

  @override
  String get appInfoSubtitle =>
      'Documentation and dissemination of the Inga language';

  @override
  String get appVersion => 'Version 1.0.0';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsThemeSection => 'Theme';

  @override
  String get settingsPreviewSection => 'Preview';

  @override
  String get settingsLanguageDefault => 'Default language';

  @override
  String get settingsLanguageEnglish => 'Default language';

  @override
  String get settingsLanguageInga => 'Native language';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeLightDesc => 'Theme with white background';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeDarkDesc => 'Theme with black background';

  @override
  String get settingsThemeBackground => 'Background Image';

  @override
  String get settingsThemeBackgroundDesc => 'Theme with cultural image';

  @override
  String get settingsChangesApplied => 'Changes apply immediately';

  @override
  String toastLanguageChanged(Object name) {
    return 'Language changed to $name';
  }

  @override
  String toastThemeChanged(Object name) {
    return 'Theme changed to $name';
  }

  @override
  String get exampleCardTitle => 'Example Card';

  @override
  String get exampleCardSubtitle => 'This is how the selected theme looks';

  @override
  String get exampleCardInfo => 'This is a preview of the current theme';

  @override
  String get exit => 'Exit';

  @override
  String get play_again => 'Play again';

  @override
  String get game_completed_title => 'Game Completed! 🎉';

  @override
  String get score_label => 'Score';

  @override
  String get correct_label => 'Correct';

  @override
  String get wrong_label => 'Wrong';

  @override
  String get time_label => 'Time';
}
