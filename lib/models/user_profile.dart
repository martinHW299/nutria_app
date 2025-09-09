// lib/models/user_profile.dart
class UserProfile {
  final int id;
  final UserCredential userCredential;
  final String userName;
  final String userLastname;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final double weightGoal;
  final double activityLevel;
  final String caloricAdjustment;
  final double bmr;
  final double bmi;
  final double tdee;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.userCredential,
    required this.userName,
    required this.userLastname,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.weightGoal,
    required this.activityLevel,
    required this.caloricAdjustment,
    required this.bmr,
    required this.bmi,
    required this.tdee,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      userCredential: UserCredential.fromJson(json['userCredential']),
      userName: json['userName'],
      userLastname: json['userLastname'],
      age: json['age'],
      gender: json['gender'],
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      weightGoal: json['weightGoal'].toDouble(),
      activityLevel: json['activityLevel'].toDouble(),
      caloricAdjustment: json['caloricAdjustment'],
      bmr: json['bmr'].toDouble(),
      bmi: json['bmi'].toDouble(),
      tdee: json['tdee'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class UserCredential {
  final int id;
  final String email;
  final String name;
  final String lastName;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserCredential({
    required this.id,
    required this.email,
    required this.name,
    required this.lastName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserCredential.fromJson(Map<String, dynamic> json) {
    return UserCredential(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      lastName: json['lastName'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
