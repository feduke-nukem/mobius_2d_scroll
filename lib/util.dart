import 'package:mobius_2d_scroll/domain/model/mobius.dart';

String createId() {
  return Object().hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');
}

const _durationFactor = 1000000;

extension DurationX on Duration {
  double toWidth({required double screenWidth, required double scale}) =>
      inMicroseconds *
      screenWidth *
      scale /
      (MobiusSchedule.capacity.inSeconds * _durationFactor);
}

extension DoubleX on double {
  Duration toDuration({required double screenWidth, required double scale}) =>
      Duration(
        microseconds: this *
            MobiusSchedule.capacity.inSeconds *
            _durationFactor ~/
            (screenWidth * scale),
      );
}

extension IterableX<T> on Iterable<T> {
  T? elementOrNull(int index) {
    if (index < 0) {
      return null;
    }

    return (index < length) ? elementAt(index) : null;
  }
}

extension TypeX<T> on T {
  Iterable<T> repeat(int times) sync* {
    for (var i = 0; i < times; i++) {
      yield this;
    }
  }

  K let<K>(K Function(T it) f) => f(this);
}

extension TimestampDetailsX on Iterable<MobiusSpeechTimestampDetails> {
  Iterable<MobiusSpeechTimestamp> toTimestamps() sync* {
    var timestampStartsAt = Duration.zero;

    for (final details in this) {
      yield MobiusSpeechTimestamp(
        startsAt: timestampStartsAt,
        details: details,
      );

      timestampStartsAt += details.duration;
    }
  }
}
