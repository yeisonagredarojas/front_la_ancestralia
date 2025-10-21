import 'usuario.dart';

class Palabra {
  final int? idPalabra;
  final String palabraInga;
  final String traduccionEspanol;
  final String? categoria;
  final String? audio;
  final String? imagen;
  final int? idUsuario;
  final Usuario? usuario;
  final DateTime? fechaCreacion;

  Palabra({
    this.idPalabra,
    required this.palabraInga,
    required this.traduccionEspanol,
    this.categoria,
    this.audio,
    this.imagen,
    this.idUsuario,
    this.usuario,
    this.fechaCreacion,
  });

  factory Palabra.fromJson(Map<String, dynamic> json) {
    return Palabra(
      idPalabra: json['id_palabra'],
      palabraInga: json['palabra_inga'],
      traduccionEspanol: json['traduccion_espanol'],
      categoria: json['categoria'],
      audio: json['audio'],
      imagen: json['imagen'],
      idUsuario: json['id_usuario'],
      usuario: json['usuario'] != null ? Usuario.fromJson(json['usuario']) : null,
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'palabra_inga': palabraInga,
      'traduccion_espanol': traduccionEspanol,
      'categoria': categoria,
      'audio': audio,
      'imagen': imagen,
    };
  }
}