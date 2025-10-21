import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/palabra.dart';
import '../services/palabra_service.dart';
import '../services/auth_service.dart';

class PalabrasScreen extends StatefulWidget {
  const PalabrasScreen({super.key});

  @override
  State<PalabrasScreen> createState() => _PalabrasScreenState();
}

class _PalabrasScreenState extends State<PalabrasScreen> {
  final PalabraService _palabraService = PalabraService();
  final AuthService _authService = AuthService();
  List<Palabra> _palabras = [];
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
    await _loadPalabras();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadPalabras() async {
    try {
      final palabras = await _palabraService.getPalabras();
      if (mounted) {
        setState(() => _palabras = palabras);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al cargar palabras',
        backgroundColor: Colors.red,
      );
    }
  }

  bool _canEdit() {
    return _userRole == 'Administrador' || _userRole == 'Profesor';
  }

  Future<void> _showPalabraDialog({Palabra? palabra}) async {
    final isEdit = palabra != null;
    final palabraIngaController = TextEditingController(text: palabra?.palabraInga ?? '');
    final traduccionController = TextEditingController(text: palabra?.traduccionEspanol ?? '');
    final categoriaController = TextEditingController(text: palabra?.categoria ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Editar Palabra' : 'Nueva Palabra'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: palabraIngaController,
                decoration: const InputDecoration(
                  labelText: 'Palabra en Inga',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: traduccionController,
                decoration: const InputDecoration(
                  labelText: 'Traducción al Español',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoriaController,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (palabraIngaController.text.isEmpty || traduccionController.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: 'Complete los campos obligatorios',
                  backgroundColor: Colors.orange,
                );
                return;
              }

              final newPalabra = Palabra(
                palabraInga: palabraIngaController.text,
                traduccionEspanol: traduccionController.text,
                categoria: categoriaController.text.isEmpty ? null : categoriaController.text,
              );

              try {
                if (isEdit) {
                  await _palabraService.updatePalabra(palabra.idPalabra!, newPalabra);
                  Fluttertoast.showToast(
                    msg: 'Palabra actualizada',
                    backgroundColor: Colors.green,
                  );
                } else {
                  await _palabraService.createPalabra(newPalabra);
                  Fluttertoast.showToast(
                    msg: 'Palabra creada',
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
    );

    if (result == true) {
      _loadPalabras();
    }
  }

  Future<void> _deletePalabra(Palabra palabra) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Palabra'),
        content: Text('¿Eliminar "${palabra.palabraInga}"?'),
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
        await _palabraService.deletePalabra(palabra.idPalabra!);
        Fluttertoast.showToast(
          msg: 'Palabra eliminada',
          backgroundColor: Colors.green,
        );
        _loadPalabras();
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPalabras,
              child: _palabras.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay palabras registradas',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _palabras.length,
                      itemBuilder: (context, index) {
                        final palabra = _palabras[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo,
                              child: Text(
                                palabra.palabraInga[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              palabra.palabraInga,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(palabra.traduccionEspanol),
                                if (palabra.categoria != null)
                                  Text(
                                    palabra.categoria!,
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
                                        _showPalabraDialog(palabra: palabra);
                                      } else if (value == 'delete') {
                                        _deletePalabra(palabra);
                                      }
                                    },
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: _canEdit()
          ? FloatingActionButton(
              onPressed: () => _showPalabraDialog(),
              backgroundColor: Colors.indigo,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}