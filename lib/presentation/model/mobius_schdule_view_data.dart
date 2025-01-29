import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:mobius_2d_scroll/domain/model/mobius.dart';
import 'package:mobius_2d_scroll/presentation/model/mobius_schedule_view_row.dart';
import 'package:mobius_2d_scroll/util.dart';

class MobiusScheduleViewData with EquatableMixin {
  final Iterable<MobiusScheduleViewRow> rows;
  final double width;
  final String? selectedSpeechId;
  final double rowSpacing;
  final int maxCellsCount;

  const MobiusScheduleViewData._({
    required this.rows,
    required this.width,
    required this.selectedSpeechId,
    required this.maxCellsCount,
    this.rowSpacing = 0,
  });

  factory MobiusScheduleViewData({
    required Iterable<MobiusSchedule> schedules,
    required double screenWidth,
    required double scale,
    String? selectedSpeechId,
    double rowSpacing = 0,
  }) {
    var width = 0.0;
    var maxCellsCount = 0;
    final rows = <MobiusScheduleViewRow>[];
    for (final schedule in schedules) {
      final row = MobiusScheduleViewRow(
        scale: scale,
        schedule: schedule,
        screenWidth: screenWidth,
        selectedSpeechId: selectedSpeechId,
      );
      rows.add(row);
      width = max(
        width,
        // Every speech has reserved hour time
        (MobiusSpeech.reservedDuration * row.cells.length).toWidth(
          screenWidth: screenWidth,
          scale: scale,
        ),
      );
      maxCellsCount = max(maxCellsCount, row.cells.length);
    }
    return MobiusScheduleViewData._(
      rows: rows,
      width: width,
      selectedSpeechId: selectedSpeechId,
      rowSpacing: rowSpacing,
      maxCellsCount: maxCellsCount,
    );
  }

  @override
  List<Object?> get props => [
        rows,
        width,
        selectedSpeechId,
        rowSpacing,
      ];
}
