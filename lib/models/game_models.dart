// Modelo para Palabra en Juegos
class PalabraJuego {
  final int idPalabra;
  final String palabraInga;
  final String traduccionEspanol;
  final String? categoria;
  final String? imagen;
  final String? audio;
  final String traduccion;
  final String? traduccionIngles;

  PalabraJuego({
    required this.idPalabra,
    required this.palabraInga,
    required this.traduccionEspanol,
    required this.traduccion,
    this.categoria,
    this.imagen,
    this.audio,
    this.traduccionIngles,
  });

  factory PalabraJuego.fromJson(Map<String, dynamic> json) {
    return PalabraJuego(
      idPalabra: json['id_palabra'],
      palabraInga: json['palabra_inga'],
      traduccionEspanol: json['traduccion_espanol'],
      categoria: json['categoria'],
      imagen: json['imagen'],
      audio: json['audio'],
      traduccion: json['traduccion'] ?? json['traduccion_espanol'] ?? '',
      traduccionIngles: json['traduccion_ingles'],
    );
  }
}

// Modelo para imagen del juego Kawai Suti
class PalabraImagenJuego {
  final String? imagen;
  final String palabraCorrecta;
  final int idPalabraCorrecta;
  final String traduccionCorrecta;
  final List<OpcionPalabra> opciones;
  final String categoria;

  PalabraImagenJuego({
    this.imagen,
    required this.palabraCorrecta,
    required this.idPalabraCorrecta,
    required this.traduccionCorrecta,
    required this.opciones,
    required this.categoria,
  });

  factory PalabraImagenJuego.fromJson(Map<String, dynamic> json) {
    return PalabraImagenJuego(
      imagen: json['imagen'],
      palabraCorrecta: json['palabra_correcta'] ?? '',
      idPalabraCorrecta: json['id_palabra_correcta'] ?? 0,
      traduccionCorrecta: json['traduccion_correcta'] ?? '',
      opciones: (json['opciones'] as List?)
          ?.map((o) => OpcionPalabra.fromJson(o))
          .toList() ?? [],
      categoria: json['categoria'] ?? '',
    );
  }
}

// Modelo para opciones del juego Kawai Suti
class OpcionPalabra {
  final int idPalabra;
  final String palabraInga;
  final String traduccionEspanol;
  final String traduccionIngles;
  final String traduccion;

  OpcionPalabra({
    required this.idPalabra,
    required this.palabraInga,
    required this.traduccionEspanol,
    required this.traduccionIngles,
    required this.traduccion,
  });

  factory OpcionPalabra.fromJson(Map<String, dynamic> json) {
    return OpcionPalabra(
      idPalabra: json['id_palabra'] ?? 0,
      palabraInga: json['palabra_inga'] ?? '',
      traduccionEspanol: json['traduccion_espanol'] ?? '',
      traduccionIngles: json['traduccion_ingles'] ?? json['traduccion_espanol'] ?? '',
      traduccion: json['traduccion'] ?? json['traduccion_espanol'] ?? '',
    );
  }
}

// Modelo para Opción en juegos de completar frases
class OpcionOracion {
  final String palabraInga;
  final String traduccionEspanol;
  final String traduccionIngles;
  final String traduccion;
  final bool esCorrecta;

  OpcionOracion({
    required this.palabraInga,
    required this.traduccionEspanol,
    required this.traduccionIngles,
    required this.traduccion,
    required this.esCorrecta,
  });

  factory OpcionOracion.fromJson(Map<String, dynamic> json) {
    return OpcionOracion(
      palabraInga: json['palabra_inga'] ?? '',
      traduccionEspanol: json['traduccion_espanol'] ?? '',
      traduccionIngles: json['traduccion_ingles'] ?? json['traduccion_espanol'] ?? '',
      traduccion: json['traduccion'] ?? json['traduccion_espanol'] ?? '',
      esCorrecta: json['es_correcta'] ?? false,
    );
  }
}

// Modelo para Oraciones en juegos
class OracionJuego {
  final int idOracion;
  final String textoEspanol;
  final String textoCompletoEspanol;
  final String textoInga;
  final String palabraCorrecta;
  final String palabraCorrectaTraduccion;
  final List<OpcionOracion> opciones;
  final String categoria;

  OracionJuego({
    required this.idOracion,
    required this.textoEspanol,
    required this.textoCompletoEspanol,
    required this.textoInga,
    required this.palabraCorrecta,
    required this.palabraCorrectaTraduccion,
    required this.opciones,
    required this.categoria,
  });

  factory OracionJuego.fromJson(Map<String, dynamic> json) {
    return OracionJuego(
      idOracion: json['id_oracion'] ?? 0,
      textoEspanol: json['texto_espanol'] ?? '',
      textoCompletoEspanol: json['texto_completo_espanol'] ?? '',
      textoInga: json['texto_inga'] ?? '',
      palabraCorrectaTraduccion: json['palabra_correcta_traduccion'] ?? '',
      palabraCorrecta: json['palabra_correcta'] ?? '',
      opciones: (json['opciones'] as List?)
          ?.map((o) => OpcionOracion.fromJson(o))
          .toList() ?? [],
      categoria: json['categoria'] ?? '',
    );
  }
}

