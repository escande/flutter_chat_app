// ignore_for_file: constant_identifier_names, prefer_final_fields, unused_field, avoid_print, library_prefixes, prefer_interpolation_to_compose_strings
import 'package:flutter/cupertino.dart';
import 'package:chat_pal/global/enviroment.dart';
import 'package:chat_pal/services/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  //
  Online,
  Offline,
  Connecting
}

class SocketService extends ChangeNotifier {
  //
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  SocketService() {
    //
    //_initConfig();
  }

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket!;

  Function get emit => _socket!.emit;

  void connect() async {
    final token = await AuthService.getToken();

    _socket = IO.io(
        Enviroment.socketUrl,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect() // disable auto-connection
            .enableForceNew()
            .setExtraHeaders({'foo': 'bar'}) // optional
            .setExtraHeaders({
              //
              'x-token': token
            }) //Enviamos el token para autenticar el soket
            .build());

    //Connect to the server
    _socket!.onConnect((_) {
      print('connect');
      _serverStatus = ServerStatus.Online;

      notifyListeners();
    });

    //socket.emit('msg', 'test'););
    //Disconnect server
    _socket!.onDisconnect((_) {
      print('disconnect');
      _serverStatus = ServerStatus.Offline;

      notifyListeners();
    });

    // _socket!.on('bandas-activas', (payload) {
    //   //
    //   print(payload);
    //   //1ª forma de hacerlo
    //   //_bands = List<Band>.from(payload.map((x) => Band.fromMap(x)));

    //   //2ª forma de hacerlo
    //   _bands = (payload as List).map((e) => Band.fromMap(e)).toList();
    // });
    //When an event recieved from server, data is added to the stream
    _socket!.on('nuevo-mensaje', (payload) {
      //
      print('Nuevo mensaje');
      print('Nombre ' + payload['nombre']);
      print('Mensaje ' + payload['mensaje']);
      print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'No hay');
    });
  }

  void disconnect() {
    _socket!.disconnect();
  }
}
