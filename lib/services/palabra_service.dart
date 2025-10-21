import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/palabra.dart';
import 'auth_service.dart';

class PalabraService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  final AuthService _authService = AuthService();

  /// Obtiene todas las palabras
  Future<List<Palabra>> getPalabras() async {
    try {
      final response = await _dio.get(ApiConfig.palabras);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Palabra.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al obtener palabras: $e');
    }
  }

  /// Obtiene una palabra por ID
  Future<Palabra?> getPalabraById(int id) async {
    try {
      final response = await _dio.get('${ApiConfig.palabras}/$id');
      
      if (response.statusCode == 200) {
        return Palabra.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener palabra: $e');
    }
  }

  /// Crea una nueva palabra (requiere autenticación)
  Future<Palabra?> createPalabra(Palabra palabra) async {
    try {
      final token = await _authService.getToken();
      
      final response = await _dio.post(
        ApiConfig.palabras,
        data: palabra.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Palabra.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al crear palabra');
    }
  }

  /// Actualiza una palabra existente
  Future<Palabra?> updatePalabra(int id, Palabra palabra) async {
    try {
      final token = await _authService.getToken();
      
      final response = await _dio.patch(
        '${ApiConfig.palabras}/$id',
        data: palabra.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return Palabra.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al actualizar palabra');
    }
  }

  /// Elimina una palabra
  Future<bool> deletePalabra(int id) async {
    try {
      final token = await _authService.getToken();
      
      final response = await _dio.delete(
        '${ApiConfig.palabras}/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al eliminar palabra');
    }
  }
}