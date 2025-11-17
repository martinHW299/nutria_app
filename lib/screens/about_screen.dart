// lib/screens/about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de NutrIA'),
        backgroundColor: const Color(0xFF066FFF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with logo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF066FFF),
                    const Color(0xFF066FFF).withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/icons/app_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'NutrIA',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tu Asistente Nutricional Inteligente',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Versión 1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),

            // Content sections
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'Acerca de NutrIA',
                    icon: Icons.info_outline,
                    content:
                        'NutrIA es una aplicación móvil que estima el contenido nutricional de tus comidas mediante un sistema de Inteligencia Artificial estructurado en dos etapas para garantizar mayor precisión y trazabilidad.',
                  ),
                  const SizedBox(height: 24),
                  _buildAISystemSection(),
                  const SizedBox(height: 24),
                  _buildBodyCalculationsSection(),
                  const SizedBox(height: 24),
                  _buildTraceabilitySection(),
                  const SizedBox(height: 24),
                  _buildLimitationsSection(),
                  const SizedBox(height: 24),
                  _buildPrivacySection(),
                  const SizedBox(height: 24),
                  _buildContactSection(),
                  const SizedBox(height: 40),
                  _buildFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF066FFF), size: 28),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF066FFF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildAISystemSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.psychology, color: Color(0xFF066FFF), size: 28),
            const SizedBox(width: 12),
            const Text(
              'Sistema de IA en Dos Etapas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF066FFF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildStageCard(
          stage: 'Stage 1',
          title: 'Estimación de Porción',
          model: 'GPT-4 Mini',
          description:
              'El modelo GPT-4 Mini analiza la imagen y estima el tamaño de la porción en gramos. '
              'Este paso se basa en equivalencias oficiales del USDA FoodData Central y patrones de porción '
              'utilizados en ASA24 (NIH) para mejorar la estabilidad de la predicción.',
          icon: Icons.scale,
        ),
        const SizedBox(height: 12),
        _buildStageCard(
          stage: 'Stage 2',
          title: 'Estimación Nutricional',
          model: 'Gemini 2.5 Pro',
          description:
              'Con la porción ya normalizada, Gemini 2.5 Pro calcula calorías, proteínas, carbohidratos y grasas. '
              'El modelo trabaja con densidades alimentarias estándar y devuelve la información en formato JSON '
              'estructurado para asegurar trazabilidad completa.',
          icon: Icons.analytics,
        ),
      ],
    );
  }

  Widget _buildStageCard({
    required String stage,
    required String title,
    required String model,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF066FFF).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF066FFF).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF066FFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stage,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF066FFF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF066FFF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              model,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF066FFF),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyCalculationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calculate, color: Color(0xFF066FFF), size: 28),
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'Cálculos Corporales y Parámetros Energéticos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF066FFF),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'NutrIA utiliza fórmulas validadas científicamente para estimar tus requerimientos diarios:',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildCalculationCard(
          title: 'TMB (Tasa Metabólica Basal)',
          subtitle: 'Fórmula de Mifflin–St Jeor',
          icon: Icons.monitor_heart,
          formulas: [
            'Hombres:',
            'TMB = (10 × peso kg) + (6.25 × altura cm) – (5 × edad) + 5',
            '',
            'Mujeres:',
            'TMB = (10 × peso kg) + (6.25 × altura cm) – (5 × edad) – 161',
          ],
        ),
        const SizedBox(height: 12),
        _buildCalculationCard(
          title: 'GETD / TDEE (Gasto Energético Total Diario)',
          subtitle: 'Basado en guías de la OMS',
          icon: Icons.local_fire_department,
          formulas: [
            'GETD = TMB × Factor de Actividad (AF)',
            '',
            'Se obtiene multiplicando la TMB por el coeficiente de actividad física.',
          ],
        ),
        const SizedBox(height: 12),
        _buildCalculationCard(
          title: 'IMC (Índice de Masa Corporal)',
          subtitle: 'Clasificación del estado corporal',
          icon: Icons.accessibility_new,
          formulas: [
            'IMC = peso (kg) / altura² (m²)',
          ],
        ),
        const SizedBox(height: 12),
        _buildCalculationCard(
          title: 'Estado Calórico Diario',
          subtitle: 'Análisis de balance energético',
          icon: Icons.trending_up,
          formulas: [
            'El sistema compara la ingesta estimada con tu GETD para identificar:',
            '• Déficit calórico',
            '• Equilibrio',
            '• Superávit',
            '',
            'Criterio: ≈ 7700 kcal ≈ ±1 kg de variación de peso acumulado',
          ],
        ),
      ],
    );
  }

  Widget _buildCalculationCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> formulas,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF066FFF), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: formulas.map((formula) {
                if (formula.isEmpty) {
                  return const SizedBox(height: 8);
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    formula,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraceabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.history, color: Color(0xFF066FFF), size: 28),
            const SizedBox(width: 12),
            const Text(
              'Trazabilidad y Auditoría',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF066FFF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Cada consulta queda registrada con:',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        _buildTraceabilityItem('La imagen enviada'),
        _buildTraceabilityItem(
            'El resultado de GPT-4 Mini (porción)'),
        _buildTraceabilityItem(
            'El resultado de Gemini 2.5 Pro (macronutrientes)'),
        _buildTraceabilityItem('Fecha y modelo utilizado'),
        _buildTraceabilityItem('Cálculos energéticos generados'),
        const SizedBox(height: 12),
        Text(
          'Esto permite reconstruir cualquier análisis y mantener transparencia en el proceso.',
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTraceabilityItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 18,
            color: Color(0xFF066FFF),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Limitaciones del Sistema',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.orange.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Los resultados pueden variar debido a:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildLimitationItem('Ingredientes ocultos o no visibles'),
              _buildLimitationItem('Métodos de cocción desconocidos'),
              _buildLimitationItem(
                  'Variaciones naturales entre alimentos reales y sus densidades estándar'),
              _buildLimitationItem(
                  'Calidad, ángulo o iluminación de la fotografía'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'NutrIA ofrece estimaciones, no diagnósticos.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLimitationItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: Colors.orange[700],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.security, color: Color(0xFF066FFF), size: 28),
            const SizedBox(width: 12),
            const Text(
              'Privacidad y Seguridad',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF066FFF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF066FFF).withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF066FFF).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.lock, color: Color(0xFF066FFF), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Las imágenes y datos se procesan de forma cifrada y se utilizan únicamente para generar tus estimaciones.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.delete, color: Color(0xFF066FFF), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Puedes eliminarlos cuando lo desees desde tu perfil.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.contact_support, color: Color(0xFF066FFF), size: 28),
            const SizedBox(width: 12),
            const Text(
              'Contacto y Soporte',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF066FFF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          '¿Tienes preguntas o sugerencias? Nos encantaría escucharte.',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        _buildContactItem(Icons.email, 'Email: soporte@nutria.app'),
        _buildContactItem(Icons.web, 'Web: www.nutria.app'),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Text(
            '© 2024 NutrIA. Todos los derechos reservados.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hecho con ❤️ para tu salud',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
