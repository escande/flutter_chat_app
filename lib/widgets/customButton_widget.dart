// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({super.key, required this.funcion, required this.texto});

  final VoidCallback? funcion;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: funcion,
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
              texto,
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ));
  }
}
