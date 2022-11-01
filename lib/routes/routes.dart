// ignore_for_file: prefer_const_constructors

import 'package:chat_pal/pages/aa_page.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  //
  'usuarios': (_) => UsuariosPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'chat': (_) => ChatPage(),
  'loading': (_) => LoadingPage()
};
