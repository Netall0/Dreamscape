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
  String get appTitle => 'Dreamscape';

  @override
  String get home => 'Главная';

  @override
  String get stats => 'Статистика';

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
  String get signIn => 'Войти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get email => 'Email';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get haveAccount => 'Уже есть аккаунт? Войти';

  @override
  String get dontHaveAccount => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get authFailed => 'Ошибка аутентификации';

  @override
  String get pleaseEnterEmail => 'Введите email';

  @override
  String get pleaseEnterValidEmail => 'Введите корректный email';

  @override
  String get pleaseEnterPassword => 'Введите пароль';

  @override
  String get passwordMinLength => 'Пароль должен быть не менее 6 символов';

  @override
  String get passwordsDontMatch => 'Пароли не совпадают';

  @override
  String get setYourTime => 'Установите время';

  @override
  String alarmSet(String time) {
    return 'Будильник установлен на $time';
  }

  @override
  String get alarmTitle => 'Просыпайся';

  @override
  String get alarmBody => 'Время вставать';

  @override
  String get sleepAdded => 'Поздравляем! Сон добавлен';

  @override
  String bedTime(String time) {
    return 'Время отхода ко сну: $time';
  }

  @override
  String get finishSleep => 'Завершить сон';

  @override
  String get howDidYouSleep => 'Как ты спал?';

  @override
  String get unknownState => 'Неизвестное состояние';

  @override
  String get profile => 'Профиль';

  @override
  String get changeName => 'Изменить имя';

  @override
  String get name => 'Имя';

  @override
  String get password => 'Пароль';

  @override
  String get undefined => 'Не задано';

  @override
  String get feedback => 'Обратная связь';

  @override
  String get signOut => 'Выйти';

  @override
  String get phone => 'Телефон';

  @override
  String get changePhone => 'Изменить номер телефона';

  @override
  String get phoneHint => 'Введите номер телефона';

  @override
  String get phoneUpdated => 'Номер телефона обновлён!';

  @override
  String get phoneError => 'Не удалось обновить номер';

  @override
  String get feedbackTitle => 'Обратная связь';

  @override
  String get feedbackSubtitle => 'Помоги нам улучшить приложение';

  @override
  String get feedbackHint => 'Опиши проблему или предложение...';

  @override
  String get feedbackCategory => 'Категория';

  @override
  String get feedbackCategoryBug => 'Баг';

  @override
  String get feedbackCategorySuggestion => 'Идея';

  @override
  String get feedbackSend => 'Отправить';

  @override
  String get feedbackSent => 'Спасибо за отзыв!';

  @override
  String get feedbackEmpty => 'Введите текст отзыва';

  @override
  String get themeSettings => 'Тема приложения';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String get darkThemeSubtitle => 'Чистый чёрный фон, минимум шума';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get lightThemeSubtitle => 'Белый фон, лёгкая дневная тема';

  @override
  String get languageSettings => 'Язык';

  @override
  String get english => 'Английский';

  @override
  String get russian => 'Русский';

  @override
  String get onboardingTitle1 => 'Dreamscape';

  @override
  String get onboardingSubtitle1 =>
      'Отслеживай свой сон без боли и лишней возни. Просто ложись спать — остальное мы поможем сохранить.';

  @override
  String get onboardingTitle2 => 'Статистика сна';

  @override
  String get onboardingSubtitle2 =>
      'Смотри, сколько ты реально спишь и как меняется качество сна по дням. Грид как на Git подскажет, когда ты выгорел.';

  @override
  String get onboardingTitle3 => 'Твои ритуалы';

  @override
  String get onboardingSubtitle3 =>
      'Темы, звуки и быстрый ручной ввод сна — подбери под себя и не теряй ни одной ночи.';

  @override
  String get onboardingNext => 'Дальше';

  @override
  String get onboardingStart => 'Поехали';

  @override
  String get onboardingPlaceholder => 'манул\nспит';

  @override
  String get sleepSessions => 'Твои сессии сна';

  @override
  String get sleepStreak => 'Трекер сна';

  @override
  String totalSleepHours(String hours) {
    return 'Всего часов сна: $hours ч';
  }

  @override
  String averageSleepHours(String hours) {
    return 'В среднем: $hours ч';
  }

  @override
  String sessionsCount(int count) {
    return 'Сессий: $count';
  }

  @override
  String get noStatsFound => 'Записей не найдено';

  @override
  String youSleptFor(String duration) {
    return 'Ты спал $duration';
  }

  @override
  String bedRiseTime(String bed, String rise) {
    return 'Лёг: $bed • Встал: $rise';
  }

  @override
  String get delete => 'Удалить';

  @override
  String get colorPickerTitle => 'Выбери цвет для трекинга сна';

  @override
  String get paletteTooltip => 'Настроить цвета';
}
