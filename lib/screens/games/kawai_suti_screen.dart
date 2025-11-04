import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/game_models.dart';
import '../../services/games_service.dart';

class KawaiSutiScreen extends StatefulWidget {
  final int idJuego;
  final String categoria;
  final String nivelDificultad;
  final GamesService gamesService;

  const KawaiSutiScreen({
    Key? key,
    required this.idJuego,
    required this.categoria,
    required this.nivelDificultad,
    required this.gamesService,
  }) : super(key: key);

  @override
  State<KawaiSutiScreen> createState() => _KawaiSutiScreenState();
}

class _KawaiSutiScreenState extends State<KawaiSutiScreen> with TickerProviderStateMixin {
  List<PalabraImagenJuego> _palabras = [];
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
  late AnimationController _imageController;

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
    _imageController = AnimationController(
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
    _imageController.dispose();
    super.dispose();
  }

  // Future<void> _iniciarJuego() async {
  //   try {
  //     print('🎮 Iniciando Kawai Suti...');
      
  //     // Crear partida
  //     _partidaActual = await widget.gamesService.crearPartida(
  //       idJuego: widget.idJuego,
  //       nivelDificultad: widget.nivelDificultad,
  //     );

  //     // Obtener palabras de la categoría
  //     final cantidad = _getCantidadPorDificultad();
  //     _palabras = await widget.gamesService.obtenerPalabrasPorCategoria(
  //       categoria: widget.categoria,
  //       cantidad: cantidad,
  //       soloConImagen: false,
  //     );

  //     print('✅ Palabras obtenidas: ${_palabras.length}');

  //     // Iniciar cronómetro
  //     _iniciarCronometro();

  //     setState(() {
  //       _isLoading = false;
  //     });
      
  //     _imageController.forward();
  //   } catch (e) {
  //     print('❌ Error: $e');
  //     _mostrarError('Error al iniciar el juego: $e');
  //   }
  // }

