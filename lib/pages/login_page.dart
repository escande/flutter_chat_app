// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_pal/helpers/mostrar_alerta.dart';
import 'package:chat_pal/services/auth_service.dart';
import 'package:chat_pal/services/socket_service.dart';
import 'package:chat_pal/widgets/aa_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xfff2f2f2),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * .9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  LogoWidget(texto: 'Messeger'),
                  _Form(),
                  LabelsWidget(
                    ruta: 'register',
                    titulo: '¿No tienes cuenta?',
                    subTitulo: 'Crea una ahora !!',
                  ),
                  Text(
                    'Terminos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({
    Key? key,
  }) : super(key: key);

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //
    final authProv = Provider.of<AuthService>(context);
    final socketServ = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          //
          CustomInputWidget(
            icon: Icons.email_outlined,
            placeholder: 'Email',
            keyboradType: TextInputType.emailAddress,
            textController: emailCtrl,
            isPassword: false,
          ),
          CustomInputWidget(
            icon: Icons.lock_clock_outlined,
            placeholder: 'Password',
            keyboradType: TextInputType.visiblePassword,
            textController: passCtrl,
            isPassword: true,
          ),
          CustomButtonWidget(
            texto: 'Ingresar',
            funcion: authProv.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    // print(emailCtrl.text);
                    // print(passCtrl.text);
                    final loginOk =
                        await authProv.login(emailCtrl.text.trim(), passCtrl.text.trim());

                    if (loginOk) {
                      //Si es OK, conectamos con el socketService
                      socketServ.connect();

                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      //Mostrar una alerta
                      mostrarAlerta(
                          context, 'Login Incorrecto', 'Revise las credenciales');
                    }
                  },
          ),
        ],
      ),
    );
  }
}
