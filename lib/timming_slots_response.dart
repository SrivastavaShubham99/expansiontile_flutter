class TimingSlotsResponse {
  bool? error;
  int? code;
  String? message;
  List<Response>? response;

  TimingSlotsResponse({this.error, this.code, this.message, this.response});

  TimingSlotsResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    code = json['code'];
    message = json['message'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? slotStartTime;
  String? slotEndTime;
  String? slot;
  int? status;

  Response({this.slotStartTime, this.slotEndTime, this.slot, this.status});

  Response.fromJson(Map<String, dynamic> json) {
    slotStartTime = json['slot_start_time'];
    slotEndTime = json['slot_end_time'];
    slot = json['slot'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot_start_time'] = this.slotStartTime;
    data['slot_end_time'] = this.slotEndTime;
    data['slot'] = this.slot;
    data['status'] = this.status;
    return data;
  }
}