// Modelo para Partida
class Partida {
  final int? idPartida;
  final int idUsuario;
  final int idJuego;
  final int? idLeccion;
  final int puntuacion;
  final int aciertos;
  final int errores;
  final int tiempoSegundos;
  final Map<String, dynamic>? detalles;
  final bool completado;
  final String nivelDificultad;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;

  Partida({
    this.idPartida,
    required this.idUsuario,
    required this.idJuego,
    this.idLeccion,
    this.puntuacion = 0,
    this.aciertos = 0,
    this.errores = 0,
    this.tiempoSegundos = 0,
    this.detalles,
    this.completado = false,
    required this.nivelDificultad,
    this.fechaInicio,
    this.fechaFin,
  });

  factory Partida.fromJson(Map<String, dynamic> json) {
    return Partida(
      idPartida: json['id_partida'],
      idUsuario: json['id_usuario'],
      idJuego: json['id_juego'],
      idLeccion: json['id_leccion'],
      puntuacion: json['puntuacion'] ?? 0,
      aciertos: json['aciertos'] ?? 0,
      errores: json['errores'] ?? 0,
      tiempoSegundos: json['tiempo_segundos'] ?? 0,
      detalles: json['detalles'],
      completado: json['completado'] ?? false,
      nivelDificultad: json['nivel_dificultad'] ?? 'facil',
      fechaInicio: json['fecha_inicio'] != null 
          ? DateTime.parse(json['fecha_inicio']) 
          : null,
      fechaFin: json['fecha_fin'] != null 
          ? DateTime.parse(json['fecha_fin']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_juego': idJuego,
      'id_leccion': idLeccion,
      'nivel_dificultad': nivelDificultad,
    };
  }
}

// Modelo para Juego
class Juego {
  final int idJuego;
  final String nombre;
  final String? nombreIngles;
  final String? descripcion;
  final String? descripcionIngles;
  final String tipoJuego;
  final Map<String, dynamic>? configuracion;
  final bool activo;
  final DateTime fechaCreacion;

  Juego({
    required this.idJuego,
    required this.nombre,
    this.nombreIngles,
    this.descripcion,
    this.descripcionIngles,
    required this.tipoJuego,
    this.configuracion,
    required this.activo,
    required this.fechaCreacion,
  });

  factory Juego.fromJson(Map<String, dynamic> json) {
    return Juego(
      idJuego: json['id_juego'],
      nombre: json['nombre'],
      nombreIngles: json['nombre_ingles'],
      descripcion: json['descripcion'],
      descripcionIngles: json['descripcion_ingles'],
      tipoJuego: json['tipo_juego'],
      configuracion: json['configuracion'],
      activo: json['activo'] ?? true,
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
    );
  }

  String getNombre(String idioma) {
    return idioma == 'en' && nombreIngles != null ? nombreIngles! : nombre;
  }

  String? getDescripcion(String idioma) {
    return idioma == 'en' && descripcionIngles != null ? descripcionIngles : descripcion;
  }
}

// Modelo para Progreso
class ProgresoJuego {
  final int idProgreso;
  final int idUsuario;
  final int idJuego;
  final int puntuacionTotal;
  final int partidasJugadas;
  final int partidasCompletadas;
  final int mejorPuntuacion;
  final int totalAciertos;
  final int totalErrores;
  final String nivelActual;
  final DateTime fechaCreacion;
  final DateTime fechaActualizacion;

  ProgresoJuego({
    required this.idProgreso,
    required this.idUsuario,
    required this.idJuego,
    required this.puntuacionTotal,
    required this.partidasJugadas,
    required this.partidasCompletadas,
    required this.mejorPuntuacion,
    required this.totalAciertos,
    required this.totalErrores,
    required this.nivelActual,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  factory ProgresoJuego.fromJson(Map<String, dynamic> json) {
    return ProgresoJuego(
      idProgreso: json['id_progreso'],
      idUsuario: json['id_usuario'],
      idJuego: json['id_juego'],
      puntuacionTotal: json['puntuacion_total'] ?? 0,
      partidasJugadas: json['partidas_jugadas'] ?? 0,
      partidasCompletadas: json['partidas_completadas'] ?? 0,
      mejorPuntuacion: json['mejor_puntuacion'] ?? 0,
      totalAciertos: json['total_aciertos'] ?? 0,
      totalErrores: json['total_errores'] ?? 0,
      nivelActual: json['nivel_actual'] ?? 'principiante',
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      fechaActualizacion: DateTime.parse(json['fecha_actualizacion']),
    );
  }

  double get porcentajeAciertos {
    final total = totalAciertos + totalErrores;
    return total > 0 ? (totalAciertos / total) * 100 : 0;
  }
}

// DTO para finalizar partida
class FinalizarPartidaDto {
  final int puntuacion;
  final int aciertos;
  final int errores;
  final int tiempoSegundos;
  final bool completado;
  final Map<String, dynamic>? detalles;

  FinalizarPartidaDto({
    required this.puntuacion,
    required this.aciertos,
    required this.errores,
    required this.tiempoSegundos,
    required this.completado,
    this.detalles,
  });

  Map<String, dynamic> toJson() {
    return {
      'puntuacion': puntuacion,
      'aciertos': aciertos,
      'errores': errores,
      'tiempo_segundos': tiempoSegundos,
      'completado': completado,
      'detalles': detalles,
    };
  }
}