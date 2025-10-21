import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/leccion.dart';
import 'auth_service.dart';

class LeccionService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  final AuthService _authService = AuthService();

  /// Obtiene todas las lecciones
  Future<List<Leccion>> getLecciones() async {
    try {
      final response = await _dio.get(ApiConfig.lecciones);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Leccion.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al obtener lecciones: $e');
    }
  }

  /// Obtiene una lección por ID
  Future<Leccion?> getLeccionById(int id) async {
    try {
      final response = await _dio.get('${ApiConfig.lecciones}/$id');
      
      if (response.statusCode == 200) {
        return Leccion.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener lección: $e');
    }
  }

  /// Crea una nueva lección (requiere autenticación)
  Future<Leccion?> createLeccion(Leccion leccion) async {
    try {
      final token = await _authService.getToken();
      
      final response = await _dio.post(
        ApiConfig.lecciones,
        data: leccion.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Leccion.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al crear lección');
    }
  }

  /// Actualiza una lección existente
  Future<Leccion?> updateLeccion(int id, Leccion leccion) async {
    try {
      final token = await _authService.getToken();
      
      final response = await _dio.patch(
        '${ApiConfig.lecciones}/$id',
        data: leccion.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return Leccion.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al actualizar lección');
    }
  }

  /// Elimina una lección
  Future<bool> deleteLeccion(int id) async {
    try {
      final token = await _authService.getToken();
      
      final response = await _dio.delete(
        '${ApiConfig.lecciones}/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al eliminar lección');
    }
  }
}