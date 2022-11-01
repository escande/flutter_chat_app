// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_pal/models/aaModels.dart';
import '../global/enviroment.dart';

class AuthService extends ChangeNotifier {
  //
  late Usuario usuario;
  bool _autenticando = false;
  final storage = FlutterSecureStorage();

//Propiedades
//------------------------------------------
  bool get autenticando => _autenticando;
  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  //Getters del token
  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token ?? '';
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.delete(key: 'token');
  }

//Metodos
//------------------------------------------
  Future<bool> login(String email, String psw) async {
    //
    autenticando = true;

    final data = {
      //
      "email": email,
      "password": psw
    };

    final url = Uri.http(Enviroment.apiUrl, 'api/login');

    final resp = await http.post(url, body: jsonEncode(data), headers: {
      //
      'Content-Type': 'application/json'
    });

    //print(resp.body);
    autenticando = false;
    if (resp.statusCode == 200) {
      final loginResp = loginResponseFromJson(resp.body);
      usuario = loginResp.usuario;

      await _guardarToken(loginResp.token);

      return true;
    } else {
      return false;
    }
  }

  Future<String> register(String email, String psw, String nombre) async {
    //
    autenticando = true;

    final data = {
      //
      "nombre": nombre,
      "email": email,
      "password": psw
    };

    final uri = Uri.http(Enviroment.apiUrl, 'api/login/new');

    final resp = await http
        .post(uri, body: jsonEncode(data), headers: {'content-type': 'application/json'});

    //print(resp.body);
    autenticando = false;
    if (resp.statusCode == 200) {
      final loginResp = loginResponseFromJson(resp.body);
      usuario = loginResp.usuario;

      await _guardarToken(loginResp.token);

      return true.toString();
    } else {
      final respNOK = jsonDecode(resp.body);

      if (respNOK.containsKey('msg')) {
        return respNOK['msg'];
      } else {
        final errs = respNOK['errors'];
        String responseErr = '';

        if (errs.containsKey('nombre')) {
          //
          responseErr += errs['nombre']['msg'] + '\n';
        }

        if (errs.containsKey('email')) {
          //
          responseErr += errs['email']['msg'] + '\n';
        }

        if (errs.containsKey('password')) {
          //
          responseErr += errs['password']['msg'] + '\n';
        }

        return responseErr;
      }
    }
  }

  Future<bool> isLoggedIn() async {
    //
    final token = await storage.read(key: 'token');

    print(token);
    if (token != null) {
      final url = Uri.http(Enviroment.apiUrl, 'api/login/renew');

      final resp = await http.get(url, headers: {
        //
        'Content-Type': 'application/json',
        'x-token': token
      });

      if (resp.statusCode == 200) {
        final loginResp = loginResponseFromJson(resp.body);
        usuario = loginResp.usuario;

        await _guardarToken(loginResp.token);

        return true;
      }
    }

    return false;
  }

  Future _guardarToken(String token) async {
    return await storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await storage.delete(key: 'token');
  }
}
