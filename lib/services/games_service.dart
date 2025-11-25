/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'game_models.dart';

class GamesService {
  final String baseUrl;
  final String? token;

  GamesService({
    required this.baseUrl,
    this.token,
  });

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // Obtener todos los juegos disponibles
  Future<List<Juego>> obtenerJuegos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/games'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Juego.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener juegos: ${response.statusCode}');
    }
  }

  // Obtener un juego específico
  Future<Juego> obtenerJuego(int idJuego) async {
    final response = await http.get(
      Uri.parse('$baseUrl/games/juego/$idJuego'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Juego.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el juego: ${response.statusCode}');
    }
  }

  // Crear una nueva partida
  Future<Partida> crearPartida({
    required int idJuego,
    int? idLeccion,
    required String nivelDificultad,
  }) async {
    final body = {
      'id_juego': idJuego,
      'id_leccion': idLeccion,
      'nivel_dificultad': nivelDificultad,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/games/partida'),
      headers: _headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Partida.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear partida: ${response.statusCode}');
    }
  }

  // Obtener palabras para el juego
  Future<List<PalabraJuego>> obtenerPalabrasParaJuego({
    int? idLeccion,
    int cantidad = 6,
  }) async {
    final queryParams = {
      if (idLeccion != null) 'id_leccion': idLeccion.toString(),
      'cantidad': cantidad.toString(),
    };

    final uri = Uri.parse('$baseUrl/games/palabras').replace(
      queryParameters: queryParams,
    );

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PalabraJuego.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener palabras: ${response.statusCode}');
    }
  }

  // Finalizar una partida
  Future<Map<String, dynamic>> finalizarPartida(
    int idPartida,
    FinalizarPartidaDto finalizarDto,
  ) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/games/partida/$idPartida/finalizar'),
      headers: _headers,
      body: json.encode(finalizarDto.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al finalizar partida: ${response.statusCode}');
    }
  }

  // Obtener progreso del usuario
  Future<dynamic> obtenerProgreso({int? idJuego}) async {
    final queryParams = {
      if (idJuego != null) 'id_juego': idJuego.toString(),
    };

    final uri = Uri.parse('$baseUrl/games/progreso').replace(
      queryParameters: queryParams,
    );

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data.map((json) => ProgresoJuego.fromJson(json)).toList();
      } else if (data != null) {
        return ProgresoJuego.fromJson(data);
      }
      return null;
    } else {
      throw Exception('Error al obtener progreso: ${response.statusCode}');
    }
  }

  // Obtener historial de partidas
  Future<List<Partida>> obtenerHistorial({int? idJuego}) async {
    final queryParams = {
      if (idJuego != null) 'id_juego': idJuego.toString(),
    };

    final uri = Uri.parse('$baseUrl/games/historial').replace(
      queryParameters: queryParams,
    );

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Partida.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener historial: ${response.statusCode}');
    }
  }

  // Obtener ranking
  Future<List<ProgresoJuego>> obtenerRanking(
    int idJuego, {
    int limite = 10,
  }) async {
    final uri = Uri.parse('$baseUrl/games/ranking/$idJuego').replace(
      queryParameters: {'limite': limite.toString()},
    );

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProgresoJuego.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener ranking: ${response.statusCode}');
    }
  }
}*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_models.dart';
import '../config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamesService {
  final String? token;

  GamesService({this.token});

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // Obtener todos los juegos disponibles
  Future<List<Juego>> obtenerJuegos() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.games}'),
      headers: _headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Juego.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener juegos: ${response.statusCode}');
    }
  }

  // Obtener un juego específico
  Future<Juego> obtenerJuego(int idJuego) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesJuego}/$idJuego'),
      headers: _headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      return Juego.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener el juego: ${response.statusCode}');
    }
  }

  // Crear una nueva partida
  Future<Partida> crearPartida({
    required int idJuego,
    int? idLeccion,
    required String nivelDificultad,
  }) async {
    final body = {
      'id_juego': idJuego,
      'id_leccion': idLeccion,
      'nivel_dificultad': nivelDificultad,
    };

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesPartida}'),
      headers: _headers,
      body: json.encode(body),
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Partida.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear partida: ${response.statusCode}');
    }
  }

  // Obtener palabras para el juego
  // Obtener palabras con idioma
  Future<List<PalabraJuego>> obtenerPalabrasParaJuego({
    int? idLeccion,
    int cantidad = 6,
    String idioma = 'es',
  }) async {
    final Map<String, String> queryParams = {};
    
    if (idLeccion != null) {
      queryParams['id_leccion'] = idLeccion.toString();
    }
    queryParams['cantidad'] = cantidad.toString();
    queryParams['idioma'] = idioma;  // ← AGREGAR

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesPalabras}')
        .replace(queryParameters: queryParams);

    print('🔗 URL: $uri');  // ← LOG para debug

    final response = await http.get(uri, headers: _headers).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PalabraJuego.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener palabras: ${response.statusCode}');
    }
  }
  // Future<List<PalabraJuego>> obtenerPalabrasParaJuego({
  //   int? idLeccion,
  //   int cantidad = 6,
  // }) async {
  //   final queryParams = {
  //     if (idLeccion != null) 'id_leccion': idLeccion.toString(),
  //     'cantidad': cantidad.toString(),
  //   };

  //   final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesPalabras}')
  //       .replace(queryParameters: queryParams);

  //   final response = await http.get(uri, headers: _headers).timeout(ApiConfig.timeout);

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => PalabraJuego.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Error al obtener palabras: ${response.statusCode}');
  //   }
  // }

  // Finalizar una partida
  // Future<Map<String, dynamic>> finalizarPartida(
  //   int idPartida,
  //   FinalizarPartidaDto finalizarDto,
  // ) async {
  //   final response = await http.patch(
  //     Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesPartida}/$idPartida/finalizar'),
  //     headers: _headers,
  //     body: json.encode(finalizarDto.toJson()),
  //   ).timeout(ApiConfig.timeout);

  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     throw Exception('Error al finalizar partida: ${response.statusCode}');
  //   }
  // }

  // Finalizar una partida
  Future<Map<String, dynamic>> finalizarPartida(
    int idPartida,
    FinalizarPartidaDto finalizarDto,
  ) async {
    print('🎯 Finalizando partida $idPartida');
    print('📦 Datos: ${json.encode(finalizarDto.toJson())}');
    
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesPartida}/$idPartida/finalizar'),
      headers: _headers,
      body: json.encode(finalizarDto.toJson()),
    ).timeout(ApiConfig.timeout);

    print('📡 Status: ${response.statusCode}');
    print('📦 Response: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('❌ Error response: ${response.body}');
      throw Exception('Error al finalizar partida: ${response.statusCode} - ${response.body}');
    }

  }

  // Obtener progreso del usuario
  Future<dynamic> obtenerProgreso({int? idJuego}) async {
    final queryParams = {
      if (idJuego != null) 'id_juego': idJuego.toString(),
    };

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesProgreso}')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: _headers).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data.map((json) => ProgresoJuego.fromJson(json)).toList();
      } else if (data != null) {
        return ProgresoJuego.fromJson(data);
      }
      return null;
    } else {
      throw Exception('Error al obtener progreso: ${response.statusCode}');
    }
  }

  // Obtener historial de partidas
  Future<List<Partida>> obtenerHistorial({int? idJuego}) async {
    final queryParams = {
      if (idJuego != null) 'id_juego': idJuego.toString(),
    };

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesHistorial}')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: _headers).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Partida.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener historial: ${response.statusCode}');
    }
  }

  // Obtener ranking
  Future<List<ProgresoJuego>> obtenerRanking(
    int idJuego, {
    int limite = 10,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesRanking}/$idJuego')
        .replace(queryParameters: {'limite': limite.toString()});

    final response = await http.get(uri, headers: _headers).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ProgresoJuego.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener ranking: ${response.statusCode}');
    }
  }


  // Obtener categorías disponibles con idioma
  Future<List<String>> obtenerCategorias({String idioma = 'es'}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesCategorias}')
        .replace(queryParameters: {'idioma': idioma});

    print('🔗 URL categorías: $uri');  // ← LOG

    final response = await http.get(uri, headers: _headers).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      throw Exception('Error al obtener categorías: ${response.statusCode}');
    }
  }
  // Future<List<String>> obtenerCategorias() async {
  //   final response = await http.get(
  //     Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesCategorias}'),
  //     headers: _headers,
  //   ).timeout(ApiConfig.timeout);

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.cast<String>();
  //   } else {
  //     throw Exception('Error al obtener categorías: ${response.statusCode}');
  //   }
  // }

  // Obtener palabras por categoría para juego de imágenes
  Future<List<PalabraImagenJuego>> obtenerPalabrasPorCategoria({
    required String categoria,
    int cantidad = 6,
    bool soloConImagen = true,
    String idioma = 'es'
  }) async {
    final queryParams = {
      'cantidad': cantidad.toString(),
      'solo_con_imagen': soloConImagen.toString(),
      'idioma': idioma,
    };

    final uri = Uri.parse(
      '${ApiConfig.baseUrl}${ApiConfig.gamesPalabrasCategoria}/$categoria',
    ).replace(queryParameters: queryParams);

    

    print('🔗 URL palabras categoría: $uri');  // ← LOG                     // 👈 Print 1
    print('📤 Headers: $_headers'); 

    final response = await http.get(uri, headers: _headers).timeout(ApiConfig.timeout);

    print('📥 Respuesta del backend: ${response.body}'); // 👈 Print 2
    print('📊 Status code: ${response.statusCode}');  

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PalabraImagenJuego.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener palabras por categoría: ${response.statusCode}');
    }
  }

  // Obtener oraciones para completar frases
  // Obtener oraciones con idioma
  Future<List<OracionJuego>> obtenerOracionesParaJuego({
    String nivelDificultad = 'medio',
    int cantidad = 6,
    String idioma = 'es',
  }) async {
    final queryParams = {
      'nivel_dificultad': nivelDificultad,
      'cantidad': cantidad.toString(),
      'idioma': idioma,  // ← AGREGAR
    };

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesOraciones}')
        .replace(queryParameters: queryParams);

    print('🔗 URL oraciones: $uri');  // ← LOG

    final response = await http.get(uri, headers: _headers).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => OracionJuego.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener oraciones: ${response.statusCode}');
    }
  }

  // Future<List<OracionJuego>> obtenerOracionesParaJuego({
  //   String nivelDificultad = 'medio',
  //   int cantidad = 6,
  // }) async {
  //   final queryParams = {
  //     'nivel_dificultad': nivelDificultad,
  //     'cantidad': cantidad.toString(),
  //   };

  //   final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesOraciones}')
  //       .replace(queryParameters: queryParams);

  //   final response = await http.get(uri, headers: _headers).timeout(ApiConfig.timeout);

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     return data.map((json) => OracionJuego.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Error al obtener oraciones: ${response.statusCode}');
  //   }
  //}
  // CRUD de oraciones
  Future<Map<String, dynamic>> crearOracion(Map<String, dynamic> oracionData) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesOraciones}'),
      headers: _headers,
      body: json.encode(oracionData),
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear oración: ${response.statusCode}');
    }
  }

  Future<void> eliminarOracion(int idOracion) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesOraciones}/$idOracion'),
      headers: _headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar oración: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> listarOraciones() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.gamesOraciones}/todas'),
      headers: _headers,
    ).timeout(ApiConfig.timeout);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al listar oraciones: ${response.statusCode}');
    }
  }

  Future<String> _obtenerIdiomaActual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('locale') ?? 'es';
  }
}