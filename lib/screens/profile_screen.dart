// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/user_profile_service.dart';
import '../models/enums.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await UserProfileService.getUserProfile();
      setState(() {
        _userProfile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar el perfil: $e')),
        );
      }
    }
  }

  String _getGenderText(String gender) {
    switch (gender) {
      case 'MALE':
        return 'Hombre';
      case 'FEMALE':
        return 'Mujer';
      default:
        return gender;
    }
  }

  String _getCaloricAdjustmentText(String adjustment) {
    try {
      final caloricAdjustment = CaloricAdjustment.values.firstWhere(
        (e) => e.toString().split('.').last == adjustment,
      );
      return caloricAdjustment.displayName;
    } catch (e) {
      return adjustment;
    }
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Bajo peso';
    if (bmi < 25.0) return 'Peso normal';
    if (bmi < 30.0) return 'Sobrepeso';
    return 'Obesidad';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25.0) return Colors.green;
    if (bmi < 30.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color(0xFF066FFF),
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _userProfile == null
              ? const Center(
                child: Text(
                  'No se pudo cargar el perfil',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadUserProfile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 20),
                      _buildPersonalInfoCard(),
                      const SizedBox(height: 16),
                      _buildPhysicalInfoCard(),
                      const SizedBox(height: 16),
                      _buildGoalsCard(),
                      const SizedBox(height: 16),
                      _buildMetricsCard(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF066FFF).withOpacity(0.1),
              child: Text(
                '${_userProfile!.userName[0]}${_userProfile!.userLastname[0]}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF066FFF),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_userProfile!.userName} ${_userProfile!.userLastname}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _userProfile!.userCredential.email,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información Personal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Edad', '${_userProfile!.age} años', Icons.cake),
            _buildInfoRow(
              'Género',
              _getGenderText(_userProfile!.gender),
              Icons.person,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información Física',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Altura',
              '${_userProfile!.height.toStringAsFixed(0)} cm',
              Icons.height,
            ),
            _buildInfoRow(
              'Peso Actual',
              '${_userProfile!.weight.toStringAsFixed(1)} kg',
              Icons.monitor_weight,
            ),
            _buildInfoRow(
              'Peso Objetivo',
              '${_userProfile!.weightGoal.toStringAsFixed(1)} kg',
              Icons.flag,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Objetivos y Actividad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'Nivel de Actividad',
              '${_userProfile!.activityLevel}x',
              Icons.directions_run,
            ),
            _buildInfoRow(
              'Ajuste Calórico',
              _getCaloricAdjustmentText(_userProfile!.caloricAdjustment),
              Icons.trending_up,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsCard() {
    final bmiCategory = _getBMICategory(_userProfile!.bmi);
    final bmiColor = _getBMIColor(_userProfile!.bmi);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Métricas Calculadas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'BMR (Metabolismo Basal)',
              '${_userProfile!.bmr.toStringAsFixed(0)} kcal/día',
              Icons.local_fire_department,
            ),
            _buildInfoRow(
              'TDEE (Gasto Total)',
              '${_userProfile!.tdee.toStringAsFixed(0)} kcal/día',
              Icons.fitness_center,
            ),
            Row(
              children: [
                const Icon(Icons.health_and_safety, color: Color(0xFF066FFF)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'IMC (Índice de Masa Corporal)',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            _userProfile!.bmi.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: bmiColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: bmiColor),
                            ),
                            child: Text(
                              bmiCategory,
                              style: TextStyle(
                                color: bmiColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF066FFF)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
