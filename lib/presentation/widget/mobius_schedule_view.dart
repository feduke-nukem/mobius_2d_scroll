// ignore_for_file: library_private_types_in_public_api

import 'dart:async' show scheduleMicrotask;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobius_2d_scroll/presentation/model/mobius_schedule_cell.dart';
import 'package:mobius_2d_scroll/presentation/model/mobius_schdule_view_data.dart';
import 'package:mobius_2d_scroll/presentation/model/mobius_schedule_view_row.dart';

class MobiusScheduleView extends TwoDimensionalScrollView {
  final MobiusScheduleViewData data;
  final TickerProvider vsync;

  const MobiusScheduleView({
    required TwoDimensionalChildBuilderDelegate delegate,
    required this.data,
    required this.vsync,
    super.horizontalDetails =
        const ScrollableDetails.horizontal(physics: ClampingScrollPhysics()),
    super.verticalDetails =
        const ScrollableDetails.vertical(physics: ClampingScrollPhysics()),
    super.key,
    super.cacheExtent,
  }) : super(delegate: delegate);

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return _Owner(
      child: _Viewport(
        data: data,
        vsync: vsync,
        verticalOffset: verticalOffset,
        verticalAxisDirection: verticalDetails.direction,
        horizontalOffset: horizontalOffset,
        horizontalAxisDirection: horizontalDetails.direction,
        delegate: delegate as TwoDimensionalChildBuilderDelegate,
        mainAxis: mainAxis,
        cacheExtent: cacheExtent,
        clipBehavior: clipBehavior,
      ),
    );
  }

  static _OwnerState of(BuildContext context) {
    return context.getInheritedWidgetOfExactType<_Scope>()!.owner;
  }
}

class MobiusVicinityStorage {
  final _map = <String, MobiusChildVicinity>{};

  MobiusChildVicinity get({
    required int row,
    required int column,
  }) {
    return _map[_createKey(row, column)] ??=
        throw Exception('Cell not found $row $column');
  }

  void _add(MobiusChildVicinity vicinity) {
    _map[_createKey(vicinity.yIndex, vicinity.xIndex)] = vicinity;
  }

  String _createKey(int row, int column) => '$row _ $column';

  void _clear() => _map.clear();
}

class _Scope extends InheritedWidget {
  final _OwnerState owner;

  const _Scope({
    required super.child,
    required this.owner,
  });

  @override
  bool updateShouldNotify(_Scope oldWidget) => owner != oldWidget.owner;
}

class _Owner extends StatefulWidget {
  final Widget child;

  const _Owner({
    required this.child,
  });

  @override
  State<_Owner> createState() => _OwnerState();
}

class _OwnerState extends State<_Owner> {
  final _viewPorts = <RenderViewportBase>[];
  final storage = MobiusVicinityStorage();

  @override
  Widget build(BuildContext context) {
    return _Scope(
      owner: this,
      child: widget.child,
    );
  }

  void attachViewport(RenderViewportBase viewport) => _viewPorts.add(viewport);

  void detachViewport(RenderViewportBase viewport) =>
      _viewPorts.remove(viewport);

  @override
  void dispose() {
    _viewPorts.clear();
    storage._clear();
    super.dispose();
  }
}

class _Viewport extends TwoDimensionalViewport {
  final MobiusScheduleViewData data;
  final TickerProvider vsync;

  const _Viewport({
    required this.data,
    required this.vsync,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required TwoDimensionalChildBuilderDelegate delegate,
    required super.mainAxis,
    super.cacheExtent,
    super.clipBehavior,
  }) : super(delegate: delegate);

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    final owner = MobiusScheduleView.of(context);

    return _RenderViewport(
      data: data,
      vsync: vsync,
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      mainAxis: mainAxis,
      childManager: context as TwoDimensionalChildManager,
      vicinityStorage: owner.storage,
      childViewports: owner._viewPorts,
      cacheExtent: cacheExtent,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderViewport renderObject,
  ) {
    renderObject
      ..data = data
      ..vsync = vsync;
  }
}

class _RenderViewport extends RenderTwoDimensionalViewport {
  final Iterable<RenderViewportBase> _childViewports;
  final MobiusVicinityStorage _vicinityStorage;

