import 'dart:convert';
import 'package:http/http.dart' as http;

class LikeService {
  static const String apiUrl =
      'http://arthub.somee.com/api/Interaccion'; // Reemplaza con tu URL correcta
  static const int moduleId = 3; // Id de módulo constante con valor 3

  Future<void> saveLike(int idUsuario, int idPublicacion, bool isLiked) async {
    final Map<String, dynamic> likeData = {
      'idUsuario': idUsuario,
    };

    try {
      final response = await http.put(
        Uri.parse('http://arthub.somee.com/api/Publicacion/$idPublicacion/Like'),
        body: jsonEncode(likeData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Like guardado exitosamente');
      } else if (response.statusCode == 307) {
        // Manejar la redirección
        String redirectedUrl = response.headers['location'] ?? '';
        if (redirectedUrl.isNotEmpty) {
          // Realizar otra solicitud a la URL redirigida
          final redirectedResponse = await http.put(
            Uri.parse(redirectedUrl),
            body: jsonEncode(likeData),
            headers: {
              'Content-Type': 'application/json',
            },
          );
          if (redirectedResponse.statusCode == 200 ||
              redirectedResponse.statusCode == 204) {
            print('Like guardado exitosamente');
          } else {
            print('Error al guardar el like: ${redirectedResponse.statusCode}');
          }
        } else {
          print('Error: URL de redirección vacía');
        }
      } else {
        print('Error al guardar el like: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en la solicitud HTTP: $error');
    }
  }
}
