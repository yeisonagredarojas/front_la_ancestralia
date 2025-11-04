import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';
import '../utils/jwt_utils.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Login: autentica al usuario y guarda el token
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConfig.login,
        data: {
          'email': email,
          'contraseña': password,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        final token = data['access_token'];
        final usuario = data['usuario'];

        // Guardar token y datos de usuario
        await _storage.write(key: ApiConfig.tokenKey, value: token);
        await _storage.write(key: ApiConfig.userKey, value: jsonEncode(usuario));

        return {
          'success': true,
          'token': token,
          'usuario': usuario,
        };
      }

      return {'success': false, 'message': 'Error en el login'};
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Error de conexión',
      };
    }
  }

  /// Registro: crea una nueva cuenta de estudiante
  Future<Map<String, dynamic>> register(String nombre, String email, String password) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.baseUrl}/auth/register',
        data: {
          'nombre': nombre,
          'email': email,
          'contraseña': password,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Registro exitoso',
        };
      }

      return {'success': false, 'message': 'Error en el registro'};
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Error de conexión',
      };
    }
  }

  /// Obtiene el token almacenado
  Future<String?> getToken() async {
    return await _storage.read(key: ApiConfig.tokenKey);
  }

  /// Obtiene los datos del usuario almacenados
  Future<Map<String, dynamic>?> getUserData() async {
    final userData = await _storage.read(key: ApiConfig.userKey);
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  /// Verifica si hay una sesión activa
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;
    return !JwtUtils.isTokenExpired(token);
  }

  /// Cierra sesión
  Future<void> logout() async {
    await _storage.delete(key: ApiConfig.tokenKey);
    await _storage.delete(key: ApiConfig.userKey);
  }

  /// Obtiene el rol del usuario actual
  Future<String?> getUserRole() async {
    final token = await getToken();
    if (token == null) return null;
    return JwtUtils.getRolFromToken(token);
  }
}