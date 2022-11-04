// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key, required this.texto}) : super(key: key);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 40),
        width: 150,
        child: Column(
          children: [
            //
            Image(image: AssetImage('assets/tag-logo.png')),
            SizedBox(
              height: 20,
            ),
            Text(
              texto,
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
