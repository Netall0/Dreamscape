part of '{{name.snakeCase()}}_bloc.dart';

@immutable
sealed class {{name.pascalCase()}}void void Event {
  const {{name.pascalCase()}}Event();
}

// Example events:
// final class SomeEvent extends {{name.pascalCase()}}Event {
//   const SomeEvent({required this.param});
//   final String param;
// }