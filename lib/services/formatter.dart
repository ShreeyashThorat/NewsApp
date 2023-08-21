import 'package:intl/intl.dart';

class Formatter {
  static String formatDate(String date) {
    String originalDateString = date;
    DateTime originalDate = DateTime.parse(originalDateString).toLocal();
    final dateFormat = DateFormat('MMM d, y');
    return dateFormat.format(originalDate);
  }
}
