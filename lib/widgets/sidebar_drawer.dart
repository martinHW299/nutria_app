// lib/widgets/sidebar_drawer.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/about_screen.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    await AuthService.logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Header with Nutria logo
          Container(
            height: 200,
            width: double.infinity,
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
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nutria Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'assets/icons/app_icon.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nutria',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Tu asistente nutricional',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFF066FFF)),
                  title: const Text('Mi Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.food_bank,
                    color: Color(0xFF066FFF),
                  ),
                  title: const Text('Registro Diario'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.analytics,
                    color: Color(0xFF066FFF),
                  ),
                  title: const Text('Análisis'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to analytics tab in home
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Color(0xFF066FFF)),
                  title: const Text('Configuración'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Navigate to settings screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Configuración próximamente'),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.info, color: Color(0xFF066FFF)),
                  title: const Text('Acerca de'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help, color: Color(0xFF066FFF)),
                  title: const Text('Ayuda'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ayuda próximamente')),
                    );
                  },
                ),
              ],
            ),
          ),

          // Logout button
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar Sesión'),
              onTap: () => _handleLogout(context),
            ),
          ),
        ],
      ),
    );
  }
}
