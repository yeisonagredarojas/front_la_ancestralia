import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/leccion.dart';
import '../models/palabra.dart';
import '../services/leccion_service.dart';
import '../services/palabra_service.dart';
import '../services/auth_service.dart';

class LeccionesScreen extends StatefulWidget {
  const LeccionesScreen({super.key});

  @override
  State<LeccionesScreen> createState() => _LeccionesScreenState();
}

class _LeccionesScreenState extends State<LeccionesScreen> {
  final LeccionService _leccionService = LeccionService();
  final PalabraService _palabraService = PalabraService();
  final AuthService _authService = AuthService();
  List<Leccion> _lecciones = [];
  bool _isLoading = true;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _userRole = await _authService.getUserRole();
    await _loadLecciones();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadLecciones() async {
    try {
      final lecciones = await _leccionService.getLecciones();
      if (mounted) {
        setState(() => _lecciones = lecciones);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al cargar lecciones',
        backgroundColor: Colors.red,
      );
    }
  }

  bool _canEdit() {
    return _userRole == 'Administrador' || _userRole == 'Profesor';
  }

  Future<void> _showLeccionDialog({Leccion? leccion}) async {
    final isEdit = leccion != null;
    final tituloController = TextEditingController(text: leccion?.titulo ?? '');
    final descripcionController = TextEditingController(text: leccion?.descripcion ?? '');
    List<int> selectedPalabrasIds = leccion?.palabras?.map((p) => p.idPalabra!).toList() ?? [];

    // Cargar palabras disponibles
    final palabrasDisponibles = await _palabraService.getPalabras();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Editar Lección' : 'Nueva Lección'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descripcionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Palabras de la lección:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: palabrasDisponibles.length,
                      itemBuilder: (context, index) {
                        final palabra = palabrasDisponibles[index];
                        final isSelected = selectedPalabrasIds.contains(palabra.idPalabra);
                        return CheckboxListTile(
                          title: Text(palabra.palabraInga),
                          subtitle: Text(palabra.traduccionEspanol),
                          value: isSelected,
                          onChanged: (value) {
                            setDialogState(() {
                              if (value == true) {
                                selectedPalabrasIds.add(palabra.idPalabra!);
                              } else {
                                selectedPalabrasIds.remove(palabra.idPalabra);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (tituloController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Ingrese un título',
                    backgroundColor: Colors.orange,
                  );
                  return;
                }

                final newLeccion = Leccion(
                  titulo: tituloController.text,
                  descripcion: descripcionController.text.isEmpty ? null : descripcionController.text,
                  idPalabras: selectedPalabrasIds,
                );

                try {
                  if (isEdit) {
                    await _leccionService.updateLeccion(leccion.idLeccion!, newLeccion);
                    Fluttertoast.showToast(
                      msg: 'Lección actualizada',
                      backgroundColor: Colors.green,
                    );
                  } else {
                    await _leccionService.createLeccion(newLeccion);
                    Fluttertoast.showToast(
                      msg: 'Lección creada',
                      backgroundColor: Colors.green,
                    );
                  }
                  Navigator.pop(context, true);
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: e.toString(),
                    backgroundColor: Colors.red,
                  );
                }
              },
              child: Text(isEdit ? 'Actualizar' : 'Crear'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      _loadLecciones();
    }
  }

  Future<void> _deleteLeccion(Leccion leccion) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Lección'),
        content: Text('¿Eliminar "${leccion.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _leccionService.deleteLeccion(leccion.idLeccion!);
        Fluttertoast.showToast(
          msg: 'Lección eliminada',
          backgroundColor: Colors.green,
        );
        _loadLecciones();
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
        );
      }
    }
  }

  void _showLeccionDetail(Leccion leccion) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                leccion.titulo,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (leccion.descripcion != null) ...[
                const SizedBox(height: 8),
                Text(
                  leccion.descripcion!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 16),
              const Divider(),
              const Text(
                'Palabras en esta lección:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: leccion.palabras == null || leccion.palabras!.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay palabras en esta lección',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: leccion.palabras!.length,
                        itemBuilder: (context, index) {
                          final palabra = leccion.palabras![index];
                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(palabra.palabraInga),
                              subtitle: Text(palabra.traduccionEspanol),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadLecciones,
              child: _lecciones.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay lecciones registradas',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _lecciones.length,
                      itemBuilder: (context, index) {
                        final leccion = _lecciones[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: ListTile(
                            onTap: () => _showLeccionDetail(leccion),
                            leading: const CircleAvatar(
                              backgroundColor: Colors.indigo,
                              child: Icon(Icons.school, color: Colors.white),
                            ),
                            title: Text(
                              leccion.titulo,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (leccion.descripcion != null)
                                  Text(
                                    leccion.descripcion!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                Text(
                                  '${leccion.palabras?.length ?? 0} palabras',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: _canEdit()
                                ? PopupMenuButton(
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 20),
                                            SizedBox(width: 8),
                                            Text('Editar'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, size: 20, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('Eliminar', style: TextStyle(color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        _showLeccionDialog(leccion: leccion);
                                      } else if (value == 'delete') {
                                        _deleteLeccion(leccion);
                                      }
                                    },
                                  )
                                : const Icon(Icons.arrow_forward_ios, size: 16),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: _canEdit()
          ? FloatingActionButton(
              onPressed: () => _showLeccionDialog(),
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}