  _RenderViewport({
    required MobiusScheduleViewData data,
    required TickerProvider vsync,
    required TwoDimensionalChildBuilderDelegate delegate,
    required Iterable<RenderViewportBase> childViewports,
    required MobiusVicinityStorage vicinityStorage,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
  })  : _data = data,
        _vsync = vsync,
        _childViewports = childViewports,
        _vicinityStorage = vicinityStorage,
        super(delegate: delegate) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: Durations.medium4,
    )..addListener(() {
        if (_lastAnimationControllerValue != _animationController.value) {
          markNeedsLayout();
        }
      });

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
  }

  final _rowTweens = <String, Tween<double>>{};
  final _cellTweens = <String, Tween<double>>{};

  double? _lastAnimationControllerValue;
  late AnimationController _animationController;
  late CurvedAnimation _animation;

  String? _selectedScheduleId;

  MobiusScheduleViewData _data;
  MobiusScheduleViewData get data => _data;
  set data(MobiusScheduleViewData value) {
    if (_data == value) return;

    final withDelegateRebuild = _selectedScheduleId != value.selectedSpeechId;

    _data = value;
    _cleanUpTweens();
    markNeedsLayout(withDelegateRebuild: withDelegateRebuild);
    _selectedScheduleId = _data.selectedSpeechId;
    _animationController.forward(from: 0);
  }

  TickerProvider _vsync;
  TickerProvider get vsync => _vsync;
  set vsync(TickerProvider value) {
    if (_vsync == value) return;

    _vsync = value;
    _animationController.resync(vsync);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    if (_selectedScheduleId != null) {
      _animationController.value = 1;
    }
  }

  @override
  void performLayout() {
    super.performLayout();

    if (_childViewports.isEmpty) return;

    invokeLayoutCallback((_) {
      for (final viewport in _childViewports) {
        viewport.markNeedsLayout();
      }
    });
  }

  @override
  void layoutChildSequence() {
    final horizontalPixels = horizontalOffset.pixels;
    final verticalPixels = verticalOffset.pixels;
    final viewportWidth = viewportDimension.width + cacheExtent;
    final viewportHeight = viewportDimension.height + cacheExtent;
    final rowsCount = _data.rows.length;

    var allRowsHeight = 0.0;
    var totalHeight = 0.0;
    final isAnimationCompleted = _animationController.isCompleted;

    for (var rowIndex = 0; rowIndex < rowsCount; rowIndex++) {
      final row = _data.rows.elementAt(rowIndex);

      final rowHeightTween = _rowTweens[row.scheduleId] ??= Tween(
        begin: row.collapsedHeight,
        end: row.collapsedHeight,
      );

      final rowHeight = rowHeightTween.evaluate(_animation);
      final rowTweenEndHeight =
          row.hasSelectedCell ? row.expandedHeight : row.collapsedHeight;

      final rowStarts =
          rowIndex == 0 ? allRowsHeight : allRowsHeight + _data.rowSpacing;
      final rowEnds = rowStarts + rowHeight;

      final isVisibleVertically = rowStarts < verticalPixels + viewportHeight &&
          rowEnds > verticalPixels;

      totalHeight = math.max(rowEnds, totalHeight);

      if (!isVisibleVertically) {
        allRowsHeight += rowHeight;
        continue;
      }

      for (var cellIndex = 0; cellIndex < row.cells.length; cellIndex++) {
        final cell = row.cells.elementAt(cellIndex);

        final cellHeightTween = _cellTweens[cell.speechId] ??= Tween(
          begin: cell.collapsedHeight,
          end: cell.collapsedHeight,
        );

        final cellTweenEndHeight =
            cell.isSelected ? cell.expandedHeight : cell.collapsedHeight;

        final cellWidth = cell.width;
        final cellStarts = cell.startsAt;
        final cellEnds = cellStarts + cellWidth;

        if (cellStarts > horizontalPixels + viewportWidth) continue;
        if (cellEnds < horizontalPixels) continue;

        final cellHeight = cellHeightTween.evaluate(_animation);

        final cellConstraints = BoxConstraints(
          maxWidth: cellWidth,
          minHeight: cellHeight,
          maxHeight: rowHeight,
        ).normalize();

        final horizontalOffset =
            math.max(horizontalPixels - cellStarts, 0.0).clamp(0.0, cellWidth);

        final visibleWidth =
            (cellWidth - (cellEnds - viewportWidth - horizontalPixels))
                    .clamp(0.0, cellWidth) -
                horizontalOffset;

        final vicinity = MobiusChildVicinity(
          visibleWidth: visibleWidth,
          row: rowIndex,
          column: cellIndex,
          horizontalOffset: horizontalOffset,
        );

        _vicinityStorage._add(vicinity);

        final child = buildOrObtainChildFor(vicinity)!..layout(cellConstraints);

        parentDataOf(child).layoutOffset = Offset(
          cellStarts - horizontalPixels,
          rowStarts - verticalPixels,
        );

        final isCellHeightFinished = cellHeight == cellTweenEndHeight;
        final isRowHeightFinished = rowHeight == rowTweenEndHeight;

        if (isAnimationCompleted) {
          cellHeightTween.begin = cellHeightTween.end = cellTweenEndHeight;
          rowHeightTween.begin = rowHeightTween.end = rowTweenEndHeight;
        } else if (!isCellHeightFinished || !isRowHeightFinished) {
          cellHeightTween
            ..begin = cellHeight
            ..end = cellTweenEndHeight;
          rowHeightTween
            ..begin = rowHeight
            ..end = rowTweenEndHeight;
        }
      }
      allRowsHeight += rowHeight;
    }

    verticalOffset.applyContentDimensions(
      0,
      (totalHeight - viewportDimension.height).clamp(0, double.infinity),
    );

    horizontalOffset.applyContentDimensions(
      0,
      (data.width - viewportDimension.width).clamp(0, double.infinity),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animation.dispose();
    _cleanUpTweens();
    _rowTweens.clear();
    _cellTweens.clear();
    super.dispose();
  }

  void _cleanUpTweens() {
    final currentRows = <String, MobiusScheduleViewRow>{};
    final currentCells = <String, MobiusScheduleViewCell>{};

    for (final row in _data.rows) {
      currentRows[row.scheduleId] = row;
    }

    for (final entry in _rowTweens.entries) {
      final row = currentRows[entry.key];

      if (row == null) {
        scheduleMicrotask(() => _rowTweens.remove(entry.key));

        continue;
      }

      for (final cell in row.cells) {
        currentCells[cell.speechId] = cell;
      }
    }

    for (final entry in _cellTweens.entries) {
      if (currentCells.containsKey(entry.key)) continue;

      scheduleMicrotask(() => _cellTweens.remove(entry.key));
    }
  }
}

class MobiusChildVicinity extends ChildVicinity {
  final double visibleWidth;
  final double horizontalOffset;
  final double innerOffset;

  const MobiusChildVicinity({
    required int row,
    required int column,
    required this.visibleWidth,
    required this.horizontalOffset,
    this.innerOffset = 0,
  }) : super(xIndex: column, yIndex: row);

  int get row => yIndex;
  int get column => xIndex;
}
