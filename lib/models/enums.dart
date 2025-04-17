// ignore_for_file: constant_identifier_names

enum Gender {
  MALE,
  FEMALE
}

enum ActivityLevel {
  SEDENTARY,
  LIGHTLY,
  MODERATE,
  VERY,
  SUPER
}

enum CaloricAdjustment {
  MAINTAIN,
  LOSS_LIGHT,
  LOSS_MODERATE,
  GAIN_LIGHT,
  GAIN_MODERATE,
  GAIN_AGGRESSIVE,
  GAIN_VERY_AGGRESSIVE
}

// Helper methods to get display names
extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.MALE:
        return 'Male';
      case Gender.FEMALE:
        return 'Female';
    }
  }
}

extension ActivityLevelExtension on ActivityLevel {
  String get displayName {
    switch (this) {
      case ActivityLevel.SEDENTARY:
        return 'Sedentary (little or no exercise)';
      case ActivityLevel.LIGHTLY:
        return 'Lightly active (light exercise 1-3 days/week)';
      case ActivityLevel.MODERATE:
        return 'Moderately active (moderate exercise 3-5 days/week)';
      case ActivityLevel.VERY:
        return 'Very active (hard exercise 6-7 days/week)';
      case ActivityLevel.SUPER:
        return 'Super active (very hard exercise & physical job)';
    }
  }
}

extension CaloricAdjustmentExtension on CaloricAdjustment {
  String get displayName {
    switch (this) {
      case CaloricAdjustment.MAINTAIN:
        return 'Maintain current weight';
      case CaloricAdjustment.LOSS_LIGHT:
        return 'Light weight loss (10% deficit)';
      case CaloricAdjustment.LOSS_MODERATE:
        return 'Moderate weight loss (20% deficit)';
      case CaloricAdjustment.GAIN_LIGHT:
        return 'Light weight gain (10% surplus)';
      case CaloricAdjustment.GAIN_MODERATE:
        return 'Moderate weight gain (15% surplus)';
      case CaloricAdjustment.GAIN_AGGRESSIVE:
        return 'Aggressive weight gain (20% surplus)';
      case CaloricAdjustment.GAIN_VERY_AGGRESSIVE:
        return 'Very aggressive weight gain (25% surplus)';
    }
  }
}