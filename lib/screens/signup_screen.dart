// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
import '../services/auth_service.dart';
import '../models/enums.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  // Track current step
  int _currentStep = 0;
  
  // Health advisor data
  Map<String, dynamic>? _healthAdvice;
  bool _isLoadingHealthAdvice = false;
  
  // Text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _weightGoalController = TextEditingController();
  
  // Dropdown values
  Gender _selectedGender = Gender.MALE;
  ActivityLevel _selectedActivityLevel = ActivityLevel.MODERATE;
  CaloricAdjustment _selectedCaloricAdjustment = CaloricAdjustment.MAINTAIN;

  // To track if each step is valid
  bool _isStep1Valid = false;

  // Spacing constants
  static const double _spacingSmall = 12.0;
  static const double _spacingMedium = 16.0;
  static const double _spacingLarge = 24.0;
  static const double _spacingXLarge = 32.0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _weightGoalController.dispose();
    super.dispose();
  }

  // Validate step 1 (Basic Information)
  void _validateStep1() {
    _isStep1Valid = _nameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text) &&
        _passwordController.text.length >= 6 &&
        _ageController.text.isNotEmpty &&
        (int.tryParse(_ageController.text) ?? 0) >= 13 &&
        (int.tryParse(_ageController.text) ?? 0) <= 120;
    
    if (_isStep1Valid) {
      setState(() {
        _currentStep = 1;
      });
    }
  }

  // Validate step 2 (Physical Measurements) and fetch health advice
  // Validate step 2 (Physical Measurements) and fetch health advice
