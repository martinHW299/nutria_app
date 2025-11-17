// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    print('🎬 LoginScreen initState called at ${DateTime.now()}');
  }

  @override
  void dispose() {
    print('🎬 LoginScreen dispose called at ${DateTime.now()}');
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    print('🔍 LOGIN METHOD CALLED');
    print('🔍 Current time: ${DateTime.now()}');
    print('🔍 Email: ${emailController.text}');
    print('🔍 Is already loading: $_isLoading');
    print('🔍 Stack trace:\n${StackTrace.current}');

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text('Información faltante'),
              content: const Text(
                'Por favor ingresa tanto el correo electrónico como la contraseña',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await AuthService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result == true) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        if (mounted) {
          String errorMessage = 'Error al iniciar sesión';
          if (result is String) {
            errorMessage = result;
          }
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: const Text('Error de inicio de sesión'),
                  content: Text(errorMessage),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: const Text('Error'),
                content: Text('Error de conexión: ${e.toString()}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
          'Bienvenido de vuelta',
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
                      color: const Color(0xFF066FFF).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.width * 0.08,
                      color: const Color(0xFF066FFF),
                    ),
                  ),

                  Text(
                    'Inicia sesión en tu cuenta',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa tus credenciales para continuar',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  // Email field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: emailController,
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
                      controller: passwordController,
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

                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF066FFF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : () {
                        print('🔘 Login button pressed at ${DateTime.now()}');
                        login();
                      },
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
                                'Iniciar sesión',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),

                  const Spacer(),

                  // Sign up link
                  Center(
                    child: TextButton(
                      onPressed:
                          () => Navigator.pushNamed(context, '/onboarding'),
                      child: const Text(
                        '¿No tienes una cuenta? Regístrate',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF066FFF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height:
                        MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
