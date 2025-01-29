import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:mobius_2d_scroll/domain/model/mobius.dart';
import 'package:mobius_2d_scroll/presentation/model/mobius_schedule_cell.dart';

class MobiusScheduleViewRow with EquatableMixin {
  final String scheduleId;
  final Iterable<MobiusScheduleViewCell> cells;
  final bool hasSelectedCell;
  final double collapsedHeight;
  final double expandedHeight;

  const MobiusScheduleViewRow._({
    required this.cells,
    required this.scheduleId,
    required this.hasSelectedCell,
    required this.collapsedHeight,
    required this.expandedHeight,
  });

  factory MobiusScheduleViewRow({
    required MobiusSchedule schedule,
    required double screenWidth,
    required double scale,
    required String? selectedSpeechId,
  }) {
    var (hasSelectedCell, maxExpandedHeight, maxCollapsedHeight) =
        (false, 0.0, 0.0);

    final cells = <MobiusScheduleViewCell>[];

    for (final speech in schedule.speeches) {
      final isSelected = speech.id == selectedSpeechId;

      if (isSelected) hasSelectedCell = true;

      final cell = MobiusScheduleViewCell(
        speech: speech,
        scale: scale,
        isSelected: isSelected,
        screenWidth: screenWidth,
      );

      cells.add(cell);

      maxExpandedHeight = math.max(maxExpandedHeight, cell.expandedHeight);
      maxCollapsedHeight = math.max(maxCollapsedHeight, cell.collapsedHeight);
    }

    // Z index
    cells.sort((a, _) => a.speechId == selectedSpeechId ? 1 : 0);

    return MobiusScheduleViewRow._(
      cells: cells,
      scheduleId: schedule.id,
      hasSelectedCell: hasSelectedCell,
      collapsedHeight: maxCollapsedHeight,
      expandedHeight: maxExpandedHeight,
    );
  }

  @override
  List<Object?> get props => [
        cells,
        scheduleId,
        hasSelectedCell,
        collapsedHeight,
        expandedHeight,
      ];
}