Future<void> _validateStep2() async {
  bool isValid = _heightController.text.isNotEmpty &&
      _weightController.text.isNotEmpty &&
      (double.tryParse(_heightController.text) ?? 0) >= 50 &&
      (double.tryParse(_heightController.text) ?? 0) <= 250 &&
      (double.tryParse(_weightController.text) ?? 0) >= 20 &&
      (double.tryParse(_weightController.text) ?? 0) <= 300;
  
  if (isValid) {
    setState(() {
      _isLoadingHealthAdvice = true;
    });
    
    try {
      // Use the AuthService instead of direct API call
      final data = await AuthService.getHealthAdvice(
        double.parse(_heightController.text),
        double.parse(_weightController.text)
      );
      
      if (data != null) {
        setState(() {
          _healthAdvice = data;
          _currentStep = 2; // Move to step 3 (Target Weight) - keep this as is
          
          // Pre-select caloric adjustment based on advice
          if (data['suggestedGoal'] == 'LOSS') {
            _selectedCaloricAdjustment = CaloricAdjustment.LOSS_LIGHT;
          } else if (data['suggestedGoal'] == 'GAIN') {
            _selectedCaloricAdjustment = CaloricAdjustment.GAIN_LIGHT;
          } else {
            _selectedCaloricAdjustment = CaloricAdjustment.MAINTAIN;
          }
        });
      } else {
        _showErrorDialog('Failed to get health advice. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingHealthAdvice = false;
        });
      }
    }
  }
}

  // Go back to previous step
  void _goBack() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  Future<void> _signup() async {
    setState(() => _isLoading = true);
    
    try {
      final userData = {
        'email': _emailController.text,
        'password': _passwordController.text,
        'name': _nameController.text,
        'lastName': _lastNameController.text,
        'age': int.parse(_ageController.text),
        'gender': _selectedGender.toString().split('.').last,
        'height': double.parse(_heightController.text),
        'weight': double.parse(_weightController.text),
        'weightGoal': double.parse(_weightGoalController.text),
        'activityLevel': _selectedActivityLevel.toString().split('.').last,
        'caloricAdjustment': _selectedCaloricAdjustment.toString().split('.').last,
      };

      print('userData: $userData');
      
      final result = await AuthService.signup(userData);
      
      if (result == true) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        if (mounted) {
          _showErrorDialog('Signup failed. Please check your information and try again.');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error during signup: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Get calculated healthy weight range in user-friendly format
  String _getHealthyWeightRange() {
    if (_healthAdvice == null) return '';
    
    double minWeight = _healthAdvice!['minWeight'];
    double maxWeight = _healthAdvice!['maxWeight'];
    
    return '${minWeight.toStringAsFixed(1)} - ${maxWeight.toStringAsFixed(1)} kg';
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Sign Up'),
      leading: _currentStep > 0
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goBack,
            )
          : null,
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(_spacingMedium),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Step indicator
                  StepIndicator(currentStep: _currentStep),
                  const SizedBox(height: _spacingLarge),
                  
                  // Step 1: Basic Information
                  if (_currentStep == 0) _buildBasicInfoStep(),
                  
                  // Step 2: Physical Measurements
                  if (_currentStep == 1) _buildPhysicalMeasurementsStep(),
                  
                  // Step 3: Target Weight
                  if (_currentStep == 2) _buildTargetWeightStep(),
                  
                  // Step 4: Activity & Goals
                  if (_currentStep == 3) _buildActivityGoalsStep(),
                  
                  const SizedBox(height: _spacingMedium),
                  if (_currentStep == 0)
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text('Already have an account? Login'),
                    ),
                ],
              ),
            ),
          ),
    );
  }

  // Create a reusable form field
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _spacingSmall),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: suffix,
        ),
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  // Step 1: Basic Information
  Widget _buildBasicInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Basic Information'),
        
        _buildFormField(
          controller: _nameController,
          label: 'First Name',
          icon: Icons.person,
        ),
        
        _buildFormField(
          controller: _lastNameController,
          label: 'Last Name',
          icon: Icons.person,
        ),
        
        _buildFormField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
        ),
        
        _buildFormField(
          controller: _passwordController,
          label: 'Password',
          icon: Icons.lock,
          obscureText: _obscurePassword,
          suffix: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        
        _buildFormField(
          controller: _ageController,
          label: 'Age',
          icon: Icons.cake,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        
        Padding(
          padding: const EdgeInsets.only(bottom: _spacingSmall),
          child: DropdownButtonFormField<Gender>(
            value: _selectedGender,
            decoration: const InputDecoration(
              labelText: 'Gender',
              prefixIcon: Icon(Icons.person_outline),
            ),
            items: Gender.values.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender.displayName),
              );
            }).toList(),
            onChanged: (Gender? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedGender = newValue;
                });
              }
            },
          ),
        ),
        
        const SizedBox(height: _spacingLarge),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: _spacingMedium),
          ),
          onPressed: (_nameController.text.isNotEmpty &&
                      _lastNameController.text.isNotEmpty &&
                      _emailController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty &&
                      _ageController.text.isNotEmpty)
              ? _validateStep1
              : null,
          child: const Text('Next', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  // Step 2: Physical Measurements
  Widget _buildPhysicalMeasurementsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Physical Measurements'),
        
        _buildFormField(
          controller: _heightController,
          label: 'Height (cm)',
          icon: Icons.height,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
        ),
        
        _buildFormField(
          controller: _weightController,
          label: 'Current Weight (kg)',
          icon: Icons.monitor_weight,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
        ),
        
        const SizedBox(height: _spacingLarge),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: _spacingMedium),
          ),
          onPressed: _isLoadingHealthAdvice 
              ? null 
              : (_heightController.text.isNotEmpty && _weightController.text.isNotEmpty)
                  ? _validateStep2
                  : null,
          child: _isLoadingHealthAdvice
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Get Health Advice', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  // Step 3: Target Weight Step
Widget _buildTargetWeightStep() {
  // Determine weight goal suggestion message and style
  String goalMessage = '';
  Color goalColor = Colors.blue;
  IconData goalIcon = Icons.info;
  
  if (_healthAdvice != null) {
    String suggestedGoal = _healthAdvice!['suggestedGoal'];
    String healthyRange = _getHealthyWeightRange();
    
    if (suggestedGoal == 'LOSS') {
      goalMessage = 'Nutria recommends weight loss for optimal health. Your healthy weight range is $healthyRange.';
      goalColor = Colors.orange;
      goalIcon = Icons.trending_down;
    } else if (suggestedGoal == 'GAIN') {
      goalMessage = 'Nutria recommends gaining weight for optimal health. Your healthy weight range is $healthyRange.';
      goalColor = Colors.green;
      goalIcon = Icons.trending_up;
    } else {
      goalMessage = 'Your weight is within a healthy range of $healthyRange. Nutria recommends maintaining your current weight.';
      goalColor = Colors.blue;
      goalIcon = Icons.check_circle;
    }
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SectionHeader(title: 'Set Your Target Weight'),
      
      // Health advice message
      if (_healthAdvice != null)
        Container(
          margin: const EdgeInsets.only(bottom: _spacingMedium),
          padding: const EdgeInsets.all(_spacingMedium),
          decoration: BoxDecoration(
            color: goalColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: goalColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(goalIcon, color: goalColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  goalMessage,
                  style: TextStyle(
                    color: goalColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      
      _buildFormField(
        controller: _weightGoalController,
        label: 'Target Weight (kg)',
        icon: Icons.flag,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
      ),
      
      const SizedBox(height: _spacingLarge),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: _spacingMedium),
        ),
        onPressed: _weightGoalController.text.isEmpty ? null : () {
          setState(() {
            _currentStep = 3;
          });
        },
        child: const Text('Next', style: TextStyle(fontSize: 16)),
      ),
    ],
  );
}

