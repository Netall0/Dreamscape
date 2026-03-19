// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get hello => 'Привет, друг!';

  @override
  String get home => 'Главная';

  @override
  String get settings => 'Настройки';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get loginButton => 'Войти';

  @override
  String get welcomeMessage => 'С возвращением!';

  @override
  String get startSleeping => 'Начать спать';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get settingsThemeDark => 'Темная';

  @override
  String get settingsThemeLight => 'Светлая';

  @override
  String get settingsLocalization => 'Локализация';

  @override
  String get settingsLanguageEnglish => 'Английский';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get statsReviewFromAi => 'Обзор от ИИ';

  @override
  String get statsAddFromHealthTooltip => 'Добавить из Health';

  @override
  String get statsSleepSessionsTitle => 'Сессии сна';

  @override
  String get statsTotalSleepLabel => 'Общий сон:';

  @override
  String get statsAverageSleepLabel => 'Средний сон:';

  @override
  String get statsHoursShort => 'ч';

  @override
  String get statsNoStatsFound => 'Данных сна нет';

  @override
  String get statsDelete => 'Удалить';

  @override
  String get statsSleptAtLabel => 'Сон длился';

  @override
  String get statsFromLabel => 'С';

  @override
  String get statsToLabel => 'по';

  @override
  String get statsNotesLabel => 'Заметки';

  @override
  String get statsErrorLoadingLabel => 'Ошибка загрузки данных';

  @override
  String get statsUnknownState => 'Неизвестное состояние';

  @override
  String get analyzeTitle => 'Анализ сна';

  @override
  String get analyzeHeader => 'Разбор сна от ИИ';

  @override
  String get analyzeSubheader => 'Сводка и рекомендации на основе последних сессий сна';

  @override
  String get analyzeLoading => 'Собираю анализ...';

  @override
  String get analyzePreparing => 'Подготовка анализа...';

  @override
  String get addStatsTitle => 'Добавить данные';

  @override
  String get addStatsPrompt => 'Добавить данные сна из Health?';

  @override
  String get addStatsNo => 'Нет';

  @override
  String get addStatsYes => 'Да';

  @override
  String get addStatsAdded => 'Данные добавлены из Health';

  @override
  String get addStatsErrorPrefix => 'Ошибка добавления данных';

  @override
  String get editNameTitle => 'Изменить имя';

  @override
  String get chooseSleepQualityTitle => 'Выберите качество сна';

  @override
  String get homeGreeting => 'Спокойной ночи';

  @override
  String get homeSubtitle => 'Старайтесь держать режим сна стабильным';

  @override
  String get authGenericError => 'Ошибка авторизации';

  @override
  String get authSignInTitle => 'Вход';

  @override
  String get authSignUpTitle => 'Регистрация';

  @override
  String get authEmailLabel => 'Почта';

  @override
  String get authPasswordLabel => 'Пароль';

  @override
  String get authConfirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get authSignInButton => 'Войти';

  @override
  String get authSignUpButton => 'Зарегистрироваться';

  @override
  String get authNoAccount => 'Нет аккаунта? Зарегистрируйтесь';

  @override
  String get authHaveAccount => 'Есть аккаунт? Войти';

  @override
  String get authEnterEmailError => 'Введите почту';

  @override
  String get authInvalidEmailError => 'Введите корректную почту';

  @override
  String get authEnterPasswordError => 'Введите пароль';

  @override
  String get authPasswordMinError => 'Пароль должен быть не короче 6 символов';

  @override
  String get authConfirmPasswordError => 'Подтвердите пароль';

  @override
  String get authPasswordNotMatchError => 'Пароли не совпадают';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileNamePlaceholder => 'имя';

  @override
  String get profilePasswordLabel => 'пароль';

  @override
  String get profileUndefined => 'не указано';

  @override
  String get profileFeedback => 'обратная связь';

  @override
  String get profileSignOut => 'выйти';

  @override
  String get sleepStopButton => 'Остановить сон';

  @override
  String get sleepAddedSnack => 'Сон добавлен';

  @override
  String get alarmNotificationTitle => 'Будильник';

  @override
  String get alarmNotificationBody => 'Пора просыпаться';

  @override
  String get alarmSetForPrefix => 'Будильник установлен на';

  @override
  String get alarmSetButton => 'Установить время';

  @override
  String get clockErrorPrefix => 'Ошибка';

  @override
  String get sleepDialogNotesHint => 'Напишите заметку';

  @override
  String get sleepQualityBad => 'плохое';

  @override
  String get sleepQualityNormal => 'нормальное';

  @override
  String get sleepQualityGood => 'хорошее';
}
