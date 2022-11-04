// To parse this JSON data, do
//
//     final usuarios = usuariosFromJson(jsonString);

import 'dart:convert';
import 'aaModels.dart';

Usuarios usuariosFromJson(String str) => Usuarios.fromJson(json.decode(str));

String usuariosToJson(Usuarios data) => json.encode(data.toJson());

class Usuarios {
  Usuarios({
    required this.ok,
    required this.usuarios,
  });

  bool ok;
  List<Usuario> usuarios;

  factory Usuarios.fromJson(Map<String, dynamic> json) => Usuarios(
        ok: json["ok"],
        usuarios: List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
      };
}
