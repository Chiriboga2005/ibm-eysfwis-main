import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/persona.dart';

class ApiService {

  // Cambia esta dirección por la IP de tu computadora.
  static const String baseUrl = 'http://192.168.1.100:8080/api';

  Future<List<Persona>> obtenerPersonas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/personas'),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      final List<dynamic> datos =
          decoded is List ? decoded : decoded['data'];

      return datos.map((e) => Persona.fromJson(e)).toList();
    }

    throw Exception('Error al obtener personas');
  }
  Future<bool> crearPersona(Persona persona) async {
  final response = await http.post(
    Uri.parse('$baseUrl/personas'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(persona.toJson()),
  );

  return response.statusCode == 200 ||
      response.statusCode == 201;
}
}
