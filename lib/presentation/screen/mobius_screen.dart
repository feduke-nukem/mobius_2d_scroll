import 'package:flutter/material.dart';
import 'package:mobius_2d_scroll/application/bloc/mobius_bloc.dart';
import 'package:mobius_2d_scroll/presentation/model/mobius_schdule_view_data.dart';
import 'package:mobius_2d_scroll/presentation/widget/mobius_cell_provider.dart';
import 'package:mobius_2d_scroll/presentation/widget/mobius_schedule_view.dart';
import 'package:mobius_2d_scroll/presentation/widget/mobius_speech_widget.dart';
import 'package:provider/provider.dart';

class MobiusScreen extends StatefulWidget {
  const MobiusScreen({super.key});

  @override
  State<MobiusScreen> createState() => _MobiusScreenState();
}

class _MobiusScreenState extends State<MobiusScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read<MobiusBloc>()
          .add(const MobiusEvent.selectionChanged(speechId: null)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Mobius schedule view')),
        body: Builder(
          builder: (context) => _View(
            mobiusState: context.watch<MobiusBloc>().state,
            screenWidth: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}

class _View extends StatefulWidget {
  final double screenWidth;
  final MobiusState mobiusState;

  const _View({
    required this.mobiusState,
    required this.screenWidth,
  });

  @override
  State<_View> createState() => __ViewState();
}

class __ViewState extends State<_View> with TickerProviderStateMixin {
  late MobiusScheduleViewData _data;
  final _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _data = MobiusScheduleViewData(
      schedules: widget.mobiusState.mobius.schedules,
      screenWidth: widget.screenWidth,
      scale: widget.mobiusState.scale,
      selectedSpeechId: widget.mobiusState.selectedSpeechId,
      rowSpacing: 0,
    );
  }

  @override
  void didUpdateWidget(covariant _View oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.mobiusState != oldWidget.mobiusState ||
        widget.screenWidth != oldWidget.screenWidth) {
      _data = MobiusScheduleViewData(
        schedules: widget.mobiusState.mobius.schedules,
        screenWidth: widget.screenWidth,
        scale: widget.mobiusState.scale,
        selectedSpeechId: widget.mobiusState.selectedSpeechId,
        rowSpacing: _data.rowSpacing,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_data.rows.isEmpty) return const SizedBox.shrink();

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ColoredBox(
            color: Colors.lightGreen.withValues(alpha: 0.5),
            child: SizedBox(
              height: 400,
              width: widget.screenWidth,
              child: ScrollConfiguration(
                behavior: const _MobiusScrollBehavior(),
                child: MobiusScheduleView(
                  cacheExtent: 0,
                  horizontalDetails: ScrollableDetails.horizontal(
                    controller: _horizontalScrollController,
                    physics: const ClampingScrollPhysics(),
                  ),
                  delegate: TwoDimensionalChildBuilderDelegate(
                    maxXIndex: _data.maxCellsCount - 1,
                    maxYIndex: _data.rows.length - 1,
                    builder: (context, vicinity) {
                      vicinity = vicinity as MobiusChildVicinity;

                      final row = _data.rows.elementAtOrNull(vicinity.row);

                      if (row == null) return null;

                      final cell = row.cells.elementAtOrNull(vicinity.column);

                      if (cell == null) return null;

                      return MobiusCellProvider(
                        childVicinity: vicinity,
                        scheduleId: row.scheduleId,
                        speechId: cell.speechId,
                        child: const MobiusSpeechWidget(),
                      );
                    },
                  ),
                  data: _data,
                  vsync: this,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Scale: ${widget.mobiusState.scale}'),
              Slider(
                divisions: 10,
                value: widget.mobiusState.scale,
                min: 5,
                max: 20,
                onChanged: (value) => context.read<MobiusBloc>().add(
                      MobiusEvent.scaleChanged(scale: value),
                    ),
              ),
              Text('Row spacing: ${_data.rowSpacing}'),
              Slider(
                value: _data.rowSpacing,
                min: 0,
                max: 500,
                onChanged: (value) => setState(
                  () => _data = MobiusScheduleViewData(
                    schedules: widget.mobiusState.mobius.schedules,
                    screenWidth: widget.screenWidth,
                    scale: widget.mobiusState.scale,
                    selectedSpeechId: widget.mobiusState.selectedSpeechId,
                    rowSpacing: value,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }
}

class _MobiusScrollBehavior extends ScrollBehavior {
  static const _clampingPhysics =
      ClampingScrollPhysics(parent: RangeMaintainingScrollPhysics());

  const _MobiusScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => _clampingPhysics;
}
