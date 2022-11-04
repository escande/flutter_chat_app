// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
  //

  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(titulo),
              content: Text(subtitulo),
              actions: [
                //
                MaterialButton(
                    child: Text('Ok'),
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  }

  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        //
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text('Ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}
