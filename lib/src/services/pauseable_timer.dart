// ignore_for_file: prefer_asserts_with_message, depend_on_referenced_packages

import 'dart:async' show Timer, Zone;

import 'package:clock/clock.dart' show clock;

final class PausableTimer implements Timer {
  PausableTimer(this.duration, void Function() callback)
      : assert(duration >= Duration.zero),
        _zone = Zone.current,
        _periodic = false {
    _callback = _zone.bindCallback(callback);
  }
  PausableTimer.periodic(this.duration, void Function() callback)
      : assert(duration >= Duration.zero),
        _zone = Zone.current,
        _periodic = true {
    _callback = _zone.bindCallback(callback);
  }
  final Zone _zone;
  Stopwatch? _stopwatch = clock.stopwatch();
  final bool _periodic;
  Timer? _timer;
  void Function()? _callback;
  int _tick = 0;

  void _startTimer() {
    assert(_stopwatch != null);

    if (_periodic && _stopwatch!.elapsed == Duration.zero) {
      _timer = _zone.createPeriodicTimer(
        duration,
        (Timer timer) {
          _tick++;
          _zone.run(_callback!);
          _stopwatch = clock.stopwatch();
          _stopwatch!.start();
        },
      );
    } else {
      _timer = _zone.createTimer(
        duration - _stopwatch!.elapsed,
        () {
          _tick++;
          if (_periodic) {
            reset();
          } else {
            _timer = null;
            _stopwatch = null;
          }
          _zone.run(_callback!);
        },
      );
    }

    _stopwatch!.start();
  }

  final Duration duration;

  Duration get elapsed => _stopwatch?.elapsed ?? duration;

  bool get isPaused => _timer == null && !isExpired && !isCancelled;

  bool get isExpired => _stopwatch == null;

  bool get isCancelled => _callback == null;

  @override
  bool get isActive => _timer != null;

  @override
  int get tick => _tick;

  @override
  void cancel() {
    _stopwatch?.stop();
    _timer?.cancel();
    _timer = null;
    _callback = null;
  }

  void start() {
    if (isActive || isExpired || isCancelled) return;
    _startTimer();
  }

  void pause() {
    _stopwatch?.stop();
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    if (isCancelled) return;
    _stopwatch = clock.stopwatch();
    if (isActive) {
      _timer!.cancel(); // it has to be non-null if it's active
      _startTimer();
    }
  }
}
