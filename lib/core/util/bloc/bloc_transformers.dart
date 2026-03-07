import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

final class BlocTransformer {
  static EventTransformer<T> debounce<T>(Duration duration) => (Stream<T> events, Stream<T> Function(T) mapper) => events.debounce(duration).switchMap<T>(mapper);

  static EventTransformer<T> concurrent<T>() => (Stream<T> events, Stream<T> Function(T) mapper) => events.concurrentAsyncExpand<T>(mapper);

  static EventTransformer<T> restartable<T>() => (Stream<T> events, Stream<T> Function(T) mapper) => events.switchMap<T>(mapper);

  static EventTransformer<T> sequential<T>() => (Stream<T> events, Stream<T> Function(T) mapper) => events.asyncExpand<T>(mapper);
}
