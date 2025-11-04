import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app_lengua_inga/l10n/app_localizations.dart';
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
        msg: AppLocalizations.of(context)?.vocabularioScreenLoadingError ?? 'Error al cargar palabras',
        backgroundColor: Colors.red,
      );
    }
  }

  bool _canEdit() {
    return _userRole == 'Administrador' || _userRole == 'Profesor';
  }

  Future<void> _showPalabraDialog({Palabra? palabra}) async {
    final loc = AppLocalizations.of(context);
    final isEdit = palabra != null;
    final palabraIngaController = TextEditingController(text: palabra?.palabraInga ?? '');
    final traduccionController = TextEditingController(text: palabra?.traduccionEspanol ?? '');
    final categoriaController = TextEditingController(text: palabra?.categoria ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? loc?.editWord ?? 'Editar Palabra' : loc?.newWord ?? 'Nueva Palabra'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: palabraIngaController,
                decoration: InputDecoration(
                  labelText: loc?.wordInInga ?? 'Palabra en Inga',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: traduccionController,
                decoration: InputDecoration(
                  labelText: loc?.translation ?? 'Traducción al Español',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: categoriaController,
                decoration: InputDecoration(
                  labelText: loc?.category ?? 'Categoría',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc?.cancel ?? 'Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (palabraIngaController.text.isEmpty || traduccionController.text.isEmpty) {
                Fluttertoast.showToast(
                  msg: loc?.completeFieldsToast ?? 'Complete campos',
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
                  await _palabraService.updatePalabra(palabra!.idPalabra!, newPalabra);
                  Fluttertoast.showToast(
                    msg: loc?.wordUpdatedToast ?? 'Palabra actualizada',
                    backgroundColor: Colors.green,
                  );
                } else {
                  await _palabraService.createPalabra(newPalabra);
                  Fluttertoast.showToast(
                    msg: loc?.wordCreatedToast ?? 'Palabra creada',
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
            child: Text(isEdit ? loc?.updateWordButton ?? 'Actualizar' : loc?.createWordButton ?? 'Crear'),
          ),
        ],
      ),
    );

    if (result == true) {
      _loadPalabras();
    }
  }

  Future<void> _deletePalabra(Palabra palabra) async {
    final loc = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc?.deleteWordButton ?? 'Eliminar Palabra'),
        content: Text(
          loc!.deleteWordConfirm(palabra.palabraInga),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc?.cancel ?? 'Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(loc?.deleteWordButton ?? 'Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _palabraService.deletePalabra(palabra.idPalabra!);
        Fluttertoast.showToast(
          msg: loc?.wordDeletedToast ?? 'Palabra eliminada',
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
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.palabrasScreenTitle ?? 'Palabras'),
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPalabras,
              child: _palabras.isEmpty
                  ? Center(
                      child: Text(
                        loc?.noWordsMessage ?? 'No hay palabras registradas',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                              ],
                            ),
                            trailing: _canEdit()
                                ? PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            const Icon(Icons.edit, size: 20),
                                            const SizedBox(width: 8),
                                            Text(loc?.editWord ?? 'Editar'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            const Icon(Icons.delete, size: 20, color: Colors.red),
                                            const SizedBox(width: 8),
                                            Text(
                                              loc?.deleteWordButton ?? 'Eliminar',
                                              style: const TextStyle(color: Colors.red),
                                            ),
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
