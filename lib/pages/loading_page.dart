// ignore_for_file: prefer_const_constructors, use_build_context_synchronously∫
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_pal/pages/aa_page.dart';
import '../services/auth_service.dart';
import '../services/socket_service.dart';

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
    final socketServ = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authProv.isLoggedIn();

    if (autenticado) {
      //Navigator.pushReplacementNamed(context, 'usuarios');
      //Conecto aqui tambien con el socket
      socketServ.connect();
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
