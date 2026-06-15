class ApiConfig {
  // URL base del backend
  // static const String baseUrl = 'http://10.0.2.2:3000'; // Para Android Emulator
  static const String baseUrl = 'http://localhost:3000'; // Para Web/Desktop
  // static const String baseUrl = 'http://192.168.1.X:3000'; // Para dispositivo físico
  
  // Endpoints existentes
  static const String login = '/auth/login';
  static const String usuarios = '/usuarios';
  static const String palabras = '/palabras';
  static const String lecciones = '/lecciones';
  
  // Endpoints de Games (AGREGAR ESTOS)
  static const String games = '/games';
  static const String gamesJuego = '/games/juego';
  static const String gamesPalabras = '/games/palabras';
  static const String gamesPartida = '/games/partida';
  static const String gamesProgreso = '/games/progreso';
  static const String gamesHistorial = '/games/historial';
  static const String gamesRanking = '/games/ranking';
  static const String gamesCategorias = '/games/categorias'; 
  static const String gamesPalabrasCategoria = '/games/palabras-categoria';  
  static const String gamesOraciones = '/games/oraciones';
  
  // Keys para storage
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  
  // Timeout para peticiones HTTP
  static const Duration timeout = Duration(seconds: 30);
}
