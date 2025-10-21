import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userData;
  String? _userRole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    _userData = await _authService.getUserData();
    _userRole = await _authService.getUserRole();
    if (mounted) setState(() => _isLoading = false);
  }

  Color _getRoleColor() {
    switch (_userRole) {
      case 'Administrador':
        return Colors.red;
      case 'Profesor':
        return Colors.orange;
      case 'Estudiante':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon() {
    switch (_userRole) {
      case 'Administrador':
        return Icons.admin_panel_settings;
      case 'Profesor':
        return Icons.school;
      case 'Estudiante':
        return Icons.person;
      default:
        return Icons.person_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          
          // Avatar y nombre
          CircleAvatar(
            radius: 60,
            backgroundColor: _getRoleColor(),
            child: Icon(
              _getRoleIcon(),
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          
          Text(
            _userData?['nombre'] ?? 'Usuario',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          Chip(
            label: Text(
              _userRole ?? 'Sin rol',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: _getRoleColor(),
          ),
          
          const SizedBox(height: 30),
          const Divider(),
          
          // Información del perfil
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: Icons.email,
                    title: 'Email',
                    value: _userData?['email'] ?? 'No disponible',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.badge,
                    title: 'ID de Usuario',
                    value: '${_userData?['id'] ?? 'N/A'}',
                  ),
                  const Divider(height: 24),
                  _buildInfoRow(
                    icon: Icons.verified_user,
                    title: 'Rol',
                    value: _userRole ?? 'Sin rol',
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Permisos según rol
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Permisos de tu rol:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._getPermisosWidget(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Información adicional
          Card(
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.indigo,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Plataforma Educativa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Documentación y difusión de la lengua Inga',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.indigo),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Versión 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _getPermisosWidget() {
    List<String> permisos = [];
    
    switch (_userRole) {
      case 'Administrador':
        permisos = [
          'Gestión completa de usuarios',
          'Crear, editar y eliminar cualquier contenido',
          'Acceso total al sistema',
          'Gestión de roles',
        ];
        break;
      case 'Profesor':
        permisos = [
          'Crear palabras y lecciones',
          'Editar tu propio contenido',
          'Eliminar tu propio contenido',
          'Ver todo el contenido publicado',
        ];
        break;
      case 'Estudiante':
        permisos = [
          'Ver palabras publicadas',
          'Ver lecciones publicadas',
          'Acceso de solo lectura',
        ];
        break;
      default:
        permisos = ['Sin permisos asignados'];
    }

    return permisos.map((permiso) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                permiso,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}