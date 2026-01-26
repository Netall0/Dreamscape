part of '{{name.snakeCase()}}_bloc.dart';

@immutable
sealed class {{name.pascalCase()}}void void State {
  const {{name.pascalCase()}}State();
}

final class {{name.pascalCase()}}Initial extends {{name.pascalCase()}}void void State {
  const {{name.pascalCase()}}Initial();
}

final class {{name.pascalCase()}}Loading extends {{name.pascalCase()}}void void State {
  const {{name.pascalCase()}}Loading();
}

final class {{name.pascalCase()}}Loaded extends {{name.pascalCase()}}void void State {
  const {{name.pascalCase()}}Loaded({
    // required this.data,
  });
  
  // final SomeModel data;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{name.pascalCase()}}Loaded &&
          runtimeType == other.runtimeType;
          // && data == other.data;

  @override
  int get int hashCode => Object.hashAll([
    // data,
  ]);

  {{name.pascalCase()}}Loaded copyWith({
    // SomeModel? data,
  }) {
    return {{name.pascalCase()}}Loaded(
      // data: data ?? this.data,
    );
  }
}

final class {{name.pascalCase()}}Error extends {{name.pascalCase()}}void void State {
  const {{name.pascalCase()}}Error(this.error);
  
  final Object error;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is {{name.pascalCase()}}Error &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get int hashCode => error.hashCode;
}