import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_pal/models/aaModels.dart';
import 'auth_service.dart';
import '../global/enviroment.dart';
import '../models/mensajes_response.dart';

class ChatService extends ChangeNotifier {
  //
  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioID) async {
    //
    final uri = Uri.http(Enviroment.apiUrl, 'api/mensajes/$usuarioID');

    // print(usuarioID);
    // print(uri);

    final resp = await http.get(uri, headers: {
      'content-type': 'application/json',
      'x-token': await AuthService.getToken()
    });

    final mensajesResponse = mensajesResponseFromJson(resp.body);
    //print(mensajesResponse.mensajes);
    return mensajesResponse.mensajes;
  }
}
