import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mobius_2d_scroll/presentation/widget/mobius_schedule_view.dart';

typedef LayoutChildSequenceDelegate = DelegatedViewportData Function(
  ChildViewportData data,
);

class MobiusScheduleViewChildViewport extends Viewport {
  final LayoutChildSequenceDelegate delegate;

  MobiusScheduleViewChildViewport({
    required super.offset,
    required this.delegate,
    super.slivers,
    super.cacheExtent,
    super.clipBehavior,
    super.key,
    super.axisDirection,
  });

  @override
  RenderViewport createRenderObject(BuildContext context) {
    late final _RenderViewport viewport;
    final owner = MobiusScheduleView.of(context);

    viewport = _RenderViewport(
      delegate: delegate,
      axisDirection: axisDirection,
      crossAxisDirection: crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      offset: offset,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      onDispose: () => owner.detachViewport(viewport),
    );

    owner.attachViewport(viewport);

    return viewport;
  }
}

class _RenderViewport extends RenderViewport {
  LayoutChildSequenceDelegate delegate;
  VoidCallback onDispose;

  _RenderViewport({
    required super.crossAxisDirection,
    required super.offset,
    required this.delegate,
    required this.onDispose,
    super.axisDirection,
    super.cacheExtent,
    super.clipBehavior,
  });

  @override
  double layoutChildSequence({
    required RenderSliver? child,
    required double scrollOffset,
    required double overlap,
    required double layoutOffset,
    required double remainingPaintExtent,
    required double mainAxisExtent,
    required double crossAxisExtent,
    required GrowthDirection growthDirection,
    required RenderSliver? Function(RenderSliver child) advance,
    required double remainingCacheExtent,
    required double cacheOrigin,
  }) {
    final data = delegate(
      ChildViewportData(
        scrollOffset: scrollOffset,
        overlap: overlap,
        layoutOffset: layoutOffset,
        remainingPaintExtent: remainingPaintExtent,
        mainAxisExtent: mainAxisExtent,
        crossAxisExtent: crossAxisExtent,
        growthDirection: growthDirection,
        remainingCacheExtent: remainingCacheExtent,
        cacheOrigin: cacheOrigin,
      ),
    );

    return super.layoutChildSequence(
      child: child,
      scrollOffset: data.scrollOffset ?? scrollOffset,
      overlap: data.overlap ?? overlap,
      layoutOffset: data.layoutOffset ?? layoutOffset,
      remainingPaintExtent: data.remainingPaintExtent ?? remainingPaintExtent,
      mainAxisExtent: data.mainAxisExtent ?? mainAxisExtent,
      crossAxisExtent: data.crossAxisExtent ?? crossAxisExtent,
      growthDirection: data.growthDirection ?? growthDirection,
      advance: advance,
      remainingCacheExtent: data.remainingCacheExtent ?? remainingCacheExtent,
      cacheOrigin: data.cacheOrigin ?? cacheOrigin,
    );
  }

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }
}

class DelegatedViewportData {
  final double? scrollOffset;
  final double? overlap;
  final double? layoutOffset;
  final double? remainingPaintExtent;
  final double? mainAxisExtent;
  final double? crossAxisExtent;
  final GrowthDirection? growthDirection;
  final double? remainingCacheExtent;
  final double? cacheOrigin;

  const DelegatedViewportData({
    this.scrollOffset,
    this.overlap,
    this.layoutOffset,
    this.remainingPaintExtent,
    this.mainAxisExtent,
    this.crossAxisExtent,
    this.growthDirection,
    this.remainingCacheExtent,
    this.cacheOrigin,
  });
}

class ChildViewportData {
  final double scrollOffset;
  final double overlap;
  final double layoutOffset;
  final double remainingPaintExtent;
  final double mainAxisExtent;
  final double crossAxisExtent;
  final GrowthDirection growthDirection;
  final double remainingCacheExtent;
  final double cacheOrigin;

  const ChildViewportData({
    required this.scrollOffset,
    required this.overlap,
    required this.layoutOffset,
    required this.remainingPaintExtent,
    required this.mainAxisExtent,
    required this.crossAxisExtent,
    required this.growthDirection,
    required this.remainingCacheExtent,
    required this.cacheOrigin,
  });
}
