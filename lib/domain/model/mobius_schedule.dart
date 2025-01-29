part of 'mobius.dart';

class MobiusSchedule with EquatableMixin {
  static const capacity = Duration(hours: 4);

  final String id;
  final DateTime date;
  final Iterable<MobiusSpeech> speeches;
  final Duration duration;

  Duration get remainingCapacity => capacity - duration;
  bool get isEnded => date.isBefore(DateTime.now());
  bool get isBooked => remainingCapacity == Duration.zero;

  MobiusSchedule._({
    required this.id,
    required this.speeches,
    required this.date,
  }) : duration = speeches.fold(
          Duration.zero,
          (prev, curr) => prev + curr.duration,
        );

  @override
  List<Object?> get props => [
        id,
        date,
        speeches,
      ];

  bool overlaps(DateTime date) =>
      this.date.year == date.year &&
      this.date.month == date.month &&
      this.date.day == date.day;

  MobiusSchedule _addSpeech({
    required String title,
    required MobiusSpeaker speaker,
    required MobiusSpeechDuration duration,
    required Iterable<MobiusSpeechTimestampDetails> timestampDetails,
  }) {
    _isNotOutdated();

    if (this.duration + duration > capacity) {
      throw Exception('Schedule cannot be more than 4 hour long');
    }

    final lastStarts = speeches.lastOrNull?.start;

    final speech = MobiusSpeech._(
      id: createId(),
      scheduleId: id,
      title: title,
      speaker: speaker,
      duration: duration,
      start: MobiusSpeechStart.create(
        lastStarts != null
            ? lastStarts + MobiusSpeech.reservedDuration
            : Duration.zero,
      ),
      timestamps: timestampDetails.toTimestamps().toList(),
    );

    return MobiusSchedule._(
      id: id,
      date: date,
      speeches: [...speeches, speech],
    );
  }

  void _isNotOutdated() {
    if (isEnded) {
      throw Exception('Date $date is in the past');
    }
  }
}
