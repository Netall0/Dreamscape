// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'hello friend';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get loginButton => 'Log In';

  @override
  String get welcomeMessage => 'Welcome back!';

  @override
  String get startSleeping => 'Start Sleeping';

  @override
  String get theme => 'Theme';

  @override
  String get dark => 'Dark';

  @override
  String get light => 'Light';

  @override
  String get backgroundAnimation => 'Background animation';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get language => 'Language';

  @override
  String get languageRussian => 'Russian';

  @override
  String get languageEnglish => 'English';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get authFailed => 'Auth failed';

  @override
  String get noAccountSignUp => 'Don\'t have an account? Sign up';

  @override
  String get haveAccountSignIn => 'Have an account? Sign in';

  @override
  String get profile => 'Profile';

  @override
  String get changeName => 'Change name';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get feedback => 'Feedback';

  @override
  String get signOut => 'Sign out';

  @override
  String get undefined => 'Undefined';

  @override
  String get goodNight => 'Good night';

  @override
  String get keepSleepRhythm => 'Keep your sleep rhythm stable';

  @override
  String get startSleep => 'Start sleep';

  @override
  String get stopSleep => 'Stop sleep';

  @override
  String bedtimeMessage(Object time) {
    return 'Bedtime: $time';
  }

  @override
  String get setYourTime => 'Set your time';

  @override
  String alarmSetMessage(Object time) {
    return 'Alarm set for $time';
  }

  @override
  String get writeReviewChooseQuality => 'Write review and choose your sleep quality';

  @override
  String get writeSleepNotes => 'Write your notes about sleep';

  @override
  String get done => 'Done';

  @override
  String get sleepAdded => 'Congratulations! Sleep added.';

  @override
  String get yourSleepSessions => 'Your Sleep Sessions';

  @override
  String totalSleep(Object hours) {
    return 'Total Sleep: $hours hrs';
  }

  @override
  String averageSleep(Object hours) {
    return 'Average Sleep: $hours hrs';
  }

  @override
  String get delete => 'Delete';

  @override
  String sleptAt(Object time) {
    return 'Slept at $time';
  }

  @override
  String fromTo(Object bed, Object rise) {
    return 'From $bed to $rise';
  }

  @override
  String get noStatsFound => 'No stats found';

  @override
  String errorLoadingStats(Object message) {
    return 'Error loading stats: $message';
  }

  @override
  String get unknownState => 'Unknown state';

  @override
  String get yourAiAssistant => 'Your AI Assistant';

  @override
  String get sleepAnalysis => 'Sleep analysis';

  @override
  String get analyzingSleep => 'Analyzing your sleep...';

  @override
  String get yourData => 'Your data:';

  @override
  String sleepHours(Object hours) {
    return '🕐 Sleep: $hours hours';
  }

  @override
  String moodLabel(Object mood) {
    return '😊 Mood: $mood';
  }

  @override
  String notesLabel(Object notes) {
    return '📝 $notes';
  }

  @override
  String get aiAnalysis => 'AI analysis';

  @override
  String errorPrefix(Object message) {
    return 'Error: $message';
  }

  @override
  String errorLabel(Object message) {
    return 'Error: $message';
  }
}
