class NutritionData {
  final String tag;
  final double totalCalories;
  final double totalProteins;
  final double totalCarbs;
  final double totalFats;
  final double weightStatus;
  final bool gotRecords;
  final String dateInit;
  final String dateEnd;

  NutritionData({
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

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      tag: json['tag'] ?? '',
      totalCalories: (json['totalCalories'] ?? 0).toDouble(),
      totalProteins: (json['totalProteins'] ?? 0).toDouble(),
      totalCarbs: (json['totalCarbs'] ?? 0).toDouble(),
      totalFats: (json['totalFats'] ?? 0).toDouble(),
      weightStatus: (json['weightStatus'] ?? 0).toDouble(),
      gotRecords: json['gotRecords'] ?? false,
      dateInit: json['dateInit'] is String ? json['dateInit'] : json['dateInit'].toString(),
      dateEnd: json['dateEnd'] is String ? json['dateEnd'] : json['dateEnd'].toString(),
    );
  }
}