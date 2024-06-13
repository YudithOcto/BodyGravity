import 'dart:async';
import 'dart:ui';

class Debouncer {
  late int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds, this.action});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}