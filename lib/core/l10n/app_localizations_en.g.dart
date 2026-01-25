// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello friend!';

  @override
  String get appTitle => 'Dreamscape';

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
  String get profile => 'Profile';

  @override
  String get changeName => 'Change name';

  @override
  String get name => 'Name';

  @override
  String get password => 'Password';

  @override
  String get undefined => 'Not set';

  @override
  String get feedback => 'Feedback';

  @override
  String get signOut => 'Sign out';

  @override
  String get phone => 'Phone';

  @override
  String get changePhone => 'Change phone number';

  @override
  String get phoneHint => 'Enter phone number';

  @override
  String get phoneUpdated => 'Phone number updated!';

  @override
  String get phoneError => 'Failed to update phone number';

  @override
  String get feedbackTitle => 'Send Feedback';

  @override
  String get feedbackSubtitle => 'Help us improve the app';

  @override
  String get feedbackHint => 'Describe your issue or suggestion...';

  @override
  String get feedbackCategory => 'Category';

  @override
  String get feedbackCategoryBug => 'Bug';

  @override
  String get feedbackCategorySuggestion => 'Suggestion';

  @override
  String get feedbackSend => 'Send';

  @override
  String get feedbackSent => 'Thank you for your feedback!';

  @override
  String get feedbackEmpty => 'Please enter your feedback';

  @override
  String get themeSettings => 'App Theme';

  @override
  String get darkTheme => 'Dark';

  @override
  String get darkThemeSubtitle => 'Pure black background, minimal noise';

  @override
  String get lightTheme => 'Light';

  @override
  String get lightThemeSubtitle => 'White background, easy on the eyes';

  @override
  String get languageSettings => 'Language';

  @override
  String get english => 'English';

  @override
  String get russian => 'Russian';

  @override
  String get onboardingTitle1 => 'Dreamscape';

  @override
  String get onboardingSubtitle1 =>
      'Track your sleep without pain or hassle. Just go to bed — we\'ll help save the rest.';

  @override
  String get onboardingTitle2 => 'Sleep Statistics';

  @override
  String get onboardingSubtitle2 =>
      'See how much you actually sleep and how your sleep quality changes over time. The grid will show when you\'re burned out.';

  @override
  String get onboardingTitle3 => 'Your Rituals';

  @override
  String get onboardingSubtitle3 =>
      'Themes, sounds, and quick manual sleep entry — customize it for yourself and never miss a night.';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Let\'s go';

  @override
  String get onboardingPlaceholder => 'pallas cat\nsleeps';

  @override
  String get sleepSessions => 'Your Sleep Sessions';

  @override
  String get sleepStreak => 'Sleep streak';

  @override
  String totalSleepHours(String hours) {
    return 'Total Sleep Hours: $hours hrs';
  }

  @override
  String averageSleepHours(String hours) {
    return 'Average Sleep Hours: $hours hrs';
  }

  @override
  String sessionsCount(int count) {
    return 'Sessions: $count';
  }

  @override
  String get noStatsFound => 'No stats found';

  @override
  String youSleptFor(String duration) {
    return 'You slept for $duration';
  }

  @override
  String bedRiseTime(String bed, String rise) {
    return 'Bed: $bed • Rise: $rise';
  }

  @override
  String get delete => 'Delete';

  @override
  String get colorPickerTitle => 'Choose a color for sleep tracking';

  @override
  String get paletteTooltip => 'Customize colors';
}
