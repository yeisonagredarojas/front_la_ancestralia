import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/game_models.dart';
import '../../services/games_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EmparejarPalabrasScreen extends StatefulWidget {
  final int idJuego;
  final int? idLeccion;
  final String nivelDificultad;
  final GamesService gamesService;

  const EmparejarPalabrasScreen({
    Key? key,
    required this.idJuego,
    this.idLeccion,
    required this.nivelDificultad,
    required this.gamesService,
  }) : super(key: key);

  @override
  State<EmparejarPalabrasScreen> createState() => _EmparejarPalabrasScreenState();
}

class _EmparejarPalabrasScreenState extends State<EmparejarPalabrasScreen> with TickerProviderStateMixin {
  List<PalabraJuego> _palabras = [];
  List<String> _columnIzquierda = [];
  List<String> _columnDerecha = [];
  Map<int, int> _emparejamientos = {}; // Índice izquierda -> índice derecha
  
  int? _selectedIzquierda;
  int? _selectedDerecha;
  
  int _puntuacion = 0;
  int _aciertos = 0;
  int _errores = 0;
  int _tiempoSegundos = 0;
  Timer? _timer;
  
  Partida? _partidaActual;
  bool _isLoading = true;
  bool _juegoCompletado = false;

  String _idiomaActual = 'es';
  
