// lib/widgets/trace/nutrition_tracking_cards.dart
import 'package:flutter/material.dart';
import '../../models/nutrition_goal.dart';
import '../../models/daily_intake.dart';

class NutritionTrackingCards extends StatefulWidget {
  final NutritionGoal nutritionGoal;
  final DailyIntake dailyIntake;

  const NutritionTrackingCards({
    super.key,
    required this.nutritionGoal,
    required this.dailyIntake,
  });

  @override
  State<NutritionTrackingCards> createState() => _NutritionTrackingCardsState();
}

class _NutritionTrackingCardsState extends State<NutritionTrackingCards> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // bool get _hasData {
  //   // Check if there's any nutrition data recorded
  //   return widget.dailyIntake.totalCalories > 0 || 
  //          widget.dailyIntake.totalProteins > 0 || 
  //          widget.dailyIntake.totalCarbs > 0 || 
  //          widget.dailyIntake.totalFats > 0;
  // }

  @override
  Widget build(BuildContext context) {
    // if (!_hasData) {
    //   return _buildNoDataCard();
    // }

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildCaloriesCard(),
              _buildMacrosCard(),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIndicator(0),
            const SizedBox(width: 8),
            _buildIndicator(1),
          ],
        ),
      ],
    );
  }

  // Widget _buildNoDataCard() {
  //   return SizedBox(
  //     height: 180,
  //     child: Card(
  //       elevation: 4,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       child: const Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(Icons.no_meals, size: 48, color: Colors.grey),
  //             SizedBox(height: 16),
  //             Text(
  //               'No nutrition data available',
  //               style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildIndicator(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }

  Widget _buildCaloriesCard() {
    final double caloriePercentage = widget.dailyIntake.totalCalories / widget.nutritionGoal.calories;
    final double clampedPercentage = caloriePercentage.clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: clampedPercentage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: caloriePercentage > 1.0 ? Colors.red : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.dailyIntake.totalCalories.toStringAsFixed(0)} kcal',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Goal: ${widget.nutritionGoal.calories.toStringAsFixed(0)} kcal',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              caloriePercentage > 1.0
                  ? '+${(widget.dailyIntake.totalCalories - widget.nutritionGoal.calories).toStringAsFixed(0)} kcal over goal'
                  : '${(widget.nutritionGoal.calories - widget.dailyIntake.totalCalories).toStringAsFixed(0)} kcal remaining',
              style: TextStyle(
                fontSize: 13,
                color: caloriePercentage > 1.0 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacrosCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildMacroRow(
              label: 'Protein',
              current: widget.dailyIntake.totalProteins,
              goal: widget.nutritionGoal.proteins,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildMacroRow(
              label: 'Carbs',
              current: widget.dailyIntake.totalCarbs,
              goal: widget.nutritionGoal.carbs,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildMacroRow(
              label: 'Fats',
              current: widget.dailyIntake.totalFats,
              goal: widget.nutritionGoal.fats,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroRow({
    required String label,
    required double current,
    required double goal,
    required Color color,
  }) {
    final double percentage = current / goal;
    final double clampedPercentage = percentage.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '${current.toStringAsFixed(1)}g / ${goal.toStringAsFixed(1)}g',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: clampedPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: percentage > 1.0 ? Colors.red : color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}