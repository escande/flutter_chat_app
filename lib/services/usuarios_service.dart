import 'package:http/http.dart' as http;
import 'package:chat_pal/global/enviroment.dart';
import 'package:chat_pal/services/auth_service.dart';
import '../models/aaModels.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    //
    try {
      final uri = Uri.http(Enviroment.apiUrl, 'api/usuarios');
      final resp = await http.get(uri, headers: {
        'content-type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usuariosResponse = usuariosFromJson(resp.body);

      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
