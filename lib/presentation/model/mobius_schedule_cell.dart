import 'package:equatable/equatable.dart';
import 'package:mobius_2d_scroll/domain/model/mobius.dart';
import 'package:mobius_2d_scroll/util.dart';

class MobiusScheduleViewCell with EquatableMixin {
  final double startsAt;
  final double width;
  final double expandedHeight;
  final double collapsedHeight;
  final String speechId;
  final bool isSelected;

  const MobiusScheduleViewCell._({
    required this.startsAt,
    required this.width,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.speechId,
    required this.isSelected,
  });

  factory MobiusScheduleViewCell({
    required MobiusSpeech speech,
    required double screenWidth,
    required double scale,
    required bool isSelected,
  }) {
    return MobiusScheduleViewCell._(
      startsAt: speech.start.toWidth(screenWidth: screenWidth, scale: scale),
      width: speech.duration.toWidth(screenWidth: screenWidth, scale: scale),
      speechId: speech.id,
      isSelected: isSelected,
      collapsedHeight: 100,
      expandedHeight: 250,
    );
  }

  @override
  List<Object?> get props => [
        startsAt,
        width,
        speechId,
        isSelected,
        expandedHeight,
        collapsedHeight,
      ];
}
