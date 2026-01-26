import 'package:flutter_bloc/flutter_bloc.dart';

import '../logger/logger.dart';

class AppBlocObserver extends BlocObserver with LoggerMixin {
  @override
  void onTransition(
    Bloc<Object?, Object?> bloc,
    Transition<Object?, Object?> transition,
  ) {
    final logMessage = StringBuffer();

    logMessage.writeln('Bloc: ${bloc.runtimeType}');
    logMessage.writeln('Transition: ${transition.event}');
    logMessage.writeln('From: ${transition.currentState}');
    logMessage.writeln('To: ${transition.nextState}');

    logger.info(logMessage.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc<Object?, Object?> bloc, Object? event) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln('Event: ${event.runtimeType}')
      ..write('Details: $event');

    logger.info(logMessage.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<Object?> bloc, Object error, StackTrace stackTrace) {
    final logMessage = StringBuffer()
      ..writeln('Bloc: ${bloc.runtimeType}')
      ..writeln(error.toString());

    logger.error(logMessage.toString(), error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
