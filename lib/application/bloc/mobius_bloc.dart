import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobius_2d_scroll/domain/model/mobius.dart';

part 'mobius_event.dart';
part 'mobius_state.dart';

class MobiusBloc extends Bloc<MobiusEvent, MobiusState> {
  MobiusBloc(Mobius mobius)
      : super(
          MobiusState(
            mobius: mobius,
            scale: 10,
            selectedSpeechId: null,
          ),
        ) {
    on<MobiusEvent>(
      (event, emit) => switch (event) {
        MobiusScaleChanged() => emit(state.copyWith(scale: event.scale)),
        MobiusSelectionChanged() =>
          emit(state.copyWith(selectedSpeechId: () => event.speechId)),
      },
    );
  }
}
