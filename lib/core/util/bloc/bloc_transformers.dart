import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

final class BlocTransformer {
  static EventTransformer<T> debounce<T>(Duration duration) {
    return (Stream<T> events, Stream<T> Function(T) mapper) {
      return events.debounce(duration).switchMap<T>(mapper);
    };
  }

  static EventTransformer<T> concurrent<T>() {
    return (Stream<T> events, Stream<T> Function(T) mapper) {
      return events.concurrentAsyncExpand<T>(mapper);
    };
  }

  static EventTransformer<T> restartable<T>() {
    return (Stream<T> events, Stream<T> Function(T) mapper) {
      return events.switchMap<T>(mapper);
    };
  }

  static EventTransformer<T> sequential<T>() {
    return (Stream<T> events, Stream<T> Function(T) mapper) {
      return events.asyncExpand<T>(mapper);
    };
  }
}
