// // lib/screens/signup_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import '../services/auth_service.dart';
// import '../models/enums.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _obscurePassword = true;
  
//   // Track current step
//   int _currentStep = 0;
//   final int _totalSteps = 4;
  
//   // Health advisor data
//   Map<String, dynamic>? _healthAdvice;
//   bool _isLoadingHealthAdvice = false;
  
//   // Text controllers
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _weightController = TextEditingController();
//   final TextEditingController _weightGoalController = TextEditingController();
  
//   // Date for age
//   DateTime? _selectedDate;
  
//   // Dropdown values
//   Gender _selectedGender = Gender.MALE;
//   ActivityLevel _selectedActivityLevel = ActivityLevel.MODERATE;
//   CaloricAdjustment _selectedCaloricAdjustment = CaloricAdjustment.MAINTAIN;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _nameController.dispose();
//     _lastNameController.dispose();
//     _heightController.dispose();
//     _weightController.dispose();
//     _weightGoalController.dispose();
//     super.dispose();
//   }

//   // Calculate age from selected date
//   int get _calculatedAge {
//     if (_selectedDate == null) return 0;
//     final now = DateTime.now();
//     int age = now.year - _selectedDate!.year;
//     if (now.month < _selectedDate!.month || 
//         (now.month == _selectedDate!.month && now.day < _selectedDate!.day)) {
//       age--;
//     }
//     return age;
//   }

//   // Validate step 1 (Basic Information)
//   void _validateStep1() {
//     // Check all required fields
//     if (_nameController.text.trim().isEmpty) {
//       _showErrorDialog('Por favor ingresa tu nombre');
//       return;
//     }
//     if (_lastNameController.text.trim().isEmpty) {
//       _showErrorDialog('Por favor ingresa tu apellido');
//       return;
//     }
//     if (_emailController.text.trim().isEmpty) {
//       _showErrorDialog('Por favor ingresa tu correo electrónico');
//       return;
//     }
//     if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text.trim())) {
//       _showErrorDialog('Por favor ingresa un correo electrónico válido');
//       return;
//     }
//     if (_passwordController.text.length < 6) {
//       _showErrorDialog('La contraseña debe tener al menos 6 caracteres');
//       return;
//     }
//     if (_selectedDate == null) {
//       _showErrorDialog('Por favor selecciona tu fecha de nacimiento');
//       return;
//     }
//     if (_calculatedAge < 13) {
//       _showErrorDialog('Debes tener al menos 13 años para usar la aplicación');
//       return;
//     }
//     if (_calculatedAge > 120) {
//       _showErrorDialog('Por favor verifica tu fecha de nacimiento');
//       return;
//     }
    
//     setState(() {
//       _currentStep = 1;
//     });
//   }

//   // Validate step 2 (Physical Measurements) and fetch health advice
//   Future<void> _validateStep2() async {
//     // Validate height
//     if (_heightController.text.trim().isEmpty) {
//       _showErrorDialog('Por favor ingresa tu altura');
//       return;
//     }
//     double? height = double.tryParse(_heightController.text.trim());
//     if (height == null || height < 50 || height > 250) {
//       _showErrorDialog('Por favor ingresa una altura válida entre 50 y 250 cm');
//       return;
//     }
    
//     // Validate weight
//     if (_weightController.text.trim().isEmpty) {
//       _showErrorDialog('Por favor ingresa tu peso');
//       return;
//     }
//     double? weight = double.tryParse(_weightController.text.trim());
//     if (weight == null || weight < 20 || weight > 300) {
//       _showErrorDialog('Por favor ingresa un peso válido entre 20 y 300 kg');
//       return;
//     }
    
//     setState(() {
//       _isLoadingHealthAdvice = true;
//     });
    
//     try {
//       final data = await AuthService.getHealthAdvice(height, weight);
      
//       if (data != null) {
//         setState(() {
//           _healthAdvice = data;
//           _currentStep = 2;
          
//           // Pre-select caloric adjustment based on advice
//           if (data['suggestedGoal'] == 'LOSS') {
//             _selectedCaloricAdjustment = CaloricAdjustment.LOSS;
//           } else if (data['suggestedGoal'] == 'GAIN') {
//             _selectedCaloricAdjustment = CaloricAdjustment.GAIN;
//           } else {
//             _selectedCaloricAdjustment = CaloricAdjustment.MAINTAIN;
//           }
//         });
//       } else {
//         _showErrorDialog('No se pudieron obtener consejos de salud. Por favor intenta de nuevo.');
//       }
//     } catch (e) {
//       _showErrorDialog('Error al obtener consejos de salud: ${e.toString()}');
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoadingHealthAdvice = false;
//         });
//       }
//     }
//   }

