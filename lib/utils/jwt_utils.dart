import 'package:jwt_decoder/jwt_decoder.dart';

class JwtUtils {
  /// Verifica si el token ha expirado
  static bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  /// Decodifica el token y obtiene el payload
  static Map<String, dynamic>? decodeToken(String token) {
    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el rol del usuario desde el token
  static String? getRolFromToken(String token) {
    final decoded = decodeToken(token);
    return decoded?['rol'];
  }

  /// Obtiene el ID del usuario desde el token
  static int? getUserIdFromToken(String token) {
    final decoded = decodeToken(token);
    return decoded?['sub'];
  }

  /// Obtiene el email del usuario desde el token
  static String? getEmailFromToken(String token) {
    final decoded = decodeToken(token);
    return decoded?['email'];
  }
}