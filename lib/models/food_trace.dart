class FoodTrace {
  final int id;
  final int userId;
  final MacrosData macrosData;
  final FoodImage? foodImage;
  final String status;
  final String createdAt;
  final String updatedAt;

  FoodTrace({
    required this.id,
    required this.userId,
    required this.macrosData,
    this.foodImage,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodTrace.fromJson(Map<String, dynamic> json) {
    return FoodTrace(
      id: json['id'],
      userId: json['userId'],
      macrosData: MacrosData.fromJson(json['macrosData']),
      foodImage: json['foodImage'] != null ? FoodImage.fromJson(json['foodImage']) : null,
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class MacrosData {
  final String id;
  final int userId;
  final String description;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final double servingSize;
  final String status;
  final String createdAt;
  final String updatedAt;

  MacrosData({
    required this.id,
    required this.userId,
    required this.description,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.servingSize,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MacrosData.fromJson(Map<String, dynamic> json) {
    return MacrosData(
      id: json['id'],
      userId: json['userId'],
      description: json['description'],
      calories: json['calories'].toDouble(),
      proteins: json['proteins'].toDouble(),
      carbs: json['carbs'].toDouble(),
      fats: json['fats'].toDouble(),
      servingSize: json['servingSize'].toDouble(),
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class FoodImage {
  final String id;
  final int userId;
  final String fileName;
  final String filePath;
  final String createdAt;
  final String updatedAt;

  FoodImage({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.filePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodImage.fromJson(Map<String, dynamic> json) {
    return FoodImage(
      id: json['id'],
      userId: json['userId'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class FoodData {
  final String description;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final double servingSize;
  String? base64Image;

  FoodData({
    required this.description,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.servingSize,
    this.base64Image,
  });

  factory FoodData.fromJson(Map<String, dynamic> json) {
    return FoodData(
      description: json['description'] ?? '',
      calories: json['calories']?.toDouble() ?? 0.0,
      proteins: json['proteins']?.toDouble() ?? 0.0,
      carbs: json['carbs']?.toDouble() ?? 0.0,
      fats: json['fats']?.toDouble() ?? 0.0,
      servingSize: json['servingSize']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
      'servingSize': servingSize,
    };
  }
}