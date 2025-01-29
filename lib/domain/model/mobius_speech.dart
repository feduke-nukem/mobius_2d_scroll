part of 'mobius.dart';

class MobiusSpeech with EquatableMixin {
  static const reservedDuration = Duration(hours: 1);

  final String id;
  final String scheduleId;
  final String title;
  final MobiusSpeaker speaker;
  final MobiusSpeechDuration duration;
  final MobiusSpeechStart start;
  final Iterable<MobiusSpeechTimestamp> timestamps;

  Duration get end => start + duration;

  const MobiusSpeech._({
    required this.id,
    required this.scheduleId,
    required this.title,
    required this.speaker,
    required this.duration,
    required this.start,
    required this.timestamps,
  });

  @override
  List<Object?> get props => [
        id,
        scheduleId,
        title,
        speaker,
        duration,
        start,
        timestamps,
      ];
}

extension type MobiusSpeechDuration._(Duration duration) implements Duration {
  factory MobiusSpeechDuration.create(Duration duration) {
    if (duration <= Duration.zero) {
      throw Exception('Speech start must be positive');
    }

    if (duration > MobiusSpeech.reservedDuration) {
      throw Exception('Speech cannot be more than 1 hour long');
    }

    return MobiusSpeechDuration._(duration);
  }
}

extension type MobiusSpeechStart._(Duration duration) implements Duration {
  factory MobiusSpeechStart.create(Duration duration) {
    if (duration > MobiusSchedule.capacity) {
      throw Exception('Can not start after schedule ended');
    }

    if (duration < Duration.zero) {
      throw Exception('Speech start must be positive');
    }

    return MobiusSpeechStart._(duration);
  }
}

class MobiusSpeechTimestamp with EquatableMixin {
  final Duration startsAt;
  final MobiusSpeechTimestampDetails details;

  MobiusSpeechTimestamp({
    required this.startsAt,
    required this.details,
  });

  Duration get endsAt => startsAt + details.duration;

  @override
  List<Object?> get props => [
        startsAt,
        details,
      ];
}

class MobiusSpeechTimestampDetails with EquatableMixin {
  final Duration duration;
  final String title;
  final String? description;
  final String coverUrl;

  const MobiusSpeechTimestampDetails({
    required this.duration,
    required this.title,
    required this.coverUrl,
    this.description,
  });

  @override
  List<Object?> get props => [
        duration,
        title,
        coverUrl,
        description,
      ];
}