  late AnimationController _successController;
  late AnimationController _errorController;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _errorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // _iniciarJuego();
     _inicializarJuego();  // ← CAMBIAR nombre del método
  }
  // ← NUEVO MÉTODO
  Future<void> _inicializarJuego() async {
    await _cargarIdioma();  // Primero cargar idioma
    await _verificarIdioma();  // ← Debug
    await _iniciarJuego();  // Luego iniciar juego
  }
  // ← AGREGAR ESTE MÉTODO
  Future<void> _cargarIdioma() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'es';
    
    setState(() {
      _idiomaActual = languageCode;
    });
    
    print('🌍 Idioma cargado: $_idiomaActual');
    print('🔑 Clave usada: language_code');
  }

  Future<void> _verificarIdioma() async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString('language_code');
    print('🔍 DEBUG - Locale en SharedPreferences: $locale');
    print('🔍 DEBUG - _idiomaActual en State: $_idiomaActual');
  }

  
  @override
  void dispose() {
    _timer?.cancel();
    _successController.dispose();
    _errorController.dispose();
    super.dispose();
  }

  Future<void> _iniciarJuego() async {
    try {
      print('🎮 Iniciando juego...');
      
      // Crear partida
      print('📝 Creando partida...');
      _partidaActual = await widget.gamesService.crearPartida(
        idJuego: widget.idJuego,
        idLeccion: widget.idLeccion,
        nivelDificultad: widget.nivelDificultad,
      );
      print('✅ Partida creada: ${_partidaActual?.idPartida}');

      // Obtener palabras
      final cantidad = _getCantidadPorDificultad();
      print('📚 Obteniendo $cantidad palabras...');
      print('🔍 id_leccion: ${widget.idLeccion}');
      print('🌍 idioma: $_idiomaActual');  // ← LOG
      
      _palabras = await widget.gamesService.obtenerPalabrasParaJuego(
        idLeccion: widget.idLeccion,
        cantidad: cantidad,
        idioma: _idiomaActual,  // ← PASAR IDIOMA
      );
      print('✅ Palabras obtenidas: ${_palabras.length}');

      // Preparar columnas
      _columnIzquierda = _palabras.map((p) => p.palabraInga).toList();
      _columnDerecha = _palabras.map((p) => p.traduccionEspanol).toList()..shuffle();

      // Iniciar cronómetro
      _iniciarCronometro();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error completo: $e');
      _mostrarError('Error al iniciar el juego: $e');
    }
  }

  int _getCantidadPorDificultad() {
    switch (widget.nivelDificultad) {
      case 'facil':
        return 4;
      case 'medio':
        return 6;
      case 'dificil':
        return 8;
      default:
        return 6;
    }
  }

  void _iniciarCronometro() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _tiempoSegundos++;
      });
    });
  }

  void _onTapIzquierda(int index) {
    if (_emparejamientos.containsKey(index)) return;

    setState(() {
      _selectedIzquierda = index;
    });

    if (_selectedDerecha != null) {
      _verificarEmparejamiento();
    }
  }

  void _onTapDerecha(int index) {
    if (_emparejamientos.containsValue(index)) return;

    setState(() {
      _selectedDerecha = index;
    });

    if (_selectedIzquierda != null) {
      _verificarEmparejamiento();
    }
  }

  void _verificarEmparejamiento() {
    final palabraIzq = _columnIzquierda[_selectedIzquierda!];
    final palabraDer = _columnDerecha[_selectedDerecha!];

    final palabraCorrecta = _palabras.firstWhere(
      (p) => p.palabraInga == palabraIzq,
    );

    if (palabraCorrecta.traduccionEspanol == palabraDer) {
      // ¡Acierto!
      _successController.forward().then((_) => _successController.reset());
      
      setState(() {
        _emparejamientos[_selectedIzquierda!] = _selectedDerecha!;
        _aciertos++;
        _puntuacion += _getPuntosPorDificultad();
        _selectedIzquierda = null;
        _selectedDerecha = null;
      });

      _reproducirSonido('acierto');

      // Verificar si completó el juego
      if (_emparejamientos.length == _palabras.length) {
        _finalizarJuego();
      }
    } else {
      // Error
      _errorController.forward().then((_) => _errorController.reset());
      
      setState(() {
        _errores++;
        _puntuacion = (_puntuacion - 5).clamp(0, 999999);
        _selectedIzquierda = null;
        _selectedDerecha = null;
      });

      _reproducirSonido('error');
    }
  }

  int _getPuntosPorDificultad() {
    switch (widget.nivelDificultad) {
      case 'facil':
        return 10;
      case 'medio':
        return 15;
      case 'dificil':
        return 20;
      default:
        return 10;
    }
  }

  void _reproducirSonido(String tipo) {
    // TODO: Implementar reproducción de sonidos
    // Usar audioplayers package
  }

  Future<void> _finalizarJuego() async {
    _timer?.cancel();
    
    setState(() {
      _juegoCompletado = true;
    });

    if (_partidaActual != null) {
      try {
        final finalizarDto = FinalizarPartidaDto(
          puntuacion: _puntuacion,
          aciertos: _aciertos,
          errores: _errores,
          tiempoSegundos: _tiempoSegundos,
          completado: true,
          detalles: {
            'palabras_usadas': _palabras.map((p) => p.idPalabra).toList(),
          },
        );

        await widget.gamesService.finalizarPartida(
          _partidaActual!.idPartida!,
          finalizarDto,
        );

        _mostrarDialogoResultados();
      } catch (e) {
        _mostrarError('Error al guardar resultados: $e');
      }
    }
  }

  void _mostrarDialogoResultados() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          '¡Juego Completado! 🎉',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildResultadoItem(
              icon: Icons.stars,
              label: 'Puntuación',
              value: '$_puntuacion',
              color: Colors.amber,
            ),
            _buildResultadoItem(
              icon: Icons.check_circle,
              label: 'Aciertos',
              value: '$_aciertos',
              color: Colors.green,
            ),
            _buildResultadoItem(
              icon: Icons.cancel,
              label: 'Errores',
              value: '$_errores',
              color: Colors.red,
            ),
            _buildResultadoItem(
              icon: Icons.timer,
              label: 'Tiempo',
              value: _formatearTiempo(_tiempoSegundos),
              color: Colors.blue,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Salir'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _reiniciarJuego();
            },
            child: const Text('Jugar de nuevo'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultadoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _reiniciarJuego() {
    setState(() {
      _emparejamientos.clear();
      _selectedIzquierda = null;
      _selectedDerecha = null;
      _puntuacion = 0;
      _aciertos = 0;
      _errores = 0;
      _tiempoSegundos = 0;
      _juegoCompletado = false;
      _isLoading = true;
    });
    _iniciarJuego();
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _formatearTiempo(int segundos) {
    final minutos = segundos ~/ 60;
    final segs = segundos % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emparejar Palabras'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(Icons.timer, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    _formatearTiempo(_tiempoSegundos),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildScoreBar(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildColumnaIzquierda(),
                      ),
                      Container(
                        width: 2,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: _buildColumnaDerecha(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildScoreBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreItem(
            icon: Icons.stars,
            label: 'Puntos',
            value: '$_puntuacion',
            color: Colors.amber,
          ),
          _buildScoreItem(
            icon: Icons.check_circle,
            label: 'Aciertos',
            value: '$_aciertos',
            color: Colors.green,
          ),
          _buildScoreItem(
            icon: Icons.cancel,
            label: 'Errores',
            value: '$_errores',
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildColumnaIzquierda() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _columnIzquierda.length,
      itemBuilder: (context, index) {
        final isEmparejado = _emparejamientos.containsKey(index);
        final isSelected = _selectedIzquierda == index;

        return AnimatedBuilder(
          animation: isSelected && !isEmparejado ? _errorController : _successController,
          builder: (context, child) {
            return Transform.translate(
              offset: isSelected && !isEmparejado
                  ? Offset(_errorController.value * 10 * (index % 2 == 0 ? 1 : -1), 0)
                  : Offset.zero,
              child: child,
            );
          },
          child: GestureDetector(
            onTap: isEmparejado ? null : () => _onTapIzquierda(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isEmparejado
                    ? Colors.green.shade100
                    : isSelected
                        ? Colors.blue.shade100
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isEmparejado
                      ? Colors.green
                      : isSelected
                          ? Colors.blue
                          : Colors.grey.shade300,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _columnIzquierda[index],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isEmparejado ? Colors.green.shade800 : Colors.black87,
                  decoration: isEmparejado ? TextDecoration.lineThrough : null,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildColumnaDerecha() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _columnDerecha.length,
      itemBuilder: (context, index) {
        final isEmparejado = _emparejamientos.containsValue(index);
        final isSelected = _selectedDerecha == index;

        return GestureDetector(
          onTap: isEmparejado ? null : () => _onTapDerecha(index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isEmparejado
                  ? Colors.green.shade100
                  : isSelected
                      ? Colors.orange.shade100
                      : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isEmparejado
                    ? Colors.green
                    : isSelected
                        ? Colors.orange
                        : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              _columnDerecha[index],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isEmparejado ? Colors.green.shade800 : Colors.black87,
                decoration: isEmparejado ? TextDecoration.lineThrough : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}