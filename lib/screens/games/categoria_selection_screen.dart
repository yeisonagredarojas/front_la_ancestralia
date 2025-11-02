import 'package:flutter/material.dart';
import '../../services/games_service.dart';
import 'kawai_suti_screen.dart';

class CategoriaSelectionScreen extends StatefulWidget {
  final int idJuego;
  final String nivelDificultad;
  final GamesService gamesService;

  const CategoriaSelectionScreen({
    Key? key,
    required this.idJuego,
    required this.nivelDificultad,
    required this.gamesService,
  }) : super(key: key);

  @override
  State<CategoriaSelectionScreen> createState() => _CategoriaSelectionScreenState();
}

class _CategoriaSelectionScreenState extends State<CategoriaSelectionScreen> {
  List<String> _categorias = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    try {
      final categorias = await widget.gamesService.obtenerCategorias();
      setState(() {
        _categorias = categorias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar categorías: $e';
        _isLoading = false;
      });
    }
  }

  Color _getCategoriaColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }

  IconData _getCategoriaIcon(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'saludos':
        return Icons.waving_hand;
      case 'cuerpo':
        return Icons.accessibility_new;
      case 'números':
      case 'numeros':
        return Icons.numbers;
      case 'alimentos':
        return Icons.restaurant;
      case 'animales':
        return Icons.pets;
      case 'familia':
        return Icons.family_restroom;
      case 'verbos':
        return Icons.directions_run;
      case 'colores':
        return Icons.palette;
      case 'casa - cocina':
      case 'cocina':
        return Icons.kitchen;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona una Categoría'),
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _cargarCategorias,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _categorias.isEmpty
                  ? const Center(child: Text('No hay categorías disponibles'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _categorias.length,
                      itemBuilder: (context, index) {
                        final categoria = _categorias[index];
                        final color = _getCategoriaColor(index);
                        final icon = _getCategoriaIcon(categoria);

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => KawaiSutiScreen(
                                    idJuego: widget.idJuego,
                                    categoria: categoria,
                                    nivelDificultad: widget.nivelDificultad,
                                    gamesService: widget.gamesService,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  // colors: [color.shade400, color.shade700],
                                  colors: [color.withOpacity(0.6), color],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    icon,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    categoria,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}