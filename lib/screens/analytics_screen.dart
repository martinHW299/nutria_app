import 'package:flutter/material.dart';
import 'package:nutria/models/nutrition_data.dart';
import 'package:nutria/services/analytics_service.dart';
import 'package:nutria/widgets/analytics/nutrition_bar_chart.dart';
import 'package:nutria/widgets/analytics/weight_status_chart.dart';

enum TimePeriod {
  weekly,
  monthly,
}

class AnalyticsScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AnalyticsScreen({super.key, required this.selectedDate});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  List<NutritionData> _nutritionData = [];
  TimePeriod _selectedPeriod = TimePeriod.weekly;
  NutritionChartType _chartType = NutritionChartType.calories;
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _chartType = NutritionChartType.calories;
            break;
          case 1:
            _chartType = NutritionChartType.proteins;
            break;
          case 2:
            _chartType = NutritionChartType.carbs;
            break;
          case 3:
            _chartType = NutritionChartType.fats;
            break;
        }
      });
    }
  }

  @override
  void didUpdateWidget(AnalyticsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data if the selected date changes
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load food traces and nutrition data
      final foodTraceFuture = AnalyticsService.getFoodTraces(date: widget.selectedDate);
      
      final nutritionDataFuture = _selectedPeriod == TimePeriod.weekly 
          ? AnalyticsService.getWeeklyIntake(date: widget.selectedDate)
          : AnalyticsService.getMonthlyIntake(date: widget.selectedDate);
      
      final results = await Future.wait([foodTraceFuture, nutritionDataFuture]);
      
      setState(() {
        //_foodTraces = results[0] as List<FoodTrace>;
        _nutritionData = results[1] as List<NutritionData>;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading analytics data: $e');
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load analytics data: $e')),
        );
      }
    }
  }

  void _toggleTimePeriod() {
    setState(() {
      _selectedPeriod = _selectedPeriod == TimePeriod.weekly 
          ? TimePeriod.monthly 
          : TimePeriod.weekly;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No app bar here since it's provided by the parent HomeScreen
      body: _buildBody(),
      // floatingActionButton: FoodScannerButton(date: widget.selectedDate),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time period selector
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: _toggleTimePeriod,
                    icon: Icon(_selectedPeriod == TimePeriod.weekly 
                        ? Icons.calendar_view_week 
                        : Icons.calendar_month),
                    label: Text(_selectedPeriod == TimePeriod.weekly ? 'Weekly' : 'Monthly'),
                  ),
                ],
              ),
            ),
            
            // Nutrition data tabs and chart
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Calories'),
                        Tab(text: 'Proteins'),
                        Tab(text: 'Carbs'),
                        Tab(text: 'Fats'),
                      ],
                      labelColor: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      height: 240,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: NutritionBarChart(
                          nutritionData: _nutritionData,
                          chartType: _chartType,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Weight status chart
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Weight Status Trends',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      height: 240,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: WeightStatusChart(
                          nutritionData: _nutritionData,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}