import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Sección de Idioma
              _buildSectionHeader(
                icon: Icons.language,
                title: 'Idioma / Language',
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    _buildLanguageTile(
                      context,
                      settings,
                      'es',
                      'Español',
                      '🇪🇸',
                      'Idioma predeterminado',
                    ),
                    const Divider(height: 1),
                    _buildLanguageTile(
                      context,
                      settings,
                      'en',
                      'English',
                      '🇺🇸',
                      'Default language',
                    ),
                    const Divider(height: 1),
                    _buildLanguageTile(
                      context,
                      settings,
                      'quz',
                      'Inga Shimi',
                      '🌄',
                      'Lengua nativa',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Sección de Tema
              _buildSectionHeader(
                icon: Icons.palette,
                title: 'Tema / Theme',
                color: Colors.purple,
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    _buildThemeTile(
                      context,
                      settings,
                      AppThemeMode.light,
                      'Claro',
                      'Tema con fondo blanco',
                      Icons.light_mode,
                      Colors.orange,
                    ),
                    const Divider(height: 1),
                    _buildThemeTile(
                      context,
                      settings,
                      AppThemeMode.dark,
                      'Oscuro',
                      'Tema con fondo negro',
                      Icons.dark_mode,
                      Colors.indigo,
                    ),
                    const Divider(height: 1),
                    _buildThemeTile(
                      context,
                      settings,
                      AppThemeMode.background,
                      'Imagen de Fondo',
                      'Tema con imagen cultural',
                      Icons.image,
                      Colors.teal,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Vista Previa
              _buildSectionHeader(
                icon: Icons.preview,
                title: 'Vista Previa',
                color: Colors.green,
              ),
              const SizedBox(height: 8),
              _buildPreviewCard(context, settings),

              const SizedBox(height: 32),

              // Información
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, size: 48, color: Colors.blue.shade700),
                      const SizedBox(height: 12),
                      Text(
                        'Los cambios se aplican inmediatamente',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    SettingsProvider settings,
    String code,
    String name,
    String flag,
    String subtitle,
  ) {
    final isSelected = settings.locale.languageCode == code;
    
    return ListTile(
      leading: Text(
        flag,
        style: const TextStyle(fontSize: 32),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      selected: isSelected,
      selectedTileColor: Colors.blue.withOpacity(0.1),
      onTap: () async {
        await settings.changeLocale(code);
        Fluttertoast.showToast(
          msg: 'Idioma cambiado a $name',
          backgroundColor: Colors.green,
        );
      },
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    SettingsProvider settings,
    AppThemeMode mode,
    String name,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    final isSelected = settings.themeMode == mode;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      selected: isSelected,
      selectedTileColor: color.withOpacity(0.1),
      onTap: () async {
        await settings.changeTheme(mode);
        Fluttertoast.showToast(
          msg: 'Tema cambiado a $name',
          backgroundColor: Colors.green,
        );
      },
    );
  }

  Widget _buildPreviewCard(BuildContext context, SettingsProvider settings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ejemplo de Tarjeta',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Así se ve el tema seleccionado',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Esta es una vista previa del tema actual',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}