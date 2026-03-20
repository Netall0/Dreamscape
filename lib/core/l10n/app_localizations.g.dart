import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.g.dart';
import 'app_localizations_ru.g.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.g.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('ru')];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'hello friend'**
  String get hello;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginButton;

  /// No description provided for @goodNight.
  ///
  /// In en, this message translates to:
  /// **'Good night'**
  String get goodNight;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeMessage;

  /// No description provided for @startSleeping.
  ///
  /// In en, this message translates to:
  /// **'Start Sleeping'**
  String get startSleeping;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsLocalization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get settingsLocalization;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get settingsLanguageRussian;

  /// No description provided for @statsReviewFromAi.
  ///
  /// In en, this message translates to:
  /// **'Review from AI'**
  String get statsReviewFromAi;

  /// No description provided for @statsAddFromHealthTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Stats from Health'**
  String get statsAddFromHealthTooltip;

  /// No description provided for @statsSleepSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Sleep Sessions'**
  String get statsSleepSessionsTitle;

  /// No description provided for @statsTotalSleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Sleep:'**
  String get statsTotalSleepLabel;

  /// No description provided for @statsAverageSleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Average Sleep:'**
  String get statsAverageSleepLabel;

  /// No description provided for @statsHoursShort.
  ///
  /// In en, this message translates to:
  /// **'hrs'**
  String get statsHoursShort;

  /// No description provided for @statsNoStatsFound.
  ///
  /// In en, this message translates to:
  /// **'No stats found'**
  String get statsNoStatsFound;

  /// No description provided for @statsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get statsDelete;

  /// No description provided for @statsSleptAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Slept at'**
  String get statsSleptAtLabel;

  /// No description provided for @statsFromLabel.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get statsFromLabel;

  /// No description provided for @statsToLabel.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get statsToLabel;

  /// No description provided for @statsNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get statsNotesLabel;

  /// No description provided for @statsErrorLoadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Error loading stats'**
  String get statsErrorLoadingLabel;

  /// No description provided for @statsUnknownState.
  ///
  /// In en, this message translates to:
  /// **'Unknown state'**
  String get statsUnknownState;

  /// No description provided for @analyzeTitle.
  ///
  /// In en, this message translates to:
  /// **'Sleep analysis'**
  String get analyzeTitle;

  /// No description provided for @analyzeHeader.
  ///
  /// In en, this message translates to:
  /// **'AI sleep review'**
  String get analyzeHeader;

  /// No description provided for @analyzeSubheader.
  ///
  /// In en, this message translates to:
  /// **'Summary and recommendations based on recent sleep sessions'**
  String get analyzeSubheader;

  /// No description provided for @analyzeLoading.
  ///
  /// In en, this message translates to:
  /// **'Preparing analysis...'**
  String get analyzeLoading;

  /// No description provided for @analyzePreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing analysis...'**
  String get analyzePreparing;

  /// No description provided for @addStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Stats'**
  String get addStatsTitle;

  /// No description provided for @addStatsPrompt.
  ///
  /// In en, this message translates to:
  /// **'Do you want to add stats from Health?'**
  String get addStatsPrompt;

  /// No description provided for @addStatsNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get addStatsNo;

  /// No description provided for @addStatsYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get addStatsYes;

  /// No description provided for @addStatsAdded.
  ///
  /// In en, this message translates to:
  /// **'Stats added from Health'**
  String get addStatsAdded;

  /// No description provided for @addStatsErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error adding stats'**
  String get addStatsErrorPrefix;

  /// No description provided for @editNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Change name'**
  String get editNameTitle;

  /// No description provided for @chooseSleepQualityTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your sleep quality'**
  String get chooseSleepQualityTitle;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good night'**
  String get homeGreeting;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your sleep rhythm stable'**
  String get homeSubtitle;

  /// No description provided for @authGenericError.
  ///
  /// In en, this message translates to:
  /// **'Auth failed'**
  String get authGenericError;

  /// No description provided for @authSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignInTitle;

  /// No description provided for @authSignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUpTitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignInButton;

  /// No description provided for @authSignUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get authSignUpButton;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Have an account? Sign in'**
  String get authHaveAccount;

  /// No description provided for @authEnterEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get authEnterEmailError;

  /// No description provided for @authInvalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email'**
  String get authInvalidEmailError;

  /// No description provided for @authEnterPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get authEnterPasswordError;

  /// No description provided for @authPasswordMinError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get authPasswordMinError;

  /// No description provided for @authConfirmPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPasswordError;

  /// No description provided for @authPasswordNotMatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordNotMatchError;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get profileNamePlaceholder;

  /// No description provided for @profilePasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get profilePasswordLabel;

  /// No description provided for @profileUndefined.
  ///
  /// In en, this message translates to:
  /// **'undefined'**
  String get profileUndefined;

  /// No description provided for @profileFeedback.
  ///
  /// In en, this message translates to:
  /// **'feedback'**
  String get profileFeedback;

  /// No description provided for @profileSignOut.
  ///
  /// In en, this message translates to:
  /// **'sign out'**
  String get profileSignOut;

  /// No description provided for @sleepStopButton.
  ///
  /// In en, this message translates to:
  /// **'Stop sleeping'**
  String get sleepStopButton;

  /// No description provided for @sleepAddedSnack.
  ///
  /// In en, this message translates to:
  /// **'Sleep added'**
  String get sleepAddedSnack;

  /// No description provided for @alarmNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Alarm'**
  String get alarmNotificationTitle;

  /// No description provided for @alarmNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Time to wake up'**
  String get alarmNotificationBody;

  /// No description provided for @alarmSetForPrefix.
  ///
  /// In en, this message translates to:
  /// **'Alarm set for'**
  String get alarmSetForPrefix;

  /// No description provided for @alarmSetButton.
  ///
  /// In en, this message translates to:
  /// **'Set your time'**
  String get alarmSetButton;

  /// No description provided for @clockErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get clockErrorPrefix;

  /// No description provided for @sleepDialogNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Write something'**
  String get sleepDialogNotesHint;

  /// No description provided for @sleepQualityBad.
  ///
  /// In en, this message translates to:
  /// **'bad'**
  String get sleepQualityBad;

  /// No description provided for @sleepQualityNormal.
  ///
  /// In en, this message translates to:
  /// **'normal'**
  String get sleepQualityNormal;

  /// No description provided for @sleepQualityGood.
  ///
  /// In en, this message translates to:
  /// **'good'**
  String get sleepQualityGood;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
