// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';

class LabelsWidget extends StatelessWidget {
  const LabelsWidget(
      {Key? key, required this.ruta, required this.titulo, required this.subTitulo})
      : super(key: key);

  final String ruta;
  final String titulo;
  final String subTitulo;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //
          Text(
            titulo,
            style: TextStyle(
                color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            child: Text(
              subTitulo,
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () => Navigator.pushReplacementNamed(context, ruta),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
