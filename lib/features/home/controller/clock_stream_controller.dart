import 'dart:async';

class StreamClockController {
  final _controller = StreamController<DateTime>.broadcast();
  Timer? _timer;

  Stream<DateTime> get stream => _controller.stream;
  DateTime get currentTime => DateTime.now();

  StreamClockController() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _controller.add(DateTime.now());
    });
  }

  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
