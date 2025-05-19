class CalendarData {
  final Map<String, int> submissionMap;

  CalendarData({required this.submissionMap});

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    final parsed = json.map((key, value) => MapEntry(key, int.parse(value.toString())));
    return CalendarData(submissionMap: parsed);
  }
}
