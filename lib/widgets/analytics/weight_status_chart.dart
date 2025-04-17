import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutria/models/nutrition_data.dart';

class WeightStatusChart extends StatelessWidget {
  final List<NutritionData> nutritionData;
  
  const WeightStatusChart({
    super.key,
    required this.nutritionData,
  });

  @override
  Widget build(BuildContext context) {
    final hasData = nutritionData.any((data) => data.gotRecords);
    
    if (!hasData) {
      return const Center(
        child: Text(
          'No weight status data available',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
    }
    
    return AspectRatio(
      aspectRatio: 1.6,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 16.0),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 1,
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
                // axisNameWidget: const Text(
                //   'Weight Change (%)',
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toStringAsFixed(1),
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
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d)),
            ),
            minY: _getMinY(),
            maxY: _getMaxY(),
            lineBarsData: [
              LineChartBarData(
                spots: _getSpots(),
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    Color dotColor = Colors.blue;
                    
                    // Change dot color based on weight status
                    // if (spot.y < 0) {
                    //   // Weight loss
                    //   dotColor = Colors.green;
                    // } else if (spot.y > 0) {
                    //   // Weight gain
                    //   dotColor = Colors.red;
                    // }
                    
                    return FlDotCirclePainter(
                      radius: 6,
                      color: dotColor,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.1),
                ),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (index) => Colors.blue,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((LineBarSpot spot) {
                    final data = nutritionData[spot.x.toInt()];
                    final sign = spot.y >= 0 ? '+' : '';
                    
                    return LineTooltipItem(
                      '${data.tag}\n$sign${spot.y.toStringAsFixed(2)}%',
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getMinY() {
    double minY = 0;
    for (var data in nutritionData) {
      if (data.gotRecords && data.weightStatus < minY) {
        minY = data.weightStatus;
      }
    }
    // Add some padding and round to nearest whole number
    return (minY * 1.2).floorToDouble();
  }

  double _getMaxY() {
    double maxY = 0;
    for (var data in nutritionData) {
      if (data.gotRecords && data.weightStatus > maxY) {
        maxY = data.weightStatus;
      }
    }
    // Add some padding and round to nearest whole number
    return (maxY * 1.2).ceilToDouble();
  }

  List<FlSpot> _getSpots() {
    List<FlSpot> spots = [];
    
    for (int i = 0; i < nutritionData.length; i++) {
      final data = nutritionData[i];
      if (data.gotRecords) {
        spots.add(FlSpot(i.toDouble(), data.weightStatus));
      }
    }
    
    return spots;
  }
}