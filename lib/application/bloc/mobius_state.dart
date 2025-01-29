part of 'mobius_bloc.dart';

class MobiusState with EquatableMixin {
  final Mobius mobius;
  final double scale;
  final String? selectedSpeechId;

  MobiusState({
    required this.mobius,
    required this.scale,
    required this.selectedSpeechId,
  });

  @override
  List<Object?> get props => [
        mobius,
        scale,
        selectedSpeechId,
      ];

  MobiusState copyWith({
    Mobius? mobius,
    double? scale,
    String? Function()? selectedSpeechId,
  }) {
    return MobiusState(
      mobius: mobius ?? this.mobius,
      scale: scale ?? this.scale,
      selectedSpeechId:
          selectedSpeechId != null ? selectedSpeechId() : this.selectedSpeechId,
    );
  }
}
