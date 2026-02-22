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

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @backgroundAnimation.
  ///
  /// In en, this message translates to:
  /// **'Background animation'**
  String get backgroundAnimation;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Auth failed'**
  String get authFailed;

  /// No description provided for @noAccountSignUp.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get noAccountSignUp;

  /// No description provided for @haveAccountSignIn.
  ///
  /// In en, this message translates to:
  /// **'Have an account? Sign in'**
  String get haveAccountSignIn;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @changeName.
  ///
  /// In en, this message translates to:
  /// **'Change name'**
  String get changeName;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @undefined.
  ///
  /// In en, this message translates to:
  /// **'Undefined'**
  String get undefined;

  /// No description provided for @goodNight.
  ///
  /// In en, this message translates to:
  /// **'Good night'**
  String get goodNight;

  /// No description provided for @keepSleepRhythm.
  ///
  /// In en, this message translates to:
  /// **'Keep your sleep rhythm stable'**
  String get keepSleepRhythm;

  /// No description provided for @startSleep.
  ///
  /// In en, this message translates to:
  /// **'Start sleep'**
  String get startSleep;

  /// No description provided for @stopSleep.
  ///
  /// In en, this message translates to:
  /// **'Stop sleep'**
  String get stopSleep;

  /// No description provided for @bedtimeMessage.
  ///
  /// In en, this message translates to:
  /// **'Bedtime: {time}'**
  String bedtimeMessage(Object time);

  /// No description provided for @setYourTime.
  ///
  /// In en, this message translates to:
  /// **'Set your time'**
  String get setYourTime;

  /// No description provided for @alarmSetMessage.
  ///
  /// In en, this message translates to:
  /// **'Alarm set for {time}'**
  String alarmSetMessage(Object time);

  /// No description provided for @writeReviewChooseQuality.
  ///
  /// In en, this message translates to:
  /// **'Write review and choose your sleep quality'**
  String get writeReviewChooseQuality;

  /// No description provided for @writeSleepNotes.
  ///
  /// In en, this message translates to:
  /// **'Write your notes about sleep'**
  String get writeSleepNotes;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @sleepAdded.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Sleep added.'**
  String get sleepAdded;

  /// No description provided for @yourSleepSessions.
  ///
  /// In en, this message translates to:
  /// **'Your Sleep Sessions'**
  String get yourSleepSessions;

  /// No description provided for @totalSleep.
  ///
  /// In en, this message translates to:
  /// **'Total Sleep: {hours} hrs'**
  String totalSleep(Object hours);

  /// No description provided for @averageSleep.
  ///
  /// In en, this message translates to:
  /// **'Average Sleep: {hours} hrs'**
  String averageSleep(Object hours);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @sleptAt.
  ///
  /// In en, this message translates to:
  /// **'Slept at {time}'**
  String sleptAt(Object time);

  /// No description provided for @fromTo.
  ///
  /// In en, this message translates to:
  /// **'From {bed} to {rise}'**
  String fromTo(Object bed, Object rise);

  /// No description provided for @noStatsFound.
  ///
  /// In en, this message translates to:
  /// **'No stats found'**
  String get noStatsFound;

  /// No description provided for @errorLoadingStats.
  ///
  /// In en, this message translates to:
  /// **'Error loading stats: {message}'**
  String errorLoadingStats(Object message);

  /// No description provided for @unknownState.
  ///
  /// In en, this message translates to:
  /// **'Unknown state'**
  String get unknownState;

  /// No description provided for @yourAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'Your AI Assistant'**
  String get yourAiAssistant;

  /// No description provided for @sleepAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Sleep analysis'**
  String get sleepAnalysis;

  /// No description provided for @analyzingSleep.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your sleep...'**
  String get analyzingSleep;

  /// No description provided for @yourData.
  ///
  /// In en, this message translates to:
  /// **'Your data:'**
  String get yourData;

  /// No description provided for @sleepHours.
  ///
  /// In en, this message translates to:
  /// **'🕐 Sleep: {hours} hours'**
  String sleepHours(Object hours);

  /// No description provided for @moodLabel.
  ///
  /// In en, this message translates to:
  /// **'😊 Mood: {mood}'**
  String moodLabel(Object mood);

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'📝 {notes}'**
  String notesLabel(Object notes);

  /// No description provided for @aiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI analysis'**
  String get aiAnalysis;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorPrefix(Object message);

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorLabel(Object message);

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'Sessions: {count}'**
  String sessionsCount(Object count);

  /// No description provided for @shortestSleep.
  ///
  /// In en, this message translates to:
  /// **'Shortest sleep: {hours} h'**
  String shortestSleep(Object hours);

  /// No description provided for @longestSleep.
  ///
  /// In en, this message translates to:
  /// **'Longest sleep: {hours} h'**
  String longestSleep(Object hours);

  /// No description provided for @lastSleep.
  ///
  /// In en, this message translates to:
  /// **'Last sleep: {hours} h, {quality}'**
  String lastSleep(Object hours, Object quality);

  /// No description provided for @syncPhoneDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Update phone health data?'**
  String get syncPhoneDataTitle;

  /// No description provided for @syncPhoneDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Load latest data from phone/watch now?'**
  String get syncPhoneDataMessage;

  /// No description provided for @updateData.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateData;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @syncPhoneDataSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone health data updated'**
  String get syncPhoneDataSuccess;

  /// No description provided for @syncPhoneDataFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update phone health data'**
  String get syncPhoneDataFailed;

  /// No description provided for @phoneDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone/watch data'**
  String get phoneDataTitle;

  /// No description provided for @stepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps: {steps}'**
  String stepsLabel(Object steps);

  /// No description provided for @caloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Calories: {calories}'**
  String caloriesLabel(Object calories);

  /// No description provided for @avgHeartRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg heart rate: {heartRate}'**
  String avgHeartRateLabel(Object heartRate);

  /// No description provided for @noPhoneDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No health data yet'**
  String get noPhoneDataTitle;

  /// No description provided for @noPhoneDataMessage.
  ///
  /// In en, this message translates to:
  /// **'No phone/watch data found for today. Load test data to verify the screen now?'**
  String get noPhoneDataMessage;

  /// No description provided for @loadTestData.
  ///
  /// In en, this message translates to:
  /// **'Load test data'**
  String get loadTestData;

  /// No description provided for @testDataLoaded.
  ///
  /// In en, this message translates to:
  /// **'Test health data loaded'**
  String get testDataLoaded;

  /// No description provided for @testDataLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load test health data'**
  String get testDataLoadFailed;
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
