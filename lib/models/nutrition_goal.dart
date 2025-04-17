class NutritionGoal {
  final int id;
  final int userId;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final double weightGoal;
  final DateTime recordAt;
  final DateTime createdAt;

  NutritionGoal({
    required this.id,
    required this.userId,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.weightGoal,
    required this.recordAt,
    required this.createdAt,
  });

  factory NutritionGoal.fromJson(Map<String, dynamic> json) {
    return NutritionGoal(
      id: json['id'],
      userId: json['userId'],
      calories: json['calories'] is int ? json['calories'].toDouble() : json['calories'],
      proteins: json['proteins'] is int ? json['proteins'].toDouble() : json['proteins'],
      carbs: json['carbs'] is int ? json['carbs'].toDouble() : json['carbs'],
      fats: json['fats'] is int ? json['fats'].toDouble() : json['fats'],
      weightGoal: json['weightGoal'] is int ? json['weightGoal'].toDouble() : json['weightGoal'],
      recordAt: DateTime.parse(json['recordAt']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}