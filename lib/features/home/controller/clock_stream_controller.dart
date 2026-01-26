import 'dart:async';

class StreamClockController {

  StreamClockController() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _controller.add(DateTime.now());
    });
  }
  final _controller = StreamController<DateTime>.broadcast();
  Timer? _timer;

  Stream<DateTime> get stream => _controller.stream;
  DateTime get currentTime => DateTime.now();

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
