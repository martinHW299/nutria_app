import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:nutria/models/nutrition_goal.dart';
import 'package:nutria/models/daily_intake.dart';
import 'package:nutria/services/nutrition_service.dart';
import 'package:nutria/utils/event_bus.dart';
import 'package:nutria/utils/date_helper.dart';
import 'package:nutria/widgets/trace/nutrition_tracking_cards.dart';
import 'package:nutria/widgets/trace/food_detail_card.dart';
import '../models/food_trace.dart';
import '../services/image_processing_service.dart';

class TraceScreen extends StatefulWidget {
  final DateTime selectedDate;

  const TraceScreen({super.key, required this.selectedDate});

  @override
  State<TraceScreen> createState() => _TraceScreenState();
}

class _TraceScreenState extends State<TraceScreen> {
  bool _isLoading = true;
  List<FoodTrace> _foodTraces = [];
  NutritionGoal? _nutritionGoal;
  DailyIntake? _dailyIntake;
  bool _isLoadingNutrition = true;

  late StreamSubscription _foodAddedSubscription;

  @override
  void initState() {
    super.initState();
    _loadData();

    _foodAddedSubscription = EventBus().onFoodAdded.listen((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _foodAddedSubscription.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(TraceScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data if the selected date changes
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _isLoadingNutrition = true;
    });

    _loadFoodTraces();
    _loadNutritionData();
  }

  Future<void> _loadFoodTraces() async {
    try {
      final traces = await ImageProcessingService.getFoodTraces(
        date: widget.selectedDate,
      );

      setState(() {
        _foodTraces = traces;
        _isLoading = false;
      });
      // print('_foodTraces: ${_foodTraces.map((trace) => trace.id).join(', ')}');
    } catch (e) {
      // print('Error loading food traces: $e');
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar los datos de comida: $e')),
        );
      }
    }
  }

  Future<void> _loadNutritionData() async {
    try {
      final goal = await NutritionService.getNutritionGoal(
        date: widget.selectedDate,
      );
      final intake = await NutritionService.getDailyIntake(
        date: widget.selectedDate,
      );

      setState(() {
        _nutritionGoal = goal;
        _dailyIntake = intake;
        _isLoadingNutrition = false;
      });
    } catch (e) {
      // print('Error loading nutrition data: $e');
      setState(() {
        _isLoadingNutrition = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar los datos nutricionales: $e'),
          ),
        );
      }
    }
  }

  Future<void> _createNutritionGoal() async {
    try {
      setState(() {
        _isLoadingNutrition = true;
      });

      // Call the service to set default goal
      final success = await NutritionService.setNutritionGoal(
        date: widget.selectedDate,
      );

      if (success) {
        // Reload nutrition data after creating the goal
        await _loadNutritionData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Meta nutricional creada exitosamente!'),
            ),
          );
        }
      } else {
        setState(() {
          _isLoadingNutrition = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al crear la meta nutricional')),
          );
        }
      }
    } catch (e) {
      // print('Error creating nutrition goal: $e');
      setState(() {
        _isLoadingNutrition = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la meta nutricional: $e')),
        );
      }
    }
  }

  Future<void> _deleteFoodTrace(int traceId) async {
    try {
      // Make HTTP request to delete the food trace
      final response = await NutritionService.deleteFoodRecord(id: traceId);

      if (response) {
        // Remove the food trace from the list
        setState(() {
          _foodTraces.removeWhere((trace) => trace.id == traceId);
        });

        // Update the nutrition data after deletion
        _loadNutritionData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro de comida eliminado exitosamente'),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error al eliminar el registro de comida: $traceId',
              ),
            ),
          );
        }
      }
    } catch (e) {
      // print('Error deleting food trace: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar el registro de comida: $e'),
          ),
        );
      }
    }
  }

  void _showFoodDetailDialog(FoodTrace trace) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  FoodDetailCard(macrosData: trace.macrosData),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Nutrition tracking cards
            _buildNutritionTrackingSection(),

            // Food traces list
            _buildFoodTracesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionTrackingSection() {
    if (_isLoadingNutrition) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_nutritionGoal == null || _dailyIntake == null) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 12,
          right: 12,
          bottom: 16,
        ),
        child: SizedBox(
          height: 180,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.food_bank_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay metas que alcanzar hoy',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _createNutritionGoal(),
                    child: const Text('Establecer Meta Nutricional'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 16),
      child: NutritionTrackingCards(
        nutritionGoal: _nutritionGoal!,
        dailyIntake: _dailyIntake!,
      ),
    );
  }

  Widget _buildFoodTracesList() {
    if (_isLoading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_foodTraces.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.no_food, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'No se encontraron registros de comida para ${DateHelper.formatLongDate(widget.selectedDate)}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadFoodTraces,
                icon: const Icon(Icons.refresh),
                label: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _foodTraces.length,
      itemBuilder: (context, index) {
        final trace = _foodTraces[index];
        return Dismissible(
          key: Key(trace.id.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            // Show confirmation dialog
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Confirmar"),
                  content: const Text(
                    "¿Estás seguro de que quieres eliminar este registro de comida?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("CANCELAR"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text("ELIMINAR"),
                    ),
                  ],
                );
              },
            );
          },
          onDismissed: (direction) {
            _deleteFoodTrace(trace.id);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(trace.macrosData.description),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${trace.macrosData.calories.toStringAsFixed(0)} kcal',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateHelper.formatShortDateTime(
                          DateTime.parse(trace.macrosData.createdAt),
                        ),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showFoodDetailDialog(trace),
            ),
          ),
        );
      },
    );
  }
}
