import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutria/models/nutrition_data.dart';

enum NutritionChartType {
  calories,
  proteins,
  carbs,
  fats
}

class NutritionBarChart extends StatelessWidget {
  final List<NutritionData> nutritionData;
  final NutritionChartType chartType;
  
  const NutritionBarChart({
    super.key,
    required this.nutritionData,
    this.chartType = NutritionChartType.calories,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxValue() * 1.2,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (index) => Colors.blue,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final value = rod.toY;
                  final item = nutritionData[groupIndex];
                  String unit = 'g';
                  if (chartType == NutritionChartType.calories) {
                    unit = 'kcal';
                  }
                  
                  return BarTooltipItem(
                    '${item.tag}\n${value.toStringAsFixed(1)} $unit',
                    const TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < nutritionData.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          nutritionData[index].tag,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    );
                  },
                  reservedSize: 40,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              horizontalInterval: _getMaxValue() / 5,
            ),
            barGroups: _getBarGroups(),
          ),
        ),
      ),
    );
  }

  double _getMaxValue() {
    double maxValue = 0;
    for (var data in nutritionData) {
      final value = _getValue(data);
      if (value > maxValue) {
        maxValue = value;
      }
    }
    // Ensure we always have some height even if all values are 0
    return maxValue > 0 ? maxValue : 100;
  }

  double _getValue(NutritionData data) {
    switch (chartType) {
      case NutritionChartType.calories:
        return data.totalCalories;
      case NutritionChartType.proteins:
        return data.totalProteins;
      case NutritionChartType.carbs:
        return data.totalCarbs;
      case NutritionChartType.fats:
        return data.totalFats;
    }
  }

  List<BarChartGroupData> _getBarGroups() {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < nutritionData.length; i++) {
      final value = _getValue(nutritionData[i]);
      final color = _getBarColor(nutritionData[i].gotRecords);
      
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: value,
              color: color,
              width: 16,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  Color _getBarColor(bool hasRecords) {
    // Get appropriate color based on chart type
    Color baseColor;
    
    switch (chartType) {
      case NutritionChartType.calories:
        baseColor = const Color.fromARGB(255, 11, 64, 107);
        break;
      case NutritionChartType.proteins:
        baseColor = Colors.blue;
        break;
      case NutritionChartType.carbs:
        baseColor = const Color.fromARGB(255, 255, 127, 7);
        break;
      case NutritionChartType.fats:
        baseColor = Colors.green;
        break;
    }
    
    // If no records, use a lighter shade
    return hasRecords ? baseColor : baseColor.withOpacity(0.3);
  }
}