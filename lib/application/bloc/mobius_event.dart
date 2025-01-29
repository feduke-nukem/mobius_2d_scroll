part of 'mobius_bloc.dart';

sealed class MobiusEvent with EquatableMixin {
  const MobiusEvent();

  const factory MobiusEvent.scaleChanged({required double scale}) =
      MobiusScaleChanged;

  const factory MobiusEvent.selectionChanged({required String? speechId}) =
      MobiusSelectionChanged;
}

final class MobiusScaleChanged extends MobiusEvent {
  final double scale;

  const MobiusScaleChanged({required this.scale});

  @override
  List<Object?> get props => [scale];
}

final class MobiusSelectionChanged extends MobiusEvent with EquatableMixin {
  final String? speechId;

  const MobiusSelectionChanged({required this.speechId});

  @override
  List<Object?> get props => [speechId];
}
