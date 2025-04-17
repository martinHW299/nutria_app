import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutria/models/food_trace.dart';
import 'package:nutria/services/image_processing_service.dart';
import 'package:nutria/utils/event_bus.dart';

class FoodScannerButton extends StatelessWidget {
  final DateTime? date;

  const FoodScannerButton({super.key, required this.date});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? photo = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (photo == null) return;

      final Uint8List bytes = await photo.readAsBytes();
      String base64Image = base64Encode(bytes).replaceAll('\n', '').replaceAll('\r', '').trim();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing image...')),
      );

      final foodData = await ImageProcessingService.processImage(base64Image);

      if (foodData != null) {
        _showFoodDataDialog(context, foodData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to process food image')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: \${e.toString()}')),
      );
    }
  }

  void _showSourceSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(context, ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  void _showFoodDataDialog(BuildContext context, FoodData foodData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(child: Text(foodData.description)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Calories: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('\${foodData.calories} Kcal'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Proteins: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('\${foodData.proteins} g'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Carbs: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('\${foodData.carbs} g'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fats: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('\${foodData.fats} g'),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Serving Size: ', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('\${foodData.servingSize} g'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final success = await ImageProcessingService.saveFoodData(foodData, date: date);
                Navigator.of(context).pop();

                if (success) {
                  EventBus().emitFoodAdded();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Food added to your diary')),
                  );

                  if (Navigator.canPop(context)) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to save food data')),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showSourceSelection(context),
      tooltip: 'Add Food',
      child: const Icon(Icons.camera_alt),
    );
  }
}
