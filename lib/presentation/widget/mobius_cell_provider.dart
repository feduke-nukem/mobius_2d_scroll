import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:mobius_2d_scroll/application/bloc/mobius_bloc.dart';
import 'package:mobius_2d_scroll/domain/model/mobius.dart';
import 'package:mobius_2d_scroll/presentation/widget/mobius_schedule_view.dart';
import 'package:provider/provider.dart';

class MobiusCellProvider extends StatelessWidget {
  final MobiusChildVicinity childVicinity;
  final String scheduleId;
  final String speechId;
  final Widget child;

  const MobiusCellProvider({
    required this.childVicinity,
    required this.scheduleId,
    required this.speechId,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSpeech = context.select(
      (MobiusBloc bloc) => bloc.state.mobius.schedules
          .firstWhereOrNull((s) => s.id == scheduleId)
          ?.speeches
          .firstWhereOrNull((s) => s.id == speechId),
    );

    return effectiveSpeech == null
        ? const SizedBox.shrink()
        : Provider.value(
            value: MobiusCellData(
              column: childVicinity.xIndex,
              row: childVicinity.yIndex,
              speech: effectiveSpeech,
              visibleWidth: childVicinity.visibleWidth,
              horizontalOffset: childVicinity.horizontalOffset,
            ),
            child: child,
          );
  }
}

class MobiusCellData with EquatableMixin {
  final double visibleWidth;
  final double horizontalOffset;
  final int row;
  final int column;
  final MobiusSpeech speech;

  MobiusCellData({
    required this.visibleWidth,
    required this.horizontalOffset,
    required this.row,
    required this.column,
    required this.speech,
  });

  @override
  List<Object?> get props => [
        visibleWidth,
        horizontalOffset,
        row,
        column,
        speech,
      ];
}
