import 'package:flutter/material.dart';
import '../../models/game_models.dart';
import '../../services/games_service.dart';
import 'emparejar_palabras_screen.dart';
import 'categoria_selection_screen.dart';  // ← AGREGAR

class GamesListScreen extends StatefulWidget {
  final GamesService gamesService;

  const GamesListScreen({
    Key? key,
    required this.gamesService,
  }) : super(key: key);

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen> {
  List<Juego> _juegos = [];
  List<ProgresoJuego> _progresos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }
  /*
  Future<void> _cargarDatos() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final juegos = await widget.gamesService.obtenerJuegos();
      final progresos = await widget.gamesService.obtenerProgreso();

      setState(() {
        _juegos = juegos;
        _progresos = progresos is List<ProgresoJuego> ? progresos : [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar los juegos: $e';
        _isLoading = false;
      });
    }
  }*/

  Future<void> _cargarDatos() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final juegos = await widget.gamesService.obtenerJuegos();
      
      // Intentar obtener progreso, pero no fallar si no existe
      List<ProgresoJuego> progresos = [];
      try {
        final result = await widget.gamesService.obtenerProgreso();
        if (result is List<ProgresoJuego>) {
          progresos = result;
        }
      } catch (e) {
        // Usuario nuevo sin progreso, está bien
        print('No hay progreso aún (usuario nuevo): $e');
        progresos = [];
      }

