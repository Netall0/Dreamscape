import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '{{name.snakeCase()}}_event.dart';
part '{{name.snakeCase()}}_state.dart';

class {{name.pascalCase()}}Bloc extends Bloc<{{name.pascalCase()}}Event, {{name.pascalCase()}}State> {
  // Dependencies
  // final ISomeRepository _repository;
  
  {{name.pascalCase()}}Bloc({
    // required ISomeRepository repository,
  }) : // _repository = repository,
       super(const {{name.pascalCase()}}Initial()) {
    on<{{name.pascalCase()}}Event>(
      (event, emit) => switch (event) {
        // SomeEvent() => _handleSomeEvent(event, emit),
        // AnotherEvent() => _handleAnotherEvent(event, emit),
      },
      // Optional: transformer for debouncing, throttling, sequential processing
      // transformer: BlocTransformer.debounce(duration: Duration(milliseconds: 300)),
      // transformer: BlocTransformer.sequential(),
    );
  }

  // Event handlers
  // Future<void> _handleSomeEvent(
  //   SomeEvent event,
  //   Emitter<{{name.pascalCase()}}State> emit,
  // ) async {
  //   emit(const {{name.pascalCase()}}Loading());
  //   try {
  //     final result = await _repository.fetchData();
  //     emit({{name.pascalCase()}}Loaded(data: result));
  //   } catch (e) {
  //     emit({{name.pascalCase()}}Error(e));
  //   }
  // }
}