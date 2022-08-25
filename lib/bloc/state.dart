

import 'package:test4/api_response.dart';
import 'package:test4/timming_slots_response.dart';

abstract class BaseState{}

class TimingSlotInitialState extends BaseState{}

class TimingSlotState extends BaseState{
  ApiResponse? apiResponse;
  TimingSlotState({this.apiResponse});
}