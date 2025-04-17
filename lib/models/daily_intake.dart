class DailyIntake {
  final String tag;
  final double totalCalories;
  final double totalProteins;
  final double totalCarbs;
  final double totalFats;
  final double weightStatus;
  final bool gotRecords;
  final DateTime dateInit;
  final DateTime dateEnd;

  DailyIntake({
    required this.tag,
    required this.totalCalories,
    required this.totalProteins,
    required this.totalCarbs,
    required this.totalFats,
    required this.weightStatus,
    required this.gotRecords,
    required this.dateInit,
    required this.dateEnd,
  });

  factory DailyIntake.fromJson(Map<String, dynamic> json) {
    return DailyIntake(
      tag: json['tag'],
      totalCalories: json['totalCalories'] is int ? json['totalCalories'].toDouble() : json['totalCalories'],
      totalProteins: json['totalProteins'] is int ? json['totalProteins'].toDouble() : json['totalProteins'],
      totalCarbs: json['totalCarbs'] is int ? json['totalCarbs'].toDouble() : json['totalCarbs'],
      totalFats: json['totalFats'] is int ? json['totalFats'].toDouble() : json['totalFats'],
      weightStatus: json['weightStatus'] is int ? json['weightStatus'].toDouble() : json['weightStatus'],
      gotRecords: json['gotRecords'],
      dateInit: DateTime.parse(json['dateInit']),
      dateEnd: DateTime.parse(json['dateEnd']),
    );
  }
}