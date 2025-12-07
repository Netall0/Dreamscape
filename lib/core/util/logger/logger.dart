import 'dart:developer' as developer;
import 'package:dreamscape/core/util/logger/i_logger.dart';
import 'package:flutter/foundation.dart';

enum LogLevel {
  debug(0, 'DEBUG'),
  info(1, 'INFO'),
  warn(2, 'WARN'),
  error(3, 'ERROR'),
  fatal(4, 'FATAL');

  const LogLevel(this.level, this.name);
  final int level;
  final String name;
}

final class AppLogger implements IAppLogger {
  AppLogger({this.context});

  final String? context; // ✅ Опциональный контекст
  final _minLevel = kDebugMode ? LogLevel.debug : LogLevel.warn;

  @override
  void debug(
    String message, {
    String? context, // Можно переопределить
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.debug,
      message,
      context ?? this.context, // ✅ Используем дефолтный или переданный
      error,
      stackTrace,
    );
  }

  @override
  void info(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.info, message, context ?? this.context, error, stackTrace);
  }

  @override
  void warn(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.warn, message, context ?? this.context, error, stackTrace);
  }

  @override
  void error(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message, context ?? this.context, error, stackTrace);
  }

  @override
  void fatal(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.fatal, message, context ?? this.context, error, stackTrace);
  }

  void _log(
    LogLevel level,
    String message,
    String? context, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (level.level < _minLevel.level) return;

    final timestamp = DateTime.now();
    final timeStr =
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}.'
        '${timestamp.millisecond.toString().padLeft(3, '0')}';

    final contextStr = context != null ? '[$context] ' : '';
    final logMessage = '[$timeStr] $contextStr${level.name}: $message';

    if (kDebugMode) {
      final buffer = StringBuffer();
      buffer.writeln(logMessage);
      if (error != null) buffer.writeln(error);
      if (stackTrace != null) {
        final lines = stackTrace.toString().split('\n').take(5);
        for (final line in lines) {
          buffer.writeln('  $line');
        }
      }

      developer.log(
        buffer.toString(),
        name: 'AppLogger${context != null ? '.$context' : ''}',
        level: _getDeveloperLevel(level),
      );
    } else {
      developer.log(
        logMessage,
        name: 'AppLogger${context != null ? '.$context' : ''}',
        level: _getDeveloperLevel(level),
      );
    }
  }

  int _getDeveloperLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warn:
        return 900;
      case LogLevel.error:
      case LogLevel.fatal:
        return 1000;
    }
  }
}

mixin LoggerMixin {
  AppLogger get logger =>
      _logger ??= AppLogger(context: runtimeType.toString());
  AppLogger? _logger;
}
