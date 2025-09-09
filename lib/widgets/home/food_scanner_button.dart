import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutria/models/food_trace.dart';
import 'package:nutria/services/image_processing_service.dart';
import 'package:nutria/utils/event_bus.dart';

class FoodScannerButton extends StatefulWidget {
  final DateTime? date;
  final Function(String message) onShowLoading;
  final Function() onHideLoading;

  const FoodScannerButton({
    super.key,
    required this.date,
    required this.onShowLoading,
    required this.onHideLoading,
  });

  @override
  State<FoodScannerButton> createState() => _FoodScannerButtonState();
}

class _FoodScannerButtonState extends State<FoodScannerButton> {
  ScaffoldMessengerState? _scaffoldMessenger;
  NavigatorState? _navigator;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      _scaffoldMessenger = ScaffoldMessenger.of(context);
      _navigator = Navigator.of(context);
    } catch (e) {
      // Handle case where ancestors might not be available
      _scaffoldMessenger = null;
      _navigator = null;
    }
  }

  void _showMessage(String message, {Color? backgroundColor}) {
    if (mounted && _scaffoldMessenger != null && _scaffoldMessenger!.mounted) {
      _scaffoldMessenger!.showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor),
      );
    }
  }

  void _showLoadingOverlay(String message) {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
      widget.onShowLoading(message);
    }
  }

  void _hideLoadingOverlay() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      widget.onHideLoading();
    }
  }

  void _navigateToHome() {
    if (mounted && _navigator != null && _navigator!.mounted) {
      _navigator!.pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? photo = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (photo == null || !mounted) return;

      final Uint8List bytes = await photo.readAsBytes();
      String base64Image =
          base64Encode(bytes).replaceAll('\n', '').replaceAll('\r', '').trim();

      if (!mounted) return;

      _showServingSizeDialog(context, base64Image);
    } catch (e) {
      _showMessage('Error: ${e.toString()}', backgroundColor: Colors.red);
    }
  }

  void _showSourceSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext sheetContext) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar una foto'),
              onTap: () {
                Navigator.pop(sheetContext);
                if (mounted) {
                  _pickImage(context, ImageSource.camera);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de la galería'),
              onTap: () {
                Navigator.pop(sheetContext);
                if (mounted) {
                  _pickImage(context, ImageSource.gallery);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showServingSizeDialog(BuildContext context, String base64Image) {
    final TextEditingController servingSizeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Tamaño de porción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¿Cuántos gramos estimas que pesa tu comida?',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Este campo es opcional. Si no estás seguro, puedes dejarlo vacío y la app calculará automáticamente.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: servingSizeController,
                decoration: const InputDecoration(
                  labelText: 'Peso estimado (gramos)',
                  hintText: 'Ej: 150',
                  prefixIcon: Icon(Icons.scale),
                  suffixText: 'g',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (mounted) {
                  _processImageWithServingSize(base64Image, null);
                }
              },
              child: const Text('Continuar sin peso'),
            ),
            ElevatedButton(
              onPressed: () {
                final servingSize = double.tryParse(
                  servingSizeController.text.trim(),
                );
                Navigator.of(dialogContext).pop();
                if (mounted) {
                  _processImageWithServingSize(base64Image, servingSize);
                }
              },
              child: const Text('Analizar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _processImageWithServingSize(
    String base64Image,
    double? servingSize,
  ) async {
    if (!mounted) return;

    // Show different messages based on whether serving size is provided
    final message =
        servingSize != null && servingSize > 0
            ? 'Consultando a Gemini 2.5 Pro'
            : 'Consultando GPT-4 Mini y Gemini 2.5 Pro';

    _showLoadingOverlay(message);

    try {
      final foodData = await ImageProcessingService.processImage(
        base64Image,
        userServingSize: servingSize,
      );

      if (!mounted) return;

      _hideLoadingOverlay();

      if (foodData != null) {
        _showFoodDataDialog(foodData, servingSize);
      } else {
        _showMessage(
          'Error al procesar la imagen de comida',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      if (!mounted) return;

      _hideLoadingOverlay();
      _showMessage(
        'Error al analizar: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    }
  }

  void _showFoodDataDialog(FoodData foodData, double? userServingSize) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Resultados'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (userServingSize != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Basado en tu estimación: ${userServingSize.toStringAsFixed(0)}g',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descripción: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Text(foodData.description)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Calorías: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${foodData.calories.toStringAsFixed(1)} Kcal'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Proteínas: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${foodData.proteins.toStringAsFixed(1)} g'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Carbohidratos: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${foodData.carbs.toStringAsFixed(1)} g'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Grasas: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${foodData.fats.toStringAsFixed(1)} g'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tamaño de porción: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('${foodData.servingSize.toStringAsFixed(1)} g'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _saveFoodData(foodData);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text(
                'Confirmar y Guardar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveFoodData(FoodData foodData) async {
    if (!mounted) return;

    _showLoadingOverlay('Guardando información nutricional');

    try {
      final success = await ImageProcessingService.saveFoodData(
        foodData,
        date: widget.date,
      );

      if (!mounted) return;

      _hideLoadingOverlay();

      if (success) {
        EventBus().emitFoodAdded();
        _showMessage(
          'Comida agregada a tu diario',
          backgroundColor: Colors.green,
        );

        // Small delay to show the success message before navigating
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          _navigateToHome();
        }
      } else {
        _showMessage(
          'Error al guardar la información de la comida',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      if (mounted) {
        _hideLoadingOverlay();
        _showMessage(
          'Error al guardar: ${e.toString()}',
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _isLoading ? null : () => _showSourceSelection(context),
      tooltip: 'Agregar comida',
      child: const Icon(Icons.camera_alt),
    );
  }
}
