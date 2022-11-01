// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously
import 'package:chat_pal/services/auth_service.dart';
import 'package:chat_pal/widgets/aa_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/mostrar_alerta.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                  LogoWidget(
                    texto: 'Registro',
                  ),
                  _Form(),
                  LabelsWidget(
                    ruta: 'login',
                    titulo: '¿Ya tienes cuenta?',
                    subTitulo: 'Ingresa ahora',
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
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //
    final authServ = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          //
          CustomInputWidget(
            icon: Icons.verified_user_outlined,
            placeholder: 'Nombre',
            keyboradType: TextInputType.text,
            textController: nameCtrl,
            isPassword: false,
          ),
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
            funcion: authServ.autenticando
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    // print(emailCtrl.text);
                    // print(passCtrl.text);
                    final registrOK = await authServ.register(emailCtrl.text.trim(),
                        passCtrl.text.trim(), nameCtrl.text.trim());

                    if (registrOK == 'true') {
                      //Varias cosas

                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      //Mostrar una alerta
                      mostrarAlerta(context, 'Registro Incorrecto', registrOK.toString());
                    }
                  },
          ),
        ],
      ),
    );
  }
}
