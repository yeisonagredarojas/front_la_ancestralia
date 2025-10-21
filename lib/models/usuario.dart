import 'rol.dart';
class Usuario {
  final int? idUsuario;
  final String nombre;
  final String email;
  final String? password;
  final int? idRol;
  final Rol? rol;
  final bool? estado;
  final DateTime? fechaCreacion;

  Usuario({
    this.idUsuario,
    required this.nombre,
    required this.email,
    this.password,
    this.idRol,
    this.rol,
    this.estado,
    this.fechaCreacion,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['id_usuario'],
      nombre: json['nombre'],
      email: json['email'],
      idRol: json['id_rol'],
      rol: json['rol'] != null ? Rol.fromJson(json['rol']) : null,
      estado: json['estado'],
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'password': password,
      'id_rol': idRol,
    };
  }
}