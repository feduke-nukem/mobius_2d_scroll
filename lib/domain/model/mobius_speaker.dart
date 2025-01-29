import 'package:equatable/equatable.dart';
import 'package:mobius_2d_scroll/util.dart' show createId;

class MobiusSpeaker with EquatableMixin {
  final String id;
  final String name;
  final String avatarUrl;

  const MobiusSpeaker._({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  factory MobiusSpeaker.create({
    required String name,
    required String avatarUrl,
  }) {
    return MobiusSpeaker._(
      id: createId(),
      name: name,
      avatarUrl: avatarUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
      ];
}
