class ApiConfig {
  // URL base del backend
  //static const String baseUrl = 'http://10.0.2.2:3000'; // Para Android Emulator
  static const String baseUrl = 'http://localhost:3000'; // Para Web/Desktop
  // static const String baseUrl = 'http://192.168.1.X:3000'; // Para dispositivo físico
  
  // Endpoints
  static const String login = '/auth/login';
  static const String usuarios = '/usuarios';
  static const String palabras = '/palabras';
  static const String lecciones = '/lecciones';
  
  // Keys para storage
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}