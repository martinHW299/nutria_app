// lib/widgets/sidebar_drawer.dart
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

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
            child: const SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Nutria Logo (you can replace with an actual logo asset)
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.restaurant,
                      size: 40,
                      color: Color(0xFF066FFF),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nutria',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
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
                    _showAboutDialog(context);
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

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Acerca de Nutria'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nutria - Tu Asistente Nutricional'),
                SizedBox(height: 8),
                Text('Versión: 1.0.0'),
                SizedBox(height: 8),
                Text(
                  'Desarrollado para ayudarte a mantener un estilo de vida saludable a través del seguimiento nutricional inteligente.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
    );
  }
}
