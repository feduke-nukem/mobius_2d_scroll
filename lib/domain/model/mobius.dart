import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:mobius_2d_scroll/domain/model/mobius_speaker.dart'
    show MobiusSpeaker;
import 'package:mobius_2d_scroll/util.dart'
    show TypeX, createId, TimestampDetailsX;

part 'mobius_schedule.dart';
part 'mobius_speech.dart';

class Mobius with EquatableMixin {
  final Iterable<MobiusSchedule> schedules;

  const Mobius._({required this.schedules});

  const Mobius.empty() : schedules = const [];

  factory Mobius.filled() {
    return Mobius._(
      schedules: [
        createId().let(
          (it) => MobiusSchedule._(
            id: it,
            speeches: [
              MobiusSpeech._(
                id: createId(),
                scheduleId: it,
                title: 'Да кто этот ваш 2D скролл?',
                speaker: MobiusSpeaker.create(
                  name: 'Fedor Blagodyr',
                  avatarUrl:
                      'https://avatars.githubusercontent.com/u/72284940?v=4',
                ),
                duration: MobiusSpeechDuration.create(
                  const Duration(minutes: 50),
                ),
                start: MobiusSpeechStart.create(Duration.zero),
                timestamps: const [
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 2),
                    title: 'Вступление',
                    coverUrl: 'assets/1.png',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 5),
                    title: 'План',
                    coverUrl: 'assets/2.png',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 10),
                    title: 'Введение',
                    coverUrl: 'assets/3.gif',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 10),
                    title: 'Современный подход',
                    coverUrl: 'assets/4.gif',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 20),
                    title: 'Собственная реализация',
                    coverUrl: 'assets/5.gif',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 5),
                    title: 'Заключение',
                    coverUrl: 'assets/6.png',
                  ),
                ].toTimestamps().toList(),
              ),
              MobiusSpeech._(
                id: createId(),
                scheduleId: it,
                title: 'За осла и болото',
                speaker: MobiusSpeaker.create(
                  name: 'Shrek',
                  avatarUrl:
                      'https://miro.medium.com/v2/resize:fit:1200/1*LpxLQj3xgPwMaUjaM3NW7g.jpeg',
                ),
                duration: MobiusSpeechDuration.create(
                  const Duration(minutes: 35),
                ),
                start: MobiusSpeechStart.create(const Duration(minutes: 70)),
                timestamps: const [
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 5),
                    title: 'Классная жизнь',
                    coverUrl:
                        'https://i.ytimg.com/vi/zeROGNnOkmg/maxresdefault.jpg?sqp=-oaymwEmCIAKENAF8quKqQMa8AEB-AH-CYAC0AWKAgwIABABGFcgZSg8MA8=&rs=AOn4CLAgk4K31qha8dfTEGCq-3jxu599KQ',
                  ),
                  MobiusSpeechTimestampDetails(
                      duration: Duration(minutes: 3),
                      title: 'Осёл',
                      coverUrl:
                          'https://0d314c86-f76b-45cc-874e-45816116a667.selcdn.net/07885433-5018-4754-a346-db0f4ec5036a.jpg'),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 2),
                    title: 'Великаны как луковица',
                    coverUrl:
                        'https://i.ytimg.com/vi/_BxMOmneZgk/maxresdefault.jpg',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 10),
                    title: 'Спасаем принцессу',
                    coverUrl:
                        'https://flomaster.top/o/uploads/posts/2024-02/1708694100_flomaster-top-p-shrek-v-shleme-krasivo-narisovannie-5.jpg',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 5),
                    title: 'Рефлексия',
                    coverUrl:
                        'https://memi.klev.club/uploads/posts/2024-06/memi-klev-club-bjaj-p-memi-grustnii-shrek-6.jpg',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 5),
                    title: 'Спасаем принцессу снова',
                    coverUrl:
                        'https://avatars.dzeninfra.ru/get-zen_doc/4340895/pub_6058bfe5c8a51571e853b340_605f9d5596354e3b8a7a9332/scale_1200',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 10),
                    title: 'И жили они долго и счастливо',
                    coverUrl:
                        'https://cdn.7days.ru/pic/647/993701/1520439/86.jpg',
                  ),
                ].toTimestamps().toList(),
              ),
            ],
            date: DateTime(2025, 3, 3),
          ),
        ),
        createId().let(
          (it) => MobiusSchedule._(
            id: it,
            speeches: [
              MobiusSpeech._(
                id: createId(),
                scheduleId: it,
                title: 'Да кто этот ваш 2D скролл?',
                speaker: MobiusSpeaker.create(
                  name: 'Fedor Blagodyr',
                  avatarUrl:
                      'https://avatars.githubusercontent.com/u/72284940?v=4',
                ),
                duration: MobiusSpeechDuration.create(
                  const Duration(hours: 1),
                ),
                start: MobiusSpeechStart.create(const Duration(minutes: 15)),
                timestamps: const [
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 10),
                    title: 'Вступление',
                    coverUrl: 'assets/1.png',
                    description:
                        'Представление спикера и рассказ о теме сегодняшнего выступления',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 5),
                    title: 'План',
                    coverUrl: 'assets/2.png',
                    description: 'Главные тезисы',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 40),
                    title: 'Современный подход',
                    coverUrl: 'assets/5.gif',
                    description: 'Практический пример 2D скролла',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 10),
                    title: 'Заключение',
                    coverUrl: 'assets/6.png',
                  ),
                ].toTimestamps().toList(),
              ),
              MobiusSpeech._(
                id: createId(),
                scheduleId: it,
                title: 'За осла и болото',
                speaker: MobiusSpeaker.create(
                  name: 'Shrek',
                  avatarUrl:
                      'https://miro.medium.com/v2/resize:fit:1200/1*LpxLQj3xgPwMaUjaM3NW7g.jpeg',
                ),
                duration: MobiusSpeechDuration.create(
                  const Duration(hours: 1),
                ),
                start: MobiusSpeechStart.create(const Duration(minutes: 75)),
                timestamps: const [
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 5),
                    title: 'Классная жизнь',
                    coverUrl:
                        'https://i.ytimg.com/vi/zeROGNnOkmg/maxresdefault.jpg?sqp=-oaymwEmCIAKENAF8quKqQMa8AEB-AH-CYAC0AWKAgwIABABGFcgZSg8MA8=&rs=AOn4CLAgk4K31qha8dfTEGCq-3jxu599KQ',
                  ),
                  MobiusSpeechTimestampDetails(
                      duration: Duration(minutes: 8),
                      title: 'Осёл',
                      description: 'Да, это он',
                      coverUrl:
                          'https://0d314c86-f76b-45cc-874e-45816116a667.selcdn.net/07885433-5018-4754-a346-db0f4ec5036a.jpg'),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 10),
                    title: 'Великаны как луковица',
                    coverUrl:
                        'https://i.ytimg.com/vi/_BxMOmneZgk/maxresdefault.jpg',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 10),
                    title: 'Спасаем принцессу',
                    coverUrl:
                        'https://flomaster.top/o/uploads/posts/2024-02/1708694100_flomaster-top-p-shrek-v-shleme-krasivo-narisovannie-5.jpg',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 5),
                    title: 'Рефлексия',
                    description: 'Грустно, плак-плак',
                    coverUrl:
                        'https://memi.klev.club/uploads/posts/2024-06/memi-klev-club-bjaj-p-memi-grustnii-shrek-6.jpg',
                  ),
                  MobiusSpeechTimestampDetails(
                    duration: Duration(minutes: 15),
                    title: 'И жили они долго и счастливо',
                    description: 'Не грустно, не плак-плак',
                    coverUrl:
                        'https://cdn.7days.ru/pic/647/993701/1520439/86.jpg',
                  ),
                ].toTimestamps().toList(),
              ),
            ],
            date: DateTime(2025, 3, 3),
          ),
        ),
      ],
    );
  }

  Mobius addSchedule(DateTime date) {
    if (date.year < DateTime.now().year) {
      throw Exception('Date $date is in the past');
    }

    final isDateReserved = schedules.any(
      (s) => s.overlaps(date),
    );

    if (isDateReserved) {
      throw Exception('Date $date is already reserved');
    }

    final schedule = MobiusSchedule._(
      id: createId(),
      speeches: const [],
      date: date,
    );

    return Mobius._(schedules: [...schedules, schedule]);
  }

  Mobius addSpeech({
    required String scheduleId,
    required String title,
    required MobiusSpeaker speaker,
    required MobiusSpeechDuration duration,
    Iterable<MobiusSpeechTimestampDetails> timestamps = const [],
  }) {
    final target = schedules.firstWhereOrNull((s) => s.id == scheduleId);

    if (target == null) {
      throw Exception('Schedule $scheduleId was not added');
    }

    final updated = target._addSpeech(
      title: title,
      speaker: speaker,
      duration: duration,
      timestampDetails: timestamps,
    );

    return Mobius._(
      schedules:
          schedules.map((s) => s.id == scheduleId ? updated : s).toList(),
    );
  }

  @override
  List<Object?> get props => [
        schedules,
      ];
}
