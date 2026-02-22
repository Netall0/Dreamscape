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
  String get theme => 'Тема';

  @override
  String get dark => 'Тёмная';

  @override
  String get light => 'Светлая';

  @override
  String get backgroundAnimation => 'Фоновая анимация';

  @override
  String get on => 'Вкл';

  @override
  String get off => 'Выкл';

  @override
  String get language => 'Язык';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get signIn => 'Войти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get email => 'Почта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Подтвердить пароль';

  @override
  String get authFailed => 'Ошибка авторизации';

  @override
  String get noAccountSignUp => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get haveAccountSignIn => 'Есть аккаунт? Войти';

  @override
  String get profile => 'Профиль';

  @override
  String get changeName => 'Изменить имя';

  @override
  String get name => 'Имя';

  @override
  String get phone => 'Телефон';

  @override
  String get feedback => 'Обратная связь';

  @override
  String get signOut => 'Выйти';

  @override
  String get undefined => 'Не указано';

  @override
  String get goodNight => 'Доброй ночи';

  @override
  String get keepSleepRhythm => 'Соблюдай стабильный режим сна';

  @override
  String get startSleep => 'Начать сон';

  @override
  String get stopSleep => 'Остановить сон';

  @override
  String bedtimeMessage(Object time) {
    return 'Отбой: $time';
  }

  @override
  String get setYourTime => 'Задать время';

  @override
  String alarmSetMessage(Object time) {
    return 'Будильник установлен на $time';
  }

  @override
  String get writeReviewChooseQuality => 'Напиши отзыв и выбери качество сна';

  @override
  String get writeSleepNotes => 'Напиши заметки о сне';

  @override
  String get done => 'Готово';

  @override
  String get sleepAdded => 'Сон добавлен.';

  @override
  String get yourSleepSessions => 'Сессии сна';

  @override
  String totalSleep(Object hours) {
    return 'Всего сна: $hours ч';
  }

  @override
  String averageSleep(Object hours) {
    return 'Средний сон: $hours ч';
  }

  @override
  String get delete => 'Удалить';

  @override
  String sleptAt(Object time) {
    return 'Уснул(а) в $time';
  }

  @override
  String fromTo(Object bed, Object rise) {
    return 'С $bed до $rise';
  }

  @override
  String get noStatsFound => 'Статистика не найдена';

  @override
  String errorLoadingStats(Object message) {
    return 'Ошибка загрузки: $message';
  }

  @override
  String get unknownState => 'Неизвестное состояние';

  @override
  String get yourAiAssistant => 'Твой AI помощник';

  @override
  String get sleepAnalysis => 'Анализ сна';

  @override
  String get analyzingSleep => 'Анализирую твой сон...';

  @override
  String get yourData => 'Твои данные:';

  @override
  String sleepHours(Object hours) {
    return '🕐 Сон: $hours часов';
  }

  @override
  String moodLabel(Object mood) {
    return '😊 Настроение: $mood';
  }

  @override
  String notesLabel(Object notes) {
    return '📝 $notes';
  }

  @override
  String get aiAnalysis => 'Анализ от AI';

  @override
  String errorPrefix(Object message) {
    return 'Ошибка: $message';
  }

  @override
  String errorLabel(Object message) {
    return 'Ошибка: $message';
  }

  @override
  String sessionsCount(Object count) {
    return 'Сессий: $count';
  }

  @override
  String shortestSleep(Object hours) {
    return 'Минимальный сон: $hours ч';
  }

  @override
  String longestSleep(Object hours) {
    return 'Максимальный сон: $hours ч';
  }

  @override
  String lastSleep(Object hours, Object quality) {
    return 'Последний сон: $hours ч, $quality';
  }

  @override
  String get syncPhoneDataTitle => 'Обновить данные с телефона?';

  @override
  String get syncPhoneDataMessage => 'Загрузить последние данные здоровья с телефона/часов?';

  @override
  String get updateData => 'Обновить';

  @override
  String get notNow => 'Позже';

  @override
  String get syncPhoneDataSuccess => 'Данные телефона обновлены';

  @override
  String get syncPhoneDataFailed => 'Не удалось обновить данные телефона';

  @override
  String get phoneDataTitle => 'Данные телефона/часов';

  @override
  String stepsLabel(Object steps) {
    return 'Шаги: $steps';
  }

  @override
  String caloriesLabel(Object calories) {
    return 'Калории: $calories';
  }

  @override
  String avgHeartRateLabel(Object heartRate) {
    return 'Средний пульс: $heartRate';
  }

  @override
  String get noPhoneDataTitle => 'Пока нет данных здоровья';

  @override
  String get noPhoneDataMessage =>
      'За сегодня нет данных с телефона/часов. Загрузить тестовые данные для проверки экрана?';

  @override
  String get loadTestData => 'Загрузить тестовые';

  @override
  String get testDataLoaded => 'Тестовые данные загружены';

  @override
  String get testDataLoadFailed => 'Не удалось загрузить тестовые данные';
}
