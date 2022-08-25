

import 'package:intl/intl.dart';

class TimeUtils{
  static String convertDateTimeInto12HourFormat(DateTime dateTime) {
    String formattedDate = DateFormat('h:mm a').format(dateTime);
    return formattedDate;
  }
}