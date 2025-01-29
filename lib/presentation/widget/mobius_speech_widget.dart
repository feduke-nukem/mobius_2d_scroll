import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobius_2d_scroll/application/bloc/mobius_bloc.dart';
import 'package:mobius_2d_scroll/presentation/widget/mobius_cell_provider.dart';
import 'package:mobius_2d_scroll/presentation/widget/mobius_schedule_view.dart';
import 'package:mobius_2d_scroll/presentation/widget/mobius_schedule_view_child_viewport.dart';
import 'package:mobius_2d_scroll/util.dart';

class MobiusSpeechWidget extends StatefulWidget {
  const MobiusSpeechWidget({super.key});

  @override
  State<MobiusSpeechWidget> createState() => _MobiusSpeechWidgetState();
}

class _MobiusSpeechWidgetState extends State<MobiusSpeechWidget> {
  @override
  Widget build(BuildContext context) {
    final speechId = context.select((MobiusCellData data) => data.speech.id);

    return LayoutBuilder(
      key: ValueKey(speechId),
      builder: (context, constraints) {
        final isSelected = context.select(
            (MobiusBloc bloc) => bloc.state.selectedSpeechId == speechId);

        return SizedBox(
          key: ValueKey(speechId),
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Center(
            child: SizedBox(
              height: constraints.minHeight,
              child: Material(
                color: const Color.fromARGB(255, 40, 96, 42),
                child: InkWell(
                  onTap: isSelected ? null : _onTap,
                  child: Stack(
                    children: [
                      Padding(
                        padding: isSelected
                            ? const EdgeInsets.symmetric(vertical: 30)
                            : EdgeInsets.zero,
                        child: const _TimestampsWidget(),
                      ),
                      if (isSelected)
                        const Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: _OuterBorderPainter(
                                color: Colors.purpleAccent,
                                thickness: 30,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTap() {
    final id = context.read<MobiusCellData>().speech.id;
    final bloc = context.read<MobiusBloc>();

    bloc.add(
      bloc.state.selectedSpeechId == id
          ? const MobiusSelectionChanged(speechId: null)
          : MobiusSelectionChanged(speechId: id),
    );
  }
}

class _TimestampsWidget extends StatefulWidget {
  const _TimestampsWidget();

  @override
  State<_TimestampsWidget> createState() => __TimestampsWidgetState();
}

class __TimestampsWidgetState extends State<_TimestampsWidget> {
  late final ViewportOffset _offset;

  @override
  void initState() {
    super.initState();

    _offset =
        ViewportOffset.fixed(context.read<MobiusCellData>().horizontalOffset);
  }

  @override
  void dispose() {
    _offset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final row = context.select((MobiusCellData data) => data.row);
    final column = context.select((MobiusCellData data) => data.column);

    return MobiusScheduleViewChildViewport(
      offset: _offset,
      delegate: (data) {
        final vicinity = MobiusScheduleView.of(context)
            .storage
            .get(row: row, column: column);

        return DelegatedViewportData(
          scrollOffset: vicinity.horizontalOffset,
          layoutOffset: vicinity.horizontalOffset,
          remainingCacheExtent: vicinity.visibleWidth,
          remainingPaintExtent: vicinity.visibleWidth,
        );
      },
      cacheExtent: 0,
      axisDirection: AxisDirection.right,
      clipBehavior: Clip.hardEdge,
      slivers: [
        Builder(builder: (context) {
          final (speechId, timestamps) = context.select(
            (MobiusCellData data) => (data.speech.id, data.speech.timestamps),
          );
          final (isSelected, scale) = context.select(
            (MobiusBloc bloc) =>
                (bloc.state.selectedSpeechId == speechId, bloc.state.scale),
          );

          return SliverVariedExtentList.builder(
            itemExtentBuilder: (index, dimensions) =>
                timestamps.elementAt(index).details.duration.toWidth(
                      screenWidth: MediaQuery.sizeOf(context).width,
                      scale: scale,
                    ),
            itemCount: timestamps.length,
            findChildIndexCallback: (key) => key is ValueKey ? key.value : null,
            itemBuilder: (_, index) {
              final timestamp = timestamps.elementAt(index);
              final startsAt = timestamp.startsAt;
              final coverUrl = timestamp.details.coverUrl;
              final ImageProvider image = (coverUrl.contains('assets')
                  ? AssetImage(coverUrl)
                  : CachedNetworkImageProvider(coverUrl));

              return InkWell(
                onTap: !isSelected
                    ? null
                    : () {
                        final description = timestamp.details.description;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(timestamp.details.title),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(image: image),
                                if (description != null)
                                  Text(
                                    description,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        '${startsAt.inMinutes}:${startsAt.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                        timestamp.details.title,
                      ]
                          .map(
                            (text) => Flexible(
                              child: Text(
                                text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}

class _OuterBorderPainter extends CustomPainter {
  final Color color;
  final double thickness;

  const _OuterBorderPainter({
    required this.color,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromLTWH(
      -thickness / 2,
      thickness / 2,
      size.width + thickness,
      size.height - thickness,
    );

    // Draw the outer border
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_OuterBorderPainter oldDelegate) {
    return color != oldDelegate.color || thickness != oldDelegate.thickness;
  }
}
