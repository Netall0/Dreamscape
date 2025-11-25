import 'package:flutter/material.dart';

class ColorConstants {
  // ОСНОВНЫЕ ЦВЕТА - контрастные и читаемые
  static const primaryLight = Color(0xFF1D4ED8); // Глубокий синий
  static const primaryDark = Color(0xFF60A5FA); // Яркий синий для темной темы

  static const secondaryLight = Color(0xFF059669); // Насыщенный зеленый
  static const secondaryDark = Color(0xFF10B981); // Более яркий зеленый

  // ФОНЫ - четкое разделение
  static const backgroundLight = Color(0xFFFFFFFF); // Чистый белый
  static const backgroundDark = Color.fromARGB(255, 0, 0, 0); // Глубокий темный

  static const surfaceLight = Color.fromARGB(
    255,
    207,
    207,
    207,
  ); // Очень светло-серый
  static const surfaceDark = Color(0xFF1E293B); // Темно-серый

  // ТЕКСТОВЫЕ ЦВЕТА - максимальный контраст для читаемости
  static const textPrimaryLight = Color(0xFF0F172A); // Почти черный
  static const textSecondaryLight = Color(0xFF475569); // Средне-темный серый
  static const textDisabledLight = Color(0xFF94A3B8); // Светло-серый

  static const textPrimaryDark = Color(0xFFF8FAFC); // Почти белый
  static const textSecondaryDark = Color(0xFFCBD5E1); // Светло-серый
  static const textDisabledDark = Color(0xFF64748B); // Средне-серый

  // КОМПОНЕНТЫ - четко различимые
  static const cardBackgroundLight = Color.fromARGB(
    255,
    221,
    219,
    219,
  ); // Белый для карточек
  static const dividerColorLight = Color(0xFFE2E8F0); // Видимый разделитель
  static const shadowColorLight = Color(0x0D000000); // Мягкая тень

  static const cardBackgroundDark = Color.fromARGB(
    255,
    25,
    25,
    36,
  ); // Контрастный серый
  static const dividerColorDark = Color(0xFF475569); // Видимый разделитель
  static const shadowColorDark = Color(0x26000000); // Заметная тень

  // ЦВЕТА СОСТОЯНИЙ - яркие и различимые
  static const successLight = Color(0xFF059669);
  static const successDark = Color(0xFF10B981);

  static const warningLight = Color(0xFFD97706);
  static const warningDark = Color(0xFFF59E0B);

  static const errorLight = Color(0xFFDC2626);
  static const errorDark = Color(0xFFF87171);

  static const infoLight = Color(0xFF2563EB);
  static const infoDark = Color(0xFF3B82F6);

  // СЕРАЯ ПАЛИТРА для светлой темы - четкая градация
  static const gray50 = Color(0xFFF8FAFC);
  static const gray100 = Color(0xFFF1F5F9);
  static const gray200 = Color(0xFFE2E8F0);
  static const gray300 = Color(0xFFCBD5E1);
  static const gray400 = Color(0xFF94A3B8);
  static const gray500 = Color(0xFF64748B);
  static const gray600 = Color(0xFF475569);
  static const gray700 = Color(0xFF334155);
  static const gray800 = Color(0xFF1E293B);
  static const gray900 = Color(0xFF0F172A);

  // СЕРАЯ ПАЛИТРА для темной темы - инвертированная логика
  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);


  // Shadows - более мягкие и естественные
  static const shadowElevation1 = [
    BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x0D000000)),
  ];

  static const shadowElevation2 = [
    BoxShadow(offset: Offset(0, 2), blurRadius: 4, color: Color(0x0D000000)),
    BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x05000000)),
  ];

  static const shadowElevation3 = [
    BoxShadow(offset: Offset(0, 4), blurRadius: 8, color: Color(0x0D000000)),
    BoxShadow(offset: Offset(0, 2), blurRadius: 4, color: Color(0x08000000)),
  ];

  // Тени для темной темы - более выраженные
  static const shadowElevation1Dark = [
    BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x26000000)),
  ];

  static const shadowElevation2Dark = [
    BoxShadow(offset: Offset(0, 2), blurRadius: 4, color: Color(0x26000000)),
    BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x1A000000)),
  ];

  static const shadowElevation3Dark = [
    BoxShadow(offset: Offset(0, 4), blurRadius: 8, color: Color(0x26000000)),
    BoxShadow(offset: Offset(0, 2), blurRadius: 4, color: Color(0x1A000000)),
  ];
}