// Step 4: Activity & Goals (updated)
Widget _buildActivityGoalsStep() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SectionHeader(title: 'Activity & Goals'),
      
      Padding(
        padding: const EdgeInsets.only(bottom: _spacingSmall),
        child: DropdownButtonFormField<ActivityLevel>(
          value: _selectedActivityLevel,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Activity Level',
            prefixIcon: Icon(Icons.directions_run),
          ),
          items: ActivityLevel.values.map((activity) {
            return DropdownMenuItem(
              value: activity,
              child: Text(activity.displayName),
            );
          }).toList(),
          onChanged: (ActivityLevel? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedActivityLevel = newValue;
              });
            }
          },
        ),
      ),
      
      Padding(
        padding: const EdgeInsets.only(bottom: _spacingSmall),
        child: DropdownButtonFormField<CaloricAdjustment>(
          value: _selectedCaloricAdjustment,
          isExpanded: true,
          decoration: const InputDecoration(
            labelText: 'Goal Type',
            prefixIcon: Icon(Icons.trending_up),
          ),
          items: CaloricAdjustment.values
              .where((adjustment) {
                // Filter options based on weight goal
                if (_weightGoalController.text.isEmpty) return true;
                
                try {
                  double currentWeight = double.parse(_weightController.text);
                  double targetWeight = double.parse(_weightGoalController.text);
                  
                  if (targetWeight > currentWeight) {
                    return adjustment == CaloricAdjustment.MAINTAIN ||
                           adjustment == CaloricAdjustment.GAIN_LIGHT ||
                           adjustment == CaloricAdjustment.GAIN_MODERATE ||
                           adjustment == CaloricAdjustment.GAIN_AGGRESSIVE;
                  } else if (targetWeight < currentWeight) {
                    return adjustment == CaloricAdjustment.MAINTAIN ||
                           adjustment == CaloricAdjustment.LOSS_LIGHT ||
                           adjustment == CaloricAdjustment.LOSS_MODERATE;
                  }
                } catch (e) {
                  // Show all options if parsing fails
                }
                return true;
              })
              .map((adjustment) {
                return DropdownMenuItem(
                  value: adjustment,
                  child: Text(adjustment.displayName),
                );
              })
              .toList(),
          onChanged: (CaloricAdjustment? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCaloricAdjustment = newValue;
              });
            }
          },
        ),
      ),
      
      const SizedBox(height: _spacingLarge),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: _spacingMedium),
          backgroundColor: Colors.green,
        ),
        onPressed: _signup,
        child: const Text('Create Account', 
            style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    ],
  );
}
}

// Helper widget for section headers
class SectionHeader extends StatelessWidget {
  final String title;
  
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Step indicator widget
class StepIndicator extends StatelessWidget {
  final int currentStep;
  
  const StepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final List<String> stepTitles = [
      'Basic Information',
      'Physical Measurements',
      'Target Weight',
      'Activity & Goals'
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4, // Update to 4 steps
            (index) => Expanded(
              child: Row(
                children: [
                  // Line before circle (except for first item)
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index <= currentStep
                            ? Colors.blue
                            : Colors.grey.shade300,
                      ),
                    ),
                  
                  // Circle with step number
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == currentStep
                          ? Colors.blue
                          : (index < currentStep ? Colors.green : Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  // Line after circle (except for last item)
                  if (index < 3) // Update to check for the last of 4 items
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < currentStep
                            ? Colors.blue
                            : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4, // Update to 4 steps
            (index) => SizedBox(
              width: 70, // Reduce width to fit 4 items
              child: Text(
                stepTitles[index],
                textAlign: index == 0 
                    ? TextAlign.left 
                    : (index == 3 ? TextAlign.right : TextAlign.center),
                style: TextStyle(
                  color: index == currentStep 
                      ? Colors.blue 
                      : (index < currentStep ? Colors.green : Colors.grey),
                  fontWeight: index == currentStep ? FontWeight.bold : FontWeight.normal,
                  fontSize: 10, // Reduce font size to fit 4 items
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}