//   // Go back to previous step
//   void _goBack() {
//     setState(() {
//       if (_currentStep > 0) {
//         _currentStep--;
//       }
//     });
//   }

//   // Date picker for age
//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime(2000),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)), // Minimum 13 years old
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: const Color(0xFF066FFF),
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: const Color(0xFF066FFF),
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _signup() async {
//     setState(() => _isLoading = true);
    
//     try {
//       final userData = {
//         'email': _emailController.text.trim(),
//         'password': _passwordController.text,
//         'name': _nameController.text.trim(),
//         'lastName': _lastNameController.text.trim(),
//         'age': _calculatedAge,
//         'gender': _selectedGender.toString().split('.').last,
//         'height': double.parse(_heightController.text.trim()),
//         'weight': double.parse(_weightController.text.trim()),
//         'weightGoal': double.parse(_weightGoalController.text.trim()),
//         'activityLevel': _selectedActivityLevel.toString().split('.').last,
//         'caloricAdjustment': _selectedCaloricAdjustment.toString().split('.').last,
//       };

//       print('userData: $userData');
      
//       final result = await AuthService.signup(userData);
      
//       if (result == true) {
//         if (mounted) {
//           Navigator.pushReplacementNamed(context, '/home');
//         }
//       } else {
//         if (mounted) {
//           String errorMessage = 'Error al crear la cuenta';
//           if (result is String) {
//             errorMessage = result;
//           }
//           _showErrorDialog(errorMessage);
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorDialog('Error de conexión: ${e.toString()}');
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Get calculated healthy weight range in user-friendly format
//   String _getHealthyWeightRange() {
//     if (_healthAdvice == null) return '';
    
//     double minWeight = _healthAdvice!['minWeight'];
//     double maxWeight = _healthAdvice!['maxWeight'];
    
//     return '${minWeight.toStringAsFixed(1)} - ${maxWeight.toStringAsFixed(1)} kg';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: _currentStep > 0
//             ? IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Color(0xFF066FFF)),
//                 onPressed: _goBack,
//               )
//             : null,
//         title: const Text(
//           'Registro',
//           style: TextStyle(
//             color: Color(0xFF066FFF),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 // Progress bar
//                 Container(
//                   height: 4,
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   child: LinearProgressIndicator(
//                     value: (_currentStep + 1) / _totalSteps,
//                     backgroundColor: Colors.grey.shade200,
//                     valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF066FFF)),
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: EdgeInsets.fromLTRB(
//                       20, 
//                       20, 
//                       20, 
//                       MediaQuery.of(context).viewInsets.bottom + 20
//                     ),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          
//                           // Step content
//                           if (_currentStep == 0) _buildBasicInfoStep(),
//                           if (_currentStep == 1) _buildPhysicalMeasurementsStep(),
//                           if (_currentStep == 2) _buildTargetWeightStep(),
//                           if (_currentStep == 3) _buildActivityGoalsStep(),
                          
//                           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                           if (_currentStep == 0)
//                             TextButton(
//                               onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
//                               child: const Text(
//                                 '¿Ya tienes una cuenta? Inicia sesión',
//                                 style: TextStyle(color: Color(0xFF066FFF)),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   // Create a reusable form field with modern design
//   Widget _buildFormField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     TextInputAction textInputAction = TextInputAction.next,
//     List<TextInputFormatter>? inputFormatters,
//     bool obscureText = false,
//     Widget? suffix,
//     VoidCallback? onTap,
//     bool readOnly = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           labelStyle: const TextStyle(color: Colors.grey),
//           prefixIcon: Icon(icon, color: const Color(0xFF066FFF)),
//           suffixIcon: suffix,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//         keyboardType: keyboardType,
//         textInputAction: textInputAction,
//         inputFormatters: inputFormatters,
//         obscureText: obscureText,
//         readOnly: readOnly,
//         onTap: onTap,
//         onChanged: (_) => setState(() {}),
//       ),
//     );
//   }

//   // Create selectable option cards
//   Widget _buildOptionCard({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF066FFF).withOpacity(0.1) : Colors.grey.shade50,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isSelected ? const Color(0xFF066FFF) : Colors.grey.shade200,
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isSelected ? const Color(0xFF066FFF) : Colors.orange,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(icon, color: Colors.white, size: 20),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: isSelected ? const Color(0xFF066FFF) : Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             if (isSelected)
//               const Icon(
//                 Icons.check_circle,
//                 color: Color(0xFF066FFF),
//                 size: 24,
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Step 1: Basic Information
//   Widget _buildBasicInfoStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header with icon
//         Container(
//           width: MediaQuery.of(context).size.width * 0.18,
//           height: MediaQuery.of(context).size.width * 0.18,
//           constraints: const BoxConstraints(
//             minWidth: 60,
//             minHeight: 60,
//             maxWidth: 80,
//             maxHeight: 80,
//           ),
//           margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
//           decoration: BoxDecoration(
//             color: Colors.orange.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             Icons.person,
//             size: MediaQuery.of(context).size.width * 0.09,
//             color: Colors.orange,
//           ),
//         ),
        
//         Text(
//           'Sobre ti',
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.07,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Esto nos ayudará a calcular tus calorías objetivo',
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.04,
//             color: Colors.grey.shade600,
//           ),
//         ),
//         SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        
//         _buildFormField(
//           controller: _nameController,
//           label: 'Nombre',
//           icon: Icons.person,
//         ),
        
//         _buildFormField(
//           controller: _lastNameController,
//           label: 'Apellido',
//           icon: Icons.person,
//         ),
        
//         _buildFormField(
//           controller: _emailController,
//           label: 'Correo electrónico',
//           icon: Icons.email,
//           keyboardType: TextInputType.emailAddress,
//         ),
        
//         _buildFormField(
//           controller: _passwordController,
//           label: 'Contraseña',
//           icon: Icons.lock,
//           obscureText: _obscurePassword,
//           suffix: IconButton(
//             icon: Icon(
//               _obscurePassword ? Icons.visibility : Icons.visibility_off,
//               color: const Color(0xFF066FFF),
//             ),
//             onPressed: () {
//               setState(() {
//                 _obscurePassword = !_obscurePassword;
//               });
//             },
//           ),
//         ),
        
//         // Age selection with date picker
//         GestureDetector(
//           onTap: _selectDate,
//           child: Container(
//             margin: const EdgeInsets.only(bottom: 16),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade50,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey.shade200),
//             ),
//             child: Row(
//               children: [
//                 const Icon(Icons.cake, color: Color(0xFF066FFF)),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Fecha de nacimiento',
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         _selectedDate != null 
//                             ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} (${_calculatedAge} años)'
//                             : 'Selecciona tu fecha de nacimiento',
//                         style: TextStyle(
//                           color: _selectedDate != null ? Colors.black87 : Colors.grey,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 16),
//               ],
//             ),
//           ),
//         ),
        
//         // Gender selection cards
//         const Text(
//           'Sexo',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
        
//         _buildOptionCard(
//           title: 'Hombre',
//           subtitle: 'Selecciona si eres hombre',
//           icon: Icons.male,
//           isSelected: _selectedGender == Gender.MALE,
//           onTap: () => setState(() => _selectedGender = Gender.MALE),
//         ),
        
//         _buildOptionCard(
//           title: 'Mujer', 
//           subtitle: 'Selecciona si eres mujer',
//           icon: Icons.female,
//           isSelected: _selectedGender == Gender.FEMALE,
//           onTap: () => setState(() => _selectedGender = Gender.FEMALE),
//         ),
        
//         SizedBox(height: MediaQuery.of(context).size.height * 0.04),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF066FFF),
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: (_nameController.text.trim().isNotEmpty &&
//                         _lastNameController.text.trim().isNotEmpty &&
//                         _emailController.text.trim().isNotEmpty &&
//                         _passwordController.text.isNotEmpty &&
//                         _selectedDate != null)
//                 ? _validateStep1
//                 : null,
//             child: const Text(
//               'Continuar',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Step 2: Physical Measurements
//   Widget _buildPhysicalMeasurementsStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header with icon
//         Container(
//           width: MediaQuery.of(context).size.width * 0.18,
//           height: MediaQuery.of(context).size.width * 0.18,
//           constraints: const BoxConstraints(
//             minWidth: 60,
//             minHeight: 60,
//             maxWidth: 80,
//             maxHeight: 80,
//           ),
//           margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
//           decoration: BoxDecoration(
//             color: Colors.orange.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             Icons.monitor_weight,
//             size: MediaQuery.of(context).size.width * 0.09,
//             color: Colors.orange,
//           ),
//         ),
        
//         Text(
//           'Medidas físicas',
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.07,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Cuéntanos sobre tus estadísticas físicas actuales',
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.04,
//             color: Colors.grey.shade600,
//           ),
//         ),
//         SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        
//         _buildFormField(
//           controller: _heightController,
//           label: 'Altura (cm)',
//           icon: Icons.height,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
//           ],
//         ),
        
//         _buildFormField(
//           controller: _weightController,
//           label: 'Peso actual (kg)',
//           icon: Icons.monitor_weight,
//           keyboardType: TextInputType.number,
//           textInputAction: TextInputAction.done,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
//           ],
//         ),
        
//         SizedBox(height: MediaQuery.of(context).size.height * 0.04),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF066FFF),
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: _isLoadingHealthAdvice 
//                 ? null 
//                 : (_heightController.text.trim().isNotEmpty && _weightController.text.trim().isNotEmpty)
//                     ? _validateStep2
//                     : null,
//             child: _isLoadingHealthAdvice
//                 ? const SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                   )
//                 : const Text(
//                     'Obtener consejos de salud',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Step 3: Target Weight Step
//   Widget _buildTargetWeightStep() {
//     // Determine weight goal suggestion message and style
//     String goalMessage = '';
//     Color goalColor = Colors.blue;
//     IconData goalIcon = Icons.info;
    
//     if (_healthAdvice != null) {
//       String suggestedGoal = _healthAdvice!['suggestedGoal'];
//       String healthyRange = _getHealthyWeightRange();
      
//       if (suggestedGoal == 'LOSS') {
//         goalMessage = 'Nutria recomienda pérdida de peso para una salud óptima. Tu rango de peso saludable es $healthyRange.';
//         goalColor = Colors.orange;
//         goalIcon = Icons.trending_down;
//       } else if (suggestedGoal == 'GAIN') {
//         goalMessage = 'Nutria recomienda ganar peso para una salud óptima. Tu rango de peso saludable es $healthyRange.';
//         goalColor = Colors.green;
//         goalIcon = Icons.trending_up;
//       } else {
//         goalMessage = 'Tu peso está dentro del rango saludable de $healthyRange. Nutria recomienda mantener tu peso actual.';
//         goalColor = Colors.blue;
//         goalIcon = Icons.check_circle;
//       }
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header with icon
//         Container(
//           width: MediaQuery.of(context).size.width * 0.18,
//           height: MediaQuery.of(context).size.width * 0.18,
//           constraints: const BoxConstraints(
//             minWidth: 60,
//             minHeight: 60,
//             maxWidth: 80,
//             maxHeight: 80,
//           ),
//           margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
//           decoration: BoxDecoration(
//             color: Colors.orange.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             Icons.flag,
//             size: MediaQuery.of(context).size.width * 0.09,
//             color: Colors.orange,
//           ),
//         ),
        
//         Text(
//           'Establece tu peso objetivo',
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.07,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           '¿Qué peso te gustaría alcanzar?',
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.04,
//             color: Colors.grey.shade600,
//           ),
//         ),
//         SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        
//         // Health advice message
//         if (_healthAdvice != null)
//           Container(
//             margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: goalColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: goalColor.withOpacity(0.3)),
//             ),
//             child: Row(
//               children: [
//                 Icon(goalIcon, color: goalColor, size: 28),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     goalMessage,
//                     style: TextStyle(
//                       color: goalColor,
//                       fontWeight: FontWeight.w500,
//                       fontSize: MediaQuery.of(context).size.width * 0.035,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
        
//         _buildFormField(
//           controller: _weightGoalController,
//           label: 'Peso objetivo (kg)',
//           icon: Icons.flag,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
//           ],
//         ),
        
//         SizedBox(height: MediaQuery.of(context).size.height * 0.04),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF066FFF),
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: _weightGoalController.text.trim().isEmpty ? null : () {
//               // Validate target weight
//               double? targetWeight = double.tryParse(_weightGoalController.text.trim());
//               if (targetWeight == null || targetWeight < 20 || targetWeight > 300) {
//                 _showErrorDialog('Por favor ingresa un peso objetivo válido entre 20 y 300 kg');
//                 return;
//               }
              
//               setState(() {
//                 _currentStep = 3;
//               });
//             },
//             child: const Text(
//               'Continuar',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // Step 4: Activity & Goals
//   Widget _buildActivityGoalsStep() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Header with icon
//         Container(
//           width: MediaQuery.of(context).size.width * 0.18,
//           height: MediaQuery.of(context).size.width * 0.18,
//           constraints: const BoxConstraints(
//             minWidth: 60,
//             minHeight: 60,
//             maxWidth: 80,
//             maxHeight: 80,
//           ),
//           margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
//           decoration: BoxDecoration(
//             color: Colors.orange.withOpacity(0.1),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             Icons.directions_run,
//             size: MediaQuery.of(context).size.width * 0.09,
//             color: Colors.orange,
//           ),
//         ),
        
//         Text(
//           '¿Cuál es tu objetivo?',
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.07,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Te ayudaremos a encontrar la ingesta calórica adecuada para lograrlo',
//           style: TextStyle(
//             fontSize: MediaQuery.of(context).size.width * 0.04,
//             color: Colors.grey.shade600,
//           ),
//         ),
//         SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        
//         // Activity Level
//         const Text(
//           'Nivel de actividad',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
        
//         ...ActivityLevel.values.map((activity) {
//           return _buildOptionCard(
//             title: activity.displayName.split(' (')[0],
//             subtitle: activity.displayName.contains('(') 
//                 ? activity.displayName.split('(')[1].replaceAll(')', '')
//                 : activity.displayName,
//             icon: Icons.directions_run,
//             isSelected: _selectedActivityLevel == activity,
//             onTap: () => setState(() => _selectedActivityLevel = activity),
//           );
//         }).toList(),
        
//         const SizedBox(height: 24),
        
//         // Goal Type
//         const Text(
//           'Tipo de objetivo',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 16),
        
//         ...CaloricAdjustment.values
//             .where((adjustment) {
//               // Filter options based on weight goal
//               if (_weightGoalController.text.trim().isEmpty) return true;
              
//               try {
//                 double currentWeight = double.parse(_weightController.text.trim());
//                 double targetWeight = double.parse(_weightGoalController.text.trim());
                
//                 if (targetWeight > currentWeight) {
//                   return adjustment == CaloricAdjustment.MAINTAIN ||
//                          adjustment == CaloricAdjustment.GAIN;
//                 } else if (targetWeight < currentWeight) {
//                   return adjustment == CaloricAdjustment.MAINTAIN ||
//                          adjustment == CaloricAdjustment.LOSS;
//                 }
//               } catch (e) {
//                 // Show all options if parsing fails
//               }
//               return true;
//             })
//             .map((adjustment) {
//               IconData icon;
//               switch (adjustment) {
//                 case CaloricAdjustment.LOSS:
//                   icon = Icons.trending_down;
//                   break;
//                 case CaloricAdjustment.GAIN:
//                   icon = Icons.trending_up;
//                   break;
//                 default:
//                   icon = Icons.balance;
//               }
              
//               return _buildOptionCard(
//                 title: adjustment.displayName,
//                 subtitle: _getGoalDescription(adjustment),
//                 icon: icon,
//                 isSelected: _selectedCaloricAdjustment == adjustment,
//                 onTap: () => setState(() => _selectedCaloricAdjustment = adjustment),
//               );
//             }).toList(),
        
//         SizedBox(height: MediaQuery.of(context).size.height * 0.04),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             onPressed: _signup,
//             child: const Text(
//               'Crear cuenta',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   String _getGoalDescription(CaloricAdjustment adjustment) {
//     switch (adjustment) {
//       case CaloricAdjustment.LOSS:
//         return 'Optimiza la pérdida de peso y preserva la masa muscular';
//       case CaloricAdjustment.GAIN:
//         return 'Aumenta tu peso y fortalécete';
//       case CaloricAdjustment.MAINTAIN:
//         return 'Mantén tu peso estable y busca la recomposición corporal';
//     }
//   }
// }