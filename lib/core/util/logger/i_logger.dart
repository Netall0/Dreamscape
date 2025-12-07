abstract interface class IAppLogger {
  void debug(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  });

  void info(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  });

  void warn(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  });

  void error(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  });

  void fatal(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  });
}
