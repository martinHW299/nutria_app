// ignore_for_file: constant_identifier_names

enum Gender { MALE, FEMALE }

enum ActivityLevel { SEDENTARY, LIGHTLY, MODERATE, VERY, SUPER }

enum CaloricAdjustment {
  LOSE_025,
  LOSE_050,
  LOSE_100,
  MAINTAIN,
  GAIN_025,
  GAIN_050,
}

// Helper methods to get Spanish display names
extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.MALE:
        return 'Hombre';
      case Gender.FEMALE:
        return 'Mujer';
    }
  }
}

extension ActivityLevelExtension on ActivityLevel {
  String get displayName {
    switch (this) {
      case ActivityLevel.SEDENTARY:
        return 'Sedentario (poco o ningún ejercicio)';
      case ActivityLevel.LIGHTLY:
        return 'Ligeramente activo (ejercicio ligero 1-3 días/semana)';
      case ActivityLevel.MODERATE:
        return 'Moderadamente activo (ejercicio moderado 3-5 días/semana)';
      case ActivityLevel.VERY:
        return 'Muy activo (ejercicio intenso 6-7 días/semana)';
      case ActivityLevel.SUPER:
        return 'Súper activo (ejercicio muy intenso y trabajo físico)';
    }
  }
}

extension CaloricAdjustmentExtension on CaloricAdjustment {
  String get displayName {
    switch (this) {
      case CaloricAdjustment.LOSE_025:
        return 'Perder 0.25 kg/semana';
      case CaloricAdjustment.LOSE_050:
        return 'Perder 0.5 kg/semana';
      case CaloricAdjustment.LOSE_100:
        return 'Perder 1 kg/semana';
      case CaloricAdjustment.MAINTAIN:
        return 'Mantener peso actual';
      case CaloricAdjustment.GAIN_025:
        return 'Ganar 0.25 kg/semana';
      case CaloricAdjustment.GAIN_050:
        return 'Ganar 0.5 kg/semana';
    }
  }

  String get description {
    switch (this) {
      case CaloricAdjustment.LOSE_025:
        return 'Pérdida de peso gradual y sostenible';
      case CaloricAdjustment.LOSE_050:
        return 'Pérdida de peso moderada';
      case CaloricAdjustment.LOSE_100:
        return 'Pérdida de peso rápida';
      case CaloricAdjustment.MAINTAIN:
        return 'Mantén tu peso estable y busca la recomposición corporal';
      case CaloricAdjustment.GAIN_025:
        return 'Aumento de peso gradual y controlado';
      case CaloricAdjustment.GAIN_050:
        return 'Aumento de peso moderado';
    }
  }
}