  Future<void> _iniciarJuego() async {
    try {
      print('🎮 Iniciando Kawai Suti...');
      
      // Crear partida
      _partidaActual = await widget.gamesService.crearPartida(
        idJuego: widget.idJuego,
        nivelDificultad: widget.nivelDificultad,
      );

      // Obtener palabras de la categoría
      final cantidad = _getCantidadPorDificultad();
      _palabras = await widget.gamesService.obtenerPalabrasPorCategoria(
        categoria: widget.categoria,
        cantidad: cantidad,
        soloConImagen: false,
      );

      print('✅ Palabras obtenidas: ${_palabras.length}');

      // Iniciar cronómetro
      _iniciarCronometro();

      setState(() {
        _isLoading = false;
      });
      
      _imageController.forward();
    } catch (e) {
      print('❌ Error: $e');
      
      // Mostrar diálogo de error amigable
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('⚠️ Error'),
            content: Text(
              e.toString().contains('No hay palabras con imágenes')
                  ? 'Esta categoría aún no tiene palabras con imágenes.\n\nPor favor, selecciona otra categoría.'
                  : 'No se pudo cargar el juego: $e',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar diálogo
                  Navigator.of(context).pop(); // Volver a selección de categoría
                },
                child: const Text('Volver'),
              ),
            ],
          ),
        );
      }
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
        return 10;
    }
  }

  void _onOpcionSeleccionada(int idPalabra, int indexOpcion) {
    if (_mostrandoFeedback) return;

    setState(() {
      _opcionSeleccionada = indexOpcion;
      _mostrandoFeedback = true;
    });

    final palabraActual = _palabras[_indiceActual];
    final esCorrecta = idPalabra == palabraActual.idPalabraCorrecta;

    if (esCorrecta) {
      _successController.forward().then((_) => _successController.reset());
      setState(() {
        _aciertos++;
        _puntuacion += _getPuntosPorDificultad();
      });
      _reproducirSonido('acierto');
    } else {
      _errorController.forward().then((_) => _errorController.reset());
      setState(() {
        _errores++;
        _puntuacion = (_puntuacion - 3).clamp(0, 999999);
      });
      _reproducirSonido('error');
    }

    // Esperar feedback antes de continuar
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (esCorrecta) {
        _siguientePalabra();
      } else {
        // Permitir reintentar
        setState(() {
          _opcionSeleccionada = null;
          _mostrandoFeedback = false;
        });
      }
    });
  }

  void _siguientePalabra() {
    if (_indiceActual < _palabras.length - 1) {
      _imageController.reverse().then((_) {
        setState(() {
          _indiceActual++;
          _opcionSeleccionada = null;
          _mostrandoFeedback = false;
        });
        _imageController.forward();
      });
    } else {
      _finalizarJuego();
    }
  }

  void _reproducirSonido(String tipo) {
    // TODO: Implementar sonidos
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
            'categoria': widget.categoria,
            'palabras_usadas': _palabras.map((p) => p.idPalabraCorrecta).toList(),
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
            const SizedBox(height: 8),
            Text(
              'Categoría: ${widget.categoria}',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Salir'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Kawai Suti - ${widget.categoria}'),
  //       backgroundColor: Colors.indigo,
  //       actions: [
  //         Center(
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //             child: Row(
  //               children: [
  //                 const Icon(Icons.timer, color: Colors.white70),
  //                 const SizedBox(width: 4),
  //                 Text(
  //                   _formatearTiempo(_tiempoSegundos),
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     body: _isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : Column(
  //             children: [
  //               _buildScoreBar(),
  //               _buildProgreso(),
  //               Expanded(
  //                 child: Column(
  //                   children: [
  //                     Expanded(
  //                       flex: 3,
  //                       child: _buildImagenArea(),
  //                     ),
  //                     Expanded(
  //                       flex: 2,
  //                       child: _buildOpcionesArea(),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Kawai Suti - ${widget.categoria}'),
  //       backgroundColor: Colors.indigo,
  //       actions: [
  //         Center(
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //             child: Row(
  //               children: [
  //                 const Icon(Icons.timer, color: Colors.white70),
  //                 const SizedBox(width: 4),
  //                 Text(
  //                   _formatearTiempo(_tiempoSegundos),
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     body: _isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : SingleChildScrollView(  // ← AGREGAR
  //             child: Column(
  //               children: [
  //                 _buildScoreBar(),
  //                 _buildProgreso(),
  //                 SizedBox(  // ← CAMBIAR de Expanded a SizedBox con altura fija
  //                   height: MediaQuery.of(context).size.height * 0.4,  // 40% de la pantalla
  //                   child: _buildImagenArea(),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 SizedBox(  // ← CAMBIAR de Expanded a SizedBox
  //                   height: MediaQuery.of(context).size.height * 0.3,  // 30% de la pantalla
  //                   child: _buildOpcionesArea(),
  //                 ),
  //                 const SizedBox(height: 16),  // ← Espacio al final
  //               ],
  //             ),
  //           ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kawai Suti - ${widget.categoria}'),
        backgroundColor: Colors.indigo,
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
          : Column(  // ← Usar Column en lugar de SingleChildScrollView
              children: [
                _buildScoreBar(),
                _buildProgreso(),
                Expanded(  // ← La imagen toma el espacio disponible
                  child: _buildImagenArea(),
                ),
                // ← Área de opciones con altura fija
                _buildOpcionesAreaFixed(),
              ],
            ),
    );
  }

  Widget _buildOpcionesAreaFixed() {
    if (_palabras.isEmpty) return const SizedBox();
    
    final palabraActual = _palabras[_indiceActual];

    return Container(
      color: Colors.grey.shade50,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primera fila de botones
          Row(
            children: [
              Expanded(child: _buildBotonOpcion(0, palabraActual)),
              const SizedBox(width: 8),
              Expanded(child: _buildBotonOpcion(1, palabraActual)),
            ],
          ),
          const SizedBox(height: 8),
          // Segunda fila de botones
          Row(
            children: [
              Expanded(child: _buildBotonOpcion(2, palabraActual)),
              const SizedBox(width: 8),
              Expanded(child: _buildBotonOpcion(3, palabraActual)),
            ],
          ),
          const SizedBox(height: 8),  // Padding inferior
        ],
      ),
    );
  }

  Widget _buildBotonOpcion(int index, PalabraImagenJuego palabraActual) {
    if (index >= palabraActual.opciones.length) {
      return const SizedBox();  // Por si hay menos de 4 opciones
    }

    final opcion = palabraActual.opciones[index];
    final isSelected = _opcionSeleccionada == index;
    final isCorrect = opcion.idPalabra == palabraActual.idPalabraCorrecta;
    
    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;
    
    if (isSelected && _mostrandoFeedback) {
      if (isCorrect) {
        backgroundColor = Colors.green.shade100;
        borderColor = Colors.green;
      } else {
        backgroundColor = Colors.red.shade100;
        borderColor = Colors.red;
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
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        elevation: isSelected ? 8 : 2,
        child: InkWell(
          onTap: _mostrandoFeedback
              ? null
              : () => _onOpcionSeleccionada(opcion.idPalabra, index),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 50,  // ← Altura fija para cada botón
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  opcion.palabraInga,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected && _mostrandoFeedback
                        ? (isCorrect ? Colors.green.shade800 : Colors.red.shade800)
                        : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade700, Colors.indigo.shade500],
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
                'Pregunta ${_indiceActual + 1} de ${_palabras.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(((_indiceActual + 1) / _palabras.length) * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_indiceActual + 1) / _palabras.length,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo.shade700),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildImagenArea() {
    if (_palabras.isEmpty) return const SizedBox();
    
    final palabraActual = _palabras[_indiceActual];
    final tieneImagen = palabraActual.imagen != null && palabraActual.imagen!.isNotEmpty;

    return FadeTransition(
      opacity: _imageController,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: tieneImagen
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  palabraActual.imagen!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Imagen no disponible',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildOpcionesArea() {
  //   if (_palabras.isEmpty) return const SizedBox();
    
  //   final palabraActual = _palabras[_indiceActual];
  //   final esCorrecta = _opcionSeleccionada != null && 
  //       palabraActual.opciones[_opcionSeleccionada!].idPalabra == palabraActual.idPalabraCorrecta;

  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     child: GridView.builder(
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         childAspectRatio: 2.5,
  //         crossAxisSpacing: 12,
  //         mainAxisSpacing: 12,
  //       ),
  //       itemCount: palabraActual.opciones.length,
  //       itemBuilder: (context, index) {
  //         final opcion = palabraActual.opciones[index];
  //         final isSelected = _opcionSeleccionada == index;
  //         final isCorrect = opcion.idPalabra == palabraActual.idPalabraCorrecta;
          
  //         Color backgroundColor = Colors.white;
  //         Color borderColor = Colors.grey.shade300;
          
  //         if (isSelected && _mostrandoFeedback) {
  //           if (isCorrect) {
  //             backgroundColor = Colors.green.shade100;
  //             borderColor = Colors.green;
  //           } else {
  //             backgroundColor = Colors.red.shade100;
  //             borderColor = Colors.red;
  //           }
  //         }

  //         return AnimatedBuilder(
  //           animation: isSelected && !isCorrect ? _errorController : _successController,
  //           builder: (context, child) {
  //             return Transform.translate(
  //               offset: isSelected && !isCorrect
  //                   ? Offset(_errorController.value * 10 * (index % 2 == 0 ? 1 : -1), 0)
  //                   : Offset.zero,
  //               child: child,
  //             );
  //           },
  //           child: Material(
  //             color: backgroundColor,
  //             borderRadius: BorderRadius.circular(12),
  //             elevation: isSelected ? 8 : 2,
  //             child: InkWell(
  //               onTap: _mostrandoFeedback
  //                   ? null
  //                   : () => _onOpcionSeleccionada(opcion.idPalabra, index),
  //               borderRadius: BorderRadius.circular(12),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(12),
  //                   border: Border.all(color: borderColor, width: 2),
  //                 ),
  //                 child: Center(
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Text(
  //                       opcion.palabraInga,
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w600,
  //                         color: isSelected && _mostrandoFeedback
  //                             ? (isCorrect ? Colors.green.shade800 : Colors.red.shade800)
  //                             : Colors.black87,
  //                       ),
  //                       textAlign: TextAlign.center,
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
  Widget _buildOpcionesArea() {
    if (_palabras.isEmpty) return const SizedBox();
    
    final palabraActual = _palabras[_indiceActual];
    final esCorrecta = _opcionSeleccionada != null && 
        palabraActual.opciones[_opcionSeleccionada!].idPalabra == palabraActual.idPalabraCorrecta;

    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),  // ← AGREGAR para evitar scroll
        shrinkWrap: true,  // ← AGREGAR
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,  // ← CAMBIAR de 2.5 a 3.0 (más ancho, menos alto)
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: palabraActual.opciones.length,
        itemBuilder: (context, index) {
          final opcion = palabraActual.opciones[index];
          final isSelected = _opcionSeleccionada == index;
          final isCorrect = opcion.idPalabra == palabraActual.idPalabraCorrecta;
          
          Color backgroundColor = Colors.white;
          Color borderColor = Colors.grey.shade300;
          
          if (isSelected && _mostrandoFeedback) {
            if (isCorrect) {
              backgroundColor = Colors.green.shade100;
              borderColor = Colors.green;
            } else {
              backgroundColor = Colors.red.shade100;
              borderColor = Colors.red;
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
            child: Material(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              elevation: isSelected ? 8 : 2,
              child: InkWell(
                onTap: _mostrandoFeedback
                    ? null
                    : () => _onOpcionSeleccionada(opcion.idPalabra, index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),  // ← CAMBIAR
                      child: Text(
                        opcion.palabraInga,
                        style: TextStyle(
                          fontSize: 14,  // ← CAMBIAR de 16 a 14
                          fontWeight: FontWeight.w600,
                          color: isSelected && _mostrandoFeedback
                              ? (isCorrect ? Colors.green.shade800 : Colors.red.shade800)
                              : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}