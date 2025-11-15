import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/game_models.dart';
import '../../services/games_service.dart';

class CompletarFrasesScreen extends StatefulWidget {
  final int idJuego;
  final String nivelDificultad;
  final GamesService gamesService;

  const CompletarFrasesScreen({
    Key? key,
    required this.idJuego,
    required this.nivelDificultad,
    required this.gamesService,
  }) : super(key: key);

  @override
  State<CompletarFrasesScreen> createState() => _CompletarFrasesScreenState();
}

class _CompletarFrasesScreenState extends State<CompletarFrasesScreen> with TickerProviderStateMixin {
  List<OracionJuego> _oraciones = [];
  int _indiceActual = 0;
  int? _opcionSeleccionada;
  
  int _puntuacion = 0;
  int _aciertos = 0;
  int _errores = 0;
  int _tiempoSegundos = 0;
  Timer? _timer;
  
  Partida? _partidaActual;
  bool _isLoading = true;
  bool _juegoCompletado = false;
  bool _mostrandoFeedback = false;
  
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
    _iniciarJuego();
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
      print('🎮 Iniciando Completar Frases...');
      
      _partidaActual = await widget.gamesService.crearPartida(
        idJuego: widget.idJuego,
        nivelDificultad: widget.nivelDificultad,
      );

      final cantidad = _getCantidadPorDificultad();
      _oraciones = await widget.gamesService.obtenerOracionesParaJuego(
        nivelDificultad: widget.nivelDificultad,
        cantidad: cantidad,
      );

      print('✅ Oraciones obtenidas: ${_oraciones.length}');

      _iniciarCronometro();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error: $e');
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

  int _getPuntosPorDificultad() {
    switch (widget.nivelDificultad) {
      case 'facil':
        return 10;
      case 'medio':
        return 15;
      case 'dificil':
        return 20;
      default:
        return 15;
    }
  }

  void _onOpcionSeleccionada(String palabraInga, int indexOpcion) {
    if (_mostrandoFeedback) return;

    setState(() {
      _opcionSeleccionada = indexOpcion;
      _mostrandoFeedback = true;
    });

    final oracionActual = _oraciones[_indiceActual];
    final esCorrecta = palabraInga == oracionActual.palabraCorrecta;

    if (esCorrecta) {
      _successController.forward().then((_) => _successController.reset());
      setState(() {
        _aciertos++;
        _puntuacion += _getPuntosPorDificultad();
      });
    } else {
      _errorController.forward().then((_) => _errorController.reset());
      setState(() {
        _errores++;
        _puntuacion = (_puntuacion - 5).clamp(0, 999999);
      });
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      _siguienteOracion();
    });
  }

  void _siguienteOracion() {
    if (_indiceActual < _oraciones.length - 1) {
      setState(() {
        _indiceActual++;
        _opcionSeleccionada = null;
        _mostrandoFeedback = false;
      });
    } else {
      _finalizarJuego();
    }
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
            'oraciones_usadas': _oraciones.map((o) => o.idOracion).toList(),
          },
        );

        await widget.gamesService.finalizarPartida(
          _partidaActual!.idPartida!,
          finalizarDto,
        );

        _mostrarDialogoResultados();
      } catch (e) {
        print('Error al guardar: $e');
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
      _indiceActual = 0;
      _opcionSeleccionada = null;
      _puntuacion = 0;
      _aciertos = 0;
      _errores = 0;
      _tiempoSegundos = 0;
      _juegoCompletado = false;
      _mostrandoFeedback = false;
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
        title: const Text('Puchukana Rimai'),
        backgroundColor: Colors.teal,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Colors.white70),
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
                _buildProgreso(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildFraseArea(),
                        const SizedBox(height: 24),
                        _buildOpcionesArea(),
                      ],
                    ),
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
          colors: [Colors.teal.shade700, Colors.teal.shade500],
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

  Widget _buildProgreso() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Frase ${_indiceActual + 1} de ${_oraciones.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(((_indiceActual + 1) / _oraciones.length) * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_indiceActual + 1) / _oraciones.length,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade700),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildFraseArea() {
    if (_oraciones.isEmpty) return const SizedBox();
    
    final oracionActual = _oraciones[_indiceActual];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.format_quote,
              size: 40,
              color: Colors.teal,
            ),
            const SizedBox(height: 16),
            Text(
              oracionActual.textoEspanol,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (_mostrandoFeedback) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                oracionActual.textoInga,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.teal.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOpcionesArea() {
    if (_oraciones.isEmpty) return const SizedBox();
    
    final oracionActual = _oraciones[_indiceActual];

    return Column(
      children: List.generate(
        oracionActual.opciones.length,
        (index) => _buildBotonOpcion(index, oracionActual),
      ),
    );
  }

  Widget _buildBotonOpcion(int index, OracionJuego oracionActual) {
    final opcion = oracionActual.opciones[index];
    final isSelected = _opcionSeleccionada == index;
    final isCorrect = opcion.palabraInga == oracionActual.palabraCorrecta;
    
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    IconData? iconData;
    
    if (isSelected && _mostrandoFeedback) {
      if (isCorrect) {
        backgroundColor = Colors.green.shade100;
        borderColor = Colors.green;
        iconData = Icons.check_circle;
      } else {
        backgroundColor = Colors.red.shade100;
        borderColor = Colors.red;
        iconData = Icons.cancel;
      }
    }

    return AnimatedBuilder(
      animation: isSelected && !isCorrect ? _errorController : _successController,
      builder: (context, child) {
        return Transform.translate(
          offset: isSelected && !isCorrect
              ? Offset(_errorController.value * 10 * (index % 2 == 0 ? 1 : -1), 0)
              : Offset.zero,
          child: child,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          elevation: isSelected ? 8 : 2,
          child: InkWell(
            onTap: _mostrandoFeedback
                ? null
                : () => _onOpcionSeleccionada(opcion.palabraInga, index),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected && _mostrandoFeedback
                          ? (isCorrect ? Colors.green : Colors.red)
                          : Colors.teal.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: iconData != null
                          ? Icon(iconData, color: Colors.white, size: 24)
                          : Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opcion.palabraInga,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected && _mostrandoFeedback
                                ? (isCorrect ? Colors.green.shade800 : Colors.red.shade800)
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          opcion.traduccionEspanol,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}