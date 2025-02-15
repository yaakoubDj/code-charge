class GbsystemFormatDate {
  String fileDateFormat({required DateTime date}) {
    return "${date.day}-${date.month}-${date.year}";
  }
}
