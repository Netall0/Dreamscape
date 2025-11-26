// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'meditation_event.dart';
// part 'meditation_state.dart';

// class MeditationBloc extends Bloc<MeditationEvent, MeditationState> {
//   // Dependencies
//   // final ISomeRepository _repository;
  
//   MeditationBloc({
//     // required ISomeRepository repository,
//   }) : // _repository = repository,
//        super(const MeditationInitial()) {
//     on<MeditationEvent>(
//       (event, emit) => switch (event) {
//         // SomeEvent() => _handleSomeEvent(event, emit),
//         // AnotherEvent() => _handleAnotherEvent(event, emit),
//       },
//       // Optional: transformer for debouncing, throttling, sequential processing
//       // transformer: BlocTransformer.debounce(duration: Duration(milliseconds: 300)),
//       // transformer: BlocTransformer.sequential(),
//     );
//   }

//   // Event handlers
//   // Future<void> _handleSomeEvent(
//   //   SomeEvent event,
//   //   Emitter<MeditationState> emit,
//   // ) async {
//   //   emit(const MeditationLoading());
//   //   try {
//   //     final result = await _repository.fetchData();
//   //     emit(MeditationLoaded(data: result));
//   //   } catch (e) {
//   //     emit(MeditationError(e));
//   //   }
//   // }
// }