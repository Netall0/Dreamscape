// part of 'meditation_bloc.dart';

// @immutable
// sealed class MeditationState {
//   const MeditationState();
// }

// final class MeditationInitial extends MeditationState {
//   const MeditationInitial();
// }

// final class MeditationLoading extends MeditationState {
//   const MeditationLoading();
// }

// final class MeditationLoaded extends MeditationState {
//   const MeditationLoaded({
//     // required this.data,
//   });
  
//   // final SomeModel data;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is MeditationLoaded &&
//           runtimeType == other.runtimeType;
//           // && data == other.data;

//   @override
//   int get hashCode => Object.hashAll([
//     // data,
//   ]);

//   MeditationLoaded copyWith({
//     // SomeModel? data,
//   }) {
//     return MeditationLoaded(
//       // data: data ?? this.data,
//     );
//   }
// }

// final class MeditationError extends MeditationState {
//   const MeditationError(this.error);
  
//   final Object error;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is MeditationError &&
//           runtimeType == other.runtimeType &&
//           error == other.error;

//   @override
//   int get hashCode => error.hashCode;
// }