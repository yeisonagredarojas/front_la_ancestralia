import 'usuario.dart';
import 'palabra.dart';

class Leccion {
  final int? idLeccion;
  final String titulo;
  final String? descripcion;
  final int? idUsuario;
  final Usuario? usuario;
  final List<int>? idPalabras;
  final List<Palabra>? palabras;
  final DateTime? fechaPublicacion;

  Leccion({
    this.idLeccion,
    required this.titulo,
    this.descripcion,
    this.idUsuario,
    this.usuario,
    this.idPalabras,
    this.palabras,
    this.fechaPublicacion,
  });

  factory Leccion.fromJson(Map<String, dynamic> json) {
    return Leccion(
      idLeccion: json['id_leccion'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      idUsuario: json['id_usuario'],
      usuario: json['usuario'] != null ? Usuario.fromJson(json['usuario']) : null,
      palabras: json['palabras'] != null
          ? (json['palabras'] as List).map((p) => Palabra.fromJson(p)).toList()
          : null,
      fechaPublicacion: json['fecha_publicacion'] != null
          ? DateTime.parse(json['fecha_publicacion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'descripcion': descripcion,
      'id_palabras': idPalabras,
    };
  }
}