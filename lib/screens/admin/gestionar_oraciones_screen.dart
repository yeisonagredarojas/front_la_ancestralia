import 'package:flutter/material.dart';
import '../../services/games_service.dart';

class GestionarOracionesScreen extends StatefulWidget {
  final GamesService gamesService;

  const GestionarOracionesScreen({
    Key? key,
    required this.gamesService,
  }) : super(key: key);

  @override
  State<GestionarOracionesScreen> createState() => _GestionarOracionesScreenState();
}

class _GestionarOracionesScreenState extends State<GestionarOracionesScreen> {
  List<dynamic> _oraciones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarOraciones();
  }

  Future<void> _cargarOraciones() async {
    try {
      final oraciones = await widget.gamesService.listarOraciones();
      setState(() {
        _oraciones = oraciones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _eliminarOracion(int idOracion) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de eliminar esta oración?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await widget.gamesService.eliminarOracion(idOracion);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Oración eliminada')),
        );
        _cargarOraciones();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _mostrarFormularioCrear() {
    // Implementar formulario modal para crear
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FormularioOracion(
        gamesService: widget.gamesService,
        onGuardado: _cargarOraciones,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Oraciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _mostrarFormularioCrear,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _oraciones.length,
              itemBuilder: (context, index) {
                final oracion = _oraciones[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(oracion['texto_espanol'] ?? ''),
                    subtitle: Text('Inga: ${oracion['texto_inga']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminarOracion(oracion['id_oracion']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _FormularioOracion extends StatefulWidget {
  final GamesService gamesService;
  final VoidCallback onGuardado;

  const _FormularioOracion({
    required this.gamesService,
    required this.onGuardado,
  });

  @override
  State<_FormularioOracion> createState() => _FormularioOracionState();
}

class _FormularioOracionState extends State<_FormularioOracion> {
  final _formKey = GlobalKey<FormState>();
  final _textoEspanolController = TextEditingController();
  final _textoInglesController = TextEditingController();
  final _textoIngaController = TextEditingController();
  final _palabraIngaController = TextEditingController();
  final _palabraEspanolController = TextEditingController();
  final _palabraInglesController = TextEditingController();
  String _dificultad = 'medio';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nueva Oración', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _textoEspanolController,
                decoration: const InputDecoration(labelText: 'Texto en Español'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _textoInglesController,
                decoration: const InputDecoration(labelText: 'Texto en Inglés'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _textoIngaController,
                decoration: const InputDecoration(labelText: 'Texto en Inga'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _palabraIngaController,
                decoration: const InputDecoration(labelText: 'Palabra Clave (Inga)'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _palabraEspanolController,
                decoration: const InputDecoration(labelText: 'Palabra Clave (Español)'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _palabraInglesController,
                decoration: const InputDecoration(labelText: 'Palabra Clave (Inglés)'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _dificultad,
                decoration: const InputDecoration(labelText: 'Dificultad'),
                items: const [
                  DropdownMenuItem(value: 'facil', child: Text('Fácil')),
                  DropdownMenuItem(value: 'medio', child: Text('Medio')),
                  DropdownMenuItem(value: 'dificil', child: Text('Difícil')),
                ],
                onChanged: (v) => setState(() => _dificultad = v!),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _guardar,
                    child: const Text('Guardar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await widget.gamesService.crearOracion({
        'texto_espanol': _textoEspanolController.text,
        'texto_ingles': _textoInglesController.text,
        'texto_inga': _textoIngaController.text,
        'palabra_clave_inga': _palabraIngaController.text,
        'palabra_clave_espanol': _palabraEspanolController.text,
        'palabra_clave_ingles': _palabraInglesController.text,
        'nivel_dificultad': _dificultad,
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Oración creada exitosamente')),
        );
        widget.onGuardado();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _textoEspanolController.dispose();
    _textoInglesController.dispose();
    _textoIngaController.dispose();
    _palabraIngaController.dispose();
    _palabraEspanolController.dispose();
    _palabraInglesController.dispose();
    super.dispose();
  }
}