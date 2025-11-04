import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/palabra.dart';
import '../services/palabra_service.dart';

class VocabularioScreen extends StatefulWidget {
  const VocabularioScreen({super.key});

  @override
  State<VocabularioScreen> createState() => _VocabularioScreenState();
}

class _VocabularioScreenState extends State<VocabularioScreen> {
  final PalabraService _palabraService = PalabraService();
  List<Palabra> _todasLasPalabras = [];
  List<Palabra> _palabrasFiltradas = [];
  List<String> _categorias = ['Todas'];
  String _categoriaSeleccionada = 'Todas';
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPalabras();
  }

  Future<void> _loadPalabras() async {
    setState(() => _isLoading = true);
    try {
      final palabras = await _palabraService.getPalabras();
      
      // Extraer categorías únicas
      final categoriasSet = <String>{'Todas'};
      for (var palabra in palabras) {
        if (palabra.categoria != null && palabra.categoria!.isNotEmpty) {
          categoriasSet.add(palabra.categoria!);
        }
      }

      if (mounted) {
        setState(() {
          _todasLasPalabras = palabras;
          _palabrasFiltradas = palabras;
          _categorias = categoriasSet.toList()..sort();
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error al cargar vocabulario',
        backgroundColor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _filtrarPorCategoria(String categoria) {
    setState(() {
      _categoriaSeleccionada = categoria;
      if (categoria == 'Todas') {
        _palabrasFiltradas = _todasLasPalabras;
      } else {
        _palabrasFiltradas = _todasLasPalabras
            .where((p) => p.categoria == categoria)
            .toList();
      }
      _aplicarBusqueda();
    });
  }

  void _aplicarBusqueda() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        if (_categoriaSeleccionada == 'Todas') {
          _palabrasFiltradas = _todasLasPalabras;
        } else {
          _palabrasFiltradas = _todasLasPalabras
              .where((p) => p.categoria == _categoriaSeleccionada)
              .toList();
        }
      } else {
        _palabrasFiltradas = (_categoriaSeleccionada == 'Todas'
                ? _todasLasPalabras
                : _todasLasPalabras
                    .where((p) => p.categoria == _categoriaSeleccionada))
            .where((p) =>
                p.palabraInga.toLowerCase().contains(query) ||
                p.traduccionEspanol.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulario Inga'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar palabra...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _aplicarBusqueda();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (_) => _aplicarBusqueda(),
                  ),
                ),

                // Chips de categorías
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categorias.length,
                    itemBuilder: (context, index) {
                      final categoria = _categorias[index];
                      final isSelected = _categoriaSeleccionada == categoria;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(categoria),
                          selected: isSelected,
                          onSelected: (_) => _filtrarPorCategoria(categoria),
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: Colors.indigo,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // Contador de resultados
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_palabrasFiltradas.length} palabra${_palabrasFiltradas.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Lista de palabras
                Expanded(
                  child: _palabrasFiltradas.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No se encontraron palabras',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _palabrasFiltradas.length,
                          itemBuilder: (context, index) {
                            final palabra = _palabrasFiltradas[index];
                            return _buildPalabraCard(palabra);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildPalabraCard(Palabra palabra) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => _showPalabraDetail(palabra),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono de categoría
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getCategoryColor(palabra.categoria),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(palabra.categoria),
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      palabra.palabraInga,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      palabra.traduccionEspanol,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    if (palabra.categoria != null) ...[
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(
                          palabra.categoria!,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: _getCategoryColor(palabra.categoria)
                            .withOpacity(0.2),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Flecha
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showPalabraDetail(Palabra palabra) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicador
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Palabra principal
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(palabra.categoria),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getCategoryIcon(palabra.categoria),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        palabra.palabraInga,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      Text(
                        palabra.traduccionEspanol,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (palabra.categoria != null) ...[
              const SizedBox(height: 16),
              Chip(
                label: Text(palabra.categoria!),
                backgroundColor: _getCategoryColor(palabra.categoria)
                    .withOpacity(0.2),
              ),
            ],
            
            const SizedBox(height: 24),
            const Text(
              'Información adicional',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            if (palabra.audio != null)
              ListTile(
                leading: const Icon(Icons.volume_up, color: Colors.indigo),
                title: const Text('Audio disponible'),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    // TODO: Reproducir audio
                    Fluttertoast.showToast(
                      msg: 'Función de audio en desarrollo',
                      backgroundColor: Colors.orange,
                    );
                  },
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Botón cerrar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String? categoria) {
    switch (categoria?.toLowerCase()) {
      case 'animales':
        return Colors.green;
      case 'naturaleza':
        return Colors.teal;
      case 'comida':
        return Colors.orange;
      case 'familia':
        return Colors.pink;
      case 'números':
        return Colors.purple;
      case 'saludos':
        return Colors.blue;
      case 'verbos':
        return Colors.red;
      case 'colores':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String? categoria) {
    switch (categoria?.toLowerCase()) {
      case 'animales':
        return Icons.pets;
      case 'naturaleza':
        return Icons.park;
      case 'comida':
        return Icons.restaurant;
      case 'familia':
        return Icons.family_restroom;
      case 'números':
        return Icons.numbers;
      case 'saludos':
        return Icons.waving_hand;
      case 'verbos':
        return Icons.directions_run;
      case 'colores':
        return Icons.palette;
      default:
        return Icons.book;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}