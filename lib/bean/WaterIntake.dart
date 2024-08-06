class WaterIntake {
  final String ml;
  final String time;
  final String date;
  final String target;
  final int timestamp;
  WaterIntake({
    required this.ml,
    required this.time,
    required this.date,
    required this.target,
    required this.timestamp,
  });

  // Factory constructor to create an instance from JSON
  factory WaterIntake.fromJson(Map<String, dynamic> json) {
    return WaterIntake(
      ml: json['ml'],
      time: json['time'],
      date: json['date'],
      target: json['target'],
      timestamp: json['timestamp'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'ml': ml,
      'time': time,
      'date': date,
      'target': target,
      'timestamp': timestamp,
    };
  }
}
