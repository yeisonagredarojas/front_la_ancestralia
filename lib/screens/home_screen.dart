import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../services/auth_service.dart';
import '../services/games_service.dart';
import 'login_screen.dart';
import 'palabras_screen.dart';
import 'lecciones_screen.dart';
import 'perfil_screen.dart';
import 'ai_assistant_screen.dart';
import 'vocabulario_screen.dart';
import 'settings_screen.dart';
import 'games/games_list_screen.dart';
import 'admin/gestionar_oraciones_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  GamesService? _gamesService; // Inicializamos luego

  int _currentIndex = 0;
  Map<String, dynamic>? _userData;
  String? _userRole;
  // String _currentLocale = 'es';
  String? _token;

  late final List<Widget> _screens; // Se asignará después de inicializar _gamesService

  String get _currentLocale {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    return settings.locale.languageCode;
  }



  @override
  void initState() {
    super.initState();
    _loadUserData();
    // _loadLocale();
    _initializeScreens(); // Inicializamos pantallas async
  }

  Future<void> _initializeScreens() async {
    _token = await _authService.getToken();
    _gamesService = GamesService(token: _token);

    if (!mounted) return;

    setState(() {
      _screens = [
        const PalabrasScreen(),
        const LeccionesScreen(),
        GamesListScreen(gamesService: _gamesService!), // ✅ Ahora sí funciona
        const AIAssistantScreen(),
        const VocabularioScreen(),
        const PerfilScreen(),
      ];
    });
  }

  Future<void> _loadUserData() async {
    final userData = await _authService.getUserData();
    final role = await _authService.getUserRole();

    if (mounted) {
      setState(() {
        _userData = userData;
        _userRole = role;
      });
    }
  }

  // Future<void> _loadLocale() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _currentLocale = prefs.getString('locale') ?? 'es';
  //   });
  // }

  // Future<void> _changeLanguage(String locale) async {
  //   final settings = Provider.of<SettingsProvider>(context, listen: false);
  //   await settings.changeLocale(locale);
  //   Fluttertoast.showToast(
  //     msg: AppLocalizations.of(context)?.languageChanged ?? 'Idioma cambiado',
  //     backgroundColor: Colors.green,
  //   );
  // }

  Future<void> _changeLanguage(String locale) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.changeLocale(locale);
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)?.languageChanged ?? 'Idioma cambiado',
      backgroundColor: Colors.green,
    );
  }

  Future<void> _handleLogout() async {
    final loc = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc?.logout ?? 'Cerrar Sesión'),
        content: Text(loc?.logoutConfirm ?? '¿Estás seguro de que deseas salir?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc?.cancel ?? 'Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc?.logout ?? 'Salir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (mounted) {
        Fluttertoast.showToast(
          msg: loc?.logout ?? 'Sesión cerrada',
          backgroundColor: Colors.grey,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final settings = Provider.of<SettingsProvider>(context);

    // Mientras _screens no esté inicializado, mostramos un loader
    if (_gamesService == null || _screens == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.appTitle ?? 'Lengua Inga'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          if (_userRole != null)
            Chip(
              label: Text(
                _userRole!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: _getRoleColor(),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(loc, settings),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: loc?.words ?? 'Palabras',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.school),
            label: loc?.lessons ?? 'Lecciones',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.videogame_asset),
            label: loc?.games ?? 'Juegos',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.psychology),
            label: loc?.aiAssistant ?? 'IA',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.library_books),
            label: loc?.vocabulary ?? 'Vocabulario',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: loc?.profile ?? 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(AppLocalizations? loc, SettingsProvider settings) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.indigoAccent],
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                _getRoleIcon(),
                size: 40,
                color: Colors.indigo,
              ),
            ),
            accountName: Text(
              _userData?['nombre'] ?? 'Usuario',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(_userData?['email'] ?? ''),
          ),

          ListTile(
            leading: const Icon(Icons.book),
            title: Text(loc?.words ?? 'Palabras'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: Text(loc?.lessons ?? 'Lecciones'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.videogame_asset),
            title: Text(loc?.games ?? 'Juegos'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.psychology),
            title: Text(loc?.aiAssistant ?? 'Asistente IA'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: Text(loc?.vocabulary ?? 'Vocabulario'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 4);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(loc?.profile ?? 'Perfil'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 5);
            },
          ),

          const Divider(),

          ExpansionTile(
            leading: const Icon(Icons.language),
            title: Text(loc?.language ?? 'Idioma'),
            children: [
              RadioListTile<String>(
                title: const Text('Español'),
                value: 'es',
                groupValue: _currentLocale,
                onChanged: (value) {
                  if (value != null) _changeLanguage(value);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue: _currentLocale,
                onChanged: (value) {
                  if (value != null) _changeLanguage(value);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Inga Shimi'),
                value: 'inga',
                groupValue: _currentLocale,
                onChanged: (value) {
                  if (value != null) _changeLanguage(value);
                  Navigator.pop(context);
                },
              ),
            ],
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.info),
            title: Text(loc?.about ?? 'Acerca de'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: loc?.appTitle ?? 'Lengua Inga',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.language, size: 48),
                children: const [
                  Text(
                    'Plataforma educativa para la documentación y difusión de la lengua Inga',
                  ),
                ],
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(loc?.settings ?? 'Ajustes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              loc?.logout ?? 'Cerrar Sesión',
              style: const TextStyle(color: Colors.red),
            ),
            onTap: _handleLogout,
          ),

          // ⬇️ BLOQUE PARA ADMIN DENTRO DEL CHILDREN
          if (_userRole == 'Administrador') ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('Gestionar Oraciones'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GestionarOracionesScreen(
                      gamesService: _gamesService!,
                    ),
                  ),
                );
              },
            ),
          ],
          // ⬆️ FIN BLOQUE ADMIN
        ],
      ),
    );
}


  // Widget _buildDrawer(AppLocalizations? loc, SettingsProvider settings) {
  //   return Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [
  //         UserAccountsDrawerHeader(
  //           decoration: const BoxDecoration(
  //             gradient: LinearGradient(
  //               colors: [Colors.indigo, Colors.indigoAccent],
  //             ),
  //           ),
  //           currentAccountPicture: CircleAvatar(
  //             backgroundColor: Colors.white,
  //             child: Icon(
  //               _getRoleIcon(),
  //               size: 40,
  //               color: Colors.indigo,
  //             ),
  //           ),
  //           accountName: Text(
  //             _userData?['nombre'] ?? 'Usuario',
  //             style: const TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           accountEmail: Text(_userData?['email'] ?? ''),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.book),
  //           title: Text(loc?.words ?? 'Palabras'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             setState(() => _currentIndex = 0);
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.school),
  //           title: Text(loc?.lessons ?? 'Lecciones'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             setState(() => _currentIndex = 1);
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.videogame_asset),
  //           title: Text(loc?.games ?? 'Juegos'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             setState(() => _currentIndex = 2);
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.psychology),
  //           title: Text(loc?.aiAssistant ?? 'Asistente IA'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             setState(() => _currentIndex = 3);
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.library_books),
  //           title: Text(loc?.vocabulary ?? 'Vocabulario'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             setState(() => _currentIndex = 4);
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.person),
  //           title: Text(loc?.profile ?? 'Perfil'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             setState(() => _currentIndex = 5);
  //           },
  //         ),
  //         const Divider(),
  //         ExpansionTile(
  //           leading: const Icon(Icons.language),
  //           title: Text(loc?.language ?? 'Idioma'),
  //           children: [
  //             RadioListTile<String>(
  //               title: const Text('Español'),
  //               value: 'es',
  //               groupValue: _currentLocale,
  //               onChanged: (value) {
  //                 if (value != null) _changeLanguage(value);
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             RadioListTile<String>(
  //               title: const Text('English'),
  //               value: 'en',
  //               groupValue: _currentLocale,
  //               onChanged: (value) {
  //                 if (value != null) _changeLanguage(value);
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             RadioListTile<String>(
  //               title: const Text('Inga Shimi'),
  //               value: 'inga',
  //               groupValue: _currentLocale,
  //               onChanged: (value) {
  //                 if (value != null) _changeLanguage(value);
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         ),
  //         const Divider(),
  //         ListTile(
  //           leading: const Icon(Icons.info),
  //           title: Text(loc?.about ?? 'Acerca de'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             showAboutDialog(
  //               context: context,
  //               applicationName: loc?.appTitle ?? 'Lengua Inga',
  //               applicationVersion: '1.0.0',
  //               applicationIcon: const Icon(Icons.language, size: 48),
  //               children: const [
  //                 Text(
  //                     'Plataforma educativa para la documentación y difusión de la lengua Inga'),
  //               ],
  //             );
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.settings),
  //           title: Text(loc?.settings ?? 'Ajustes'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (_) => const SettingsScreen()),
  //             );
  //           },
  //         ),
  //         const Divider(),
  //         ListTile(
  //           leading: const Icon(Icons.logout, color: Colors.red),
  //           title: Text(
  //             loc?.logout ?? 'Cerrar Sesión',
  //             style: const TextStyle(color: Colors.red),
  //           ),
  //           onTap: _handleLogout,
  //         ),
  //       ],
        
  //     ),
      
  //     // ⬇️ AQUI PEGAS EL BLOQUE PARA ADMINISTRADORES
  //       if (_userRole == 'Administrador') ...[
  //         const Divider(),
  //         ListTile(
  //           leading: const Icon(Icons.edit_note),
  //           title: const Text('Gestionar Oraciones'),
  //           onTap: () {
  //             Navigator.pop(context);
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => GestionarOracionesScreen(
  //                   gamesService: _gamesService!,
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       ],  
  //       // ⬆️ ESTO VA AQUÍ
  //   );
    
  // }

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
}