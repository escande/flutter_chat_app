// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:chat_pal/pages/aa_page.dart';
import 'package:chat_pal/pages/usuarios_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //

    return Scaffold(
      body: FutureBuilder(
        future: checkTokenState(context),
        builder: ((context, snapshot) {
          //
          return Center(child: Text('Loading ...'));
        }),
      ),
    );
  }

  Future checkTokenState(BuildContext context) async {
    final authProv = Provider.of<AuthService>(context, listen: false);

    final resp = await authProv.isLoggedIn();

    if (resp) {
      //Navigator.pushReplacementNamed(context, 'usuarios');
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => UsuariosPage(),
            transitionDuration: Duration(microseconds: 0)),
      );
    } else {
      await authProv.logout();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginPage(),
            transitionDuration: Duration(microseconds: 0)),
      );
    }
  }
}
