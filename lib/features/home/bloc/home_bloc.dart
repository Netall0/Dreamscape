// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'home_event.dart';
// part 'home_state.dart';

// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   // Dependencies
//   // final IHomeRepository _repository;
  
//   HomeBloc({
//     // required ISomeRepository repository,
//   }) : // _repository = repository,
//        super(const HomeInitial()) {
//     on<HomeEvent>(
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
//   //   Emitter<HomeState> emit,
//   // ) async {
//   //   emit(const HomeLoading());
//   //   try {
//   //     final result = await _repository.fetchData();
//   //     emit(HomeLoaded(data: result));
//   //   } catch (e) {
//   //     emit(HomeError(e));
//   //   }
//   // }
// }