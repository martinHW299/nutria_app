// lib/screens/credentials_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class CredentialsScreen extends StatefulWidget {
  const CredentialsScreen({super.key});

  @override
  State<CredentialsScreen> createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends State<CredentialsScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  Map<String, dynamic>? _userData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the user data passed from onboarding
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _userData = args;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog(
        'Por favor ingresa tanto el correo electrónico como la contraseña',
      );
      return;
    }

    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(_emailController.text.trim())) {
      _showErrorDialog('Por favor ingresa un correo electrónico válido');
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorDialog('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Combine onboarding data with credentials
      final completeUserData = {
        ..._userData!,
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
      };

      // print('Complete userData: $completeUserData');

      final result = await AuthService.signup(completeUserData);

      if (result == true) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        if (mounted) {
          String errorMessage = 'Error al crear la cuenta';
          if (result is String) {
            errorMessage = result;
          }
          _showErrorDialog(errorMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error de conexión: ${e.toString()}');
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
      builder:
          (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF066FFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Crear cuenta',
          style: TextStyle(
            color: Color(0xFF066FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight -
                  40,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Header section
                  Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.width * 0.15,
                    constraints: const BoxConstraints(
                      minWidth: 60,
                      minHeight: 60,
                      maxWidth: 80,
                      maxHeight: 80,
                    ),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.email,
                      size: MediaQuery.of(context).size.width * 0.08,
                      color: Colors.green,
                    ),
                  ),

                  Text(
                    'Último paso',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crea tu cuenta para empezar a usar Nutria',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  // Email field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.email, color: Color(0xFF066FFF)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF066FFF),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF066FFF),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Password requirements
                  Text(
                    'La contraseña debe tener al menos 6 caracteres',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  // Create account button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _signup,
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text(
                                'Crear cuenta',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),

                  const Spacer(),

                  // Privacy notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.privacy_tip,
                          color: Colors.blue.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Al crear tu cuenta, aceptas nuestros términos de servicio y política de privacidad.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
