import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/food_trace.dart';

class FoodDetailCard extends StatelessWidget {
  final MacrosData macrosData;
  
  const FoodDetailCard({super.key, required this.macrosData});
  
  @override
  Widget build(BuildContext context) {
    // Calculate total macros in grams
    final totalGrams = macrosData.proteins + macrosData.carbs + macrosData.fats;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food description and calorie info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        macrosData.description,
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.orange),
                          const SizedBox(width: 4),
                          Text(
                            '${macrosData.calories.toStringAsFixed(0)} kcal',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Serving size: ${macrosData.servingSize.toStringAsFixed(0)}g'),
                    ],
                  ),
                ),
                
                // Circular macro distribution indicator
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          '${totalGrams.toStringAsFixed(0)} g',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      CustomPaint(
                        size: const Size(80, 80),
                        painter: MacrosPieChart(
                          proteins: macrosData.proteins,
                          carbs: macrosData.carbs,
                          fats: macrosData.fats,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const Divider(height: 24),
            
            // Macros breakdown
            MacrosIndicator(
              label: 'Proteins',
              value: macrosData.proteins,
              total: totalGrams,
              color: Colors.red,
            ),
            const SizedBox(height: 8),
            MacrosIndicator(
              label: 'Carbs',
              value: macrosData.carbs,
              total: totalGrams,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            MacrosIndicator(
              label: 'Fats',
              value: macrosData.fats,
              total: totalGrams,
              color: Colors.amber,
            ),
            
            const SizedBox(height: 16),
            
            // Time info
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM d, h:mm a').format(
                    DateTime.parse(macrosData.createdAt)
                  ),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MacrosIndicator extends StatelessWidget {
  final String label;
  final double value;
  final double total;
  final Color color;
  
  const MacrosIndicator({
    super.key, 
    required this.label, 
    required this.value, 
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate percentage of total calories
    final percentage = total > 0 ? (value / total) : 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(1)} g',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage.clamp(0.0, 1.0),
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
        Text('${(percentage * 100).toStringAsFixed(1)}%'),
      ],
    );
  }
}

// Custom pie chart painter for macros distribution
class MacrosPieChart extends CustomPainter {
  final double proteins;
  final double carbs;
  final double fats;
  
  MacrosPieChart({
    required this.proteins,
    required this.carbs,
    required this.fats,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final total = proteins + carbs + fats;
    if (total <= 0) return;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Define colors for each macro
    const proteinColor = Colors.red;
    const carbColor = Colors.blue;
    const fatColor = Colors.amber;
    
    // Calculate angles
    final proteinAngle = 2 * 3.14159 * (proteins / total);
    final carbAngle = 2 * 3.14159 * (carbs / total);
    final fatAngle = 2 * 3.14159 * (fats / total);
    
    var startAngle = -3.14159 / 2; // Start from the top
    
    // Draw proteins section
    if (proteins > 0) {
      final paint = Paint()
        ..color = proteinColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 5),
        startAngle,
        proteinAngle,
        false,
        paint,
      );
      
      startAngle += proteinAngle;
    }
    
    // Draw carbs section
    if (carbs > 0) {
      final paint = Paint()
        ..color = carbColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 5),
        startAngle,
        carbAngle,
        false,
        paint,
      );
      
      startAngle += carbAngle;
    }
    
    // Draw fats section
    if (fats > 0) {
      final paint = Paint()
        ..color = fatColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 5),
        startAngle,
        fatAngle,
        false,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}