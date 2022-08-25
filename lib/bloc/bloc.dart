

import 'package:bloc/bloc.dart';
import 'package:test4/bloc/event.dart';
import 'package:test4/bloc/state.dart';
import 'package:test4/repository.dart';
import 'package:test4/timming_slots_response.dart';

class TimingSlotBloc extends Bloc<BaseEvent,BaseState>{
  TimingSlotBloc(BaseState initialState) : super(initialState){
    on<TimingSlotEvent>(_handleTimingSlot);
  }

  _handleTimingSlot(TimingSlotEvent event,Emitter<BaseState> emit) async{
    final repository=Repository();
    final response=await repository.performFetchApi();
    emit(TimingSlotState(apiResponse: response));
  }

}