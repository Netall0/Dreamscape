// part of 'home_bloc.dart';

// @immutable
// sealed class HomeState {
//   const HomeState();
// }

// final class HomeInitial extends HomeState {
//   const HomeInitial();
// }

// final class HomeLoading extends HomeState {
//   const HomeLoading();
// }

// final class HomeLoaded extends HomeState {
//   const HomeLoaded({
//     // required this.data,
//   });
  
//   // final SomeModel data;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is HomeLoaded &&
//           runtimeType == other.runtimeType;
//           // && data == other.data;

//   @override
//   int get hashCode => Object.hashAll([
//     // data,
//   ]);

//   HomeLoaded copyWith({
//     // SomeModel? data,
//   }) {
//     return HomeLoaded(
//       // data: data ?? this.data,
//     );
//   }
// }

// final class HomeError extends HomeState {
//   const HomeError(this.error);
  
//   final Object error;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is HomeError &&
//           runtimeType == other.runtimeType &&
//           error == other.error;

//   @override
//   int get hashCode => error.hashCode;
// }