      setState(() {
        _juegos = juegos;
        _progresos = progresos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar los juegos: $e';
        _isLoading = false;
      });
    }
  }

  ProgresoJuego? _obtenerProgresoPorJuego(int idJuego) {
    try {
      return _progresos.firstWhere((p) => p.idJuego == idJuego);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juegos Inga'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : _juegos.isEmpty
                  ? _buildEmpty()
                  : _buildGamesList(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _cargarDatos,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.games_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No hay juegos disponibles',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesList() {
    return RefreshIndicator(
      onRefresh: _cargarDatos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _juegos.length,
        itemBuilder: (context, index) {
          final juego = _juegos[index];
          final progreso = _obtenerProgresoPorJuego(juego.idJuego);
          return _buildGameCard(juego, progreso);
        },
      ),
    );
  }

  Widget _buildGameCard(Juego juego, ProgresoJuego? progreso) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _mostrarOpcionesJuego(juego),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: _getGradientColors(juego.tipoJuego),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconoPorTipo(juego.tipoJuego),
                      size: 32,
                      color: _getColorPorTipo(juego.tipoJuego),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          juego.nombre,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (juego.descripcion != null)
                          Text(
                            juego.descripcion!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.play_circle_filled,
                    color: Colors.white,
                    size: 32,
                  ),
                ],
              ),
              if (progreso != null) ...[
                const SizedBox(height: 16),
                const Divider(color: Colors.white54),
                const SizedBox(height: 12),
                _buildProgresoInfo(progreso),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgresoInfo(ProgresoJuego progreso) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildProgresoItem(
              icon: Icons.emoji_events,
              label: 'Mejor',
              value: '${progreso.mejorPuntuacion}',
            ),
            _buildProgresoItem(
              icon: Icons.gamepad,
              label: 'Jugadas',
              value: '${progreso.partidasJugadas}',
            ),
            _buildProgresoItem(
              icon: Icons.trending_up,
              label: 'Nivel',
              value: _getNivelEmoji(progreso.nivelActual),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progreso.porcentajeAciertos / 100,
          backgroundColor: Colors.white30,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
        const SizedBox(height: 4),
        Text(
          'Precisión: ${progreso.porcentajeAciertos.toStringAsFixed(1)}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProgresoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  String _getNivelEmoji(String nivel) {
    switch (nivel) {
      case 'principiante':
        return '🌱';
      case 'intermedio':
        return '🌿';
      case 'avanzado':
        return '🌳';
      case 'experto':
        return '🏆';
      default:
        return '⭐';
    }
  }

  List<Color> _getGradientColors(String tipoJuego) {
    switch (tipoJuego) {
      case 'emparejar':
        return [Colors.purple.shade400, Colors.purple.shade700];
      case 'completar_frase':
        return [Colors.blue.shade400, Colors.blue.shade700];
      case 'pronunciacion':
        return [Colors.green.shade400, Colors.green.shade700];
      default:
        return [Colors.orange.shade400, Colors.orange.shade700];
    }
  }

  IconData _getIconoPorTipo(String tipoJuego) {
    switch (tipoJuego) {
      case 'emparejar':
        return Icons.compare_arrows;
      case 'completar_frase':
        return Icons.edit_note;
      case 'pronunciacion':
        return Icons.record_voice_over;
      default:
        return Icons.games;
    }
  }

  Color _getColorPorTipo(String tipoJuego) {
    switch (tipoJuego) {
      case 'emparejar':
        return Colors.purple;
      case 'completar_frase':
        return Colors.blue;
      case 'pronunciacion':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  void _mostrarOpcionesJuego(Juego juego) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildOpcionesJuego(juego),
    );
  }

  Widget _buildOpcionesJuego(Juego juego) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                _getIconoPorTipo(juego.tipoJuego),
                size: 32,
                color: _getColorPorTipo(juego.tipoJuego),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  juego.nombre,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (juego.descripcion != null) ...[
            const SizedBox(height: 12),
            Text(
              juego.descripcion!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Text(
            'Selecciona dificultad:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _buildBotonDificultad(
            juego: juego,
            nivel: 'facil',
            label: 'Fácil 😊',
            descripcion: '4 palabras',
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          _buildBotonDificultad(
            juego: juego,
            nivel: 'medio',
            label: 'Medio 🤔',
            descripcion: '6 palabras',
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          _buildBotonDificultad(
            juego: juego,
            nivel: 'dificil',
            label: 'Difícil 🔥',
            descripcion: '8 palabras',
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonDificultad({
    required Juego juego,
    required String nivel,
    required String label,
    required String descripcion,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        _iniciarJuego(juego, nivel);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            descripcion,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  // void _iniciarJuego(Juego juego, String nivel) {
  //   if (juego.tipoJuego == 'emparejar') {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => EmparejarPalabrasScreen(
  //           idJuego: juego.idJuego,
  //           nivelDificultad: nivel,
  //           gamesService: widget.gamesService,
  //         ),
  //       ),
  //     ).then((_) => _cargarDatos()); // Recargar al volver
  //   } else {
  //     // Otros juegos próximamente
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Este juego estará disponible próximamente'),
  //       ),
  //     );
  //   }
  // }

  // void _iniciarJuego(Juego juego, String nivel) {
  //   if (juego.tipoJuego == 'emparejar') {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => EmparejarPalabrasScreen(
  //           idJuego: juego.idJuego,
  //           nivelDificultad: nivel,
  //           gamesService: widget.gamesService,
  //         ),
  //       ),
  //     ).then((_) => _cargarDatos());
  //   } else if (juego.tipoJuego == 'seleccionar_imagen') {  // ← AGREGAR ESTO
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CategoriaSelectionScreen(
  //           idJuego: juego.idJuego,
  //           nivelDificultad: nivel,
  //           gamesService: widget.gamesService,
  //         ),
  //       ),
  //     ).then((_) => _cargarDatos());
  //   } else {
  //     // Otros juegos próximamente
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Este juego estará disponible próximamente'),
  //       ),
  //     );
  //   }
  // }

  void _iniciarJuego(Juego juego, String nivel) {
    print('🎮 Iniciando juego: ${juego.nombre}');
    print('📋 Tipo: ${juego.tipoJuego}');
    
    if (juego.tipoJuego == 'emparejar') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmparejarPalabrasScreen(
            idJuego: juego.idJuego,
            nivelDificultad: nivel,
            gamesService: widget.gamesService,
          ),
        ),
      ).then((_) => _cargarDatos());
    } else if (juego.tipoJuego == 'seleccionar_imagen') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoriaSelectionScreen(
            idJuego: juego.idJuego,
            nivelDificultad: nivel,
            gamesService: widget.gamesService,
          ),
        ),
      ).then((_) => _cargarDatos());
    } else if (juego.tipoJuego == 'completar_frase') {
      // Por ahora redirigir a Kawai Suti o mostrar mensaje
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este juego estará disponible próximamente'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      print('⚠️ Tipo de juego no reconocido: ${juego.tipoJuego}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este juego estará disponible próximamente'),
        ),
      );
    }
  }
}