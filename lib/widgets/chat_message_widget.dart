// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {Key? key,
      required this.texto,
      required this.uid,
      required this.animationController})
      : super(key: key);

  final String texto;
  final String uid;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    //
    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
        opacity: animationController,
        child: Container(
            child: uid == authService.usuario.uid ? _myMessage() : _notMyMessage()));
  }

  //CurvedAnimation(parent: animationController, curve: Curves.easeOut)

  @override
  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 10, left: 50, right: 5),
        padding: EdgeInsets.all(8),
        child: Text(
          texto,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Color(0xff4d9efe), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  @override
  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10, left: 5, right: 50),
        padding: EdgeInsets.all(8),
        child: Text(
          texto,
          style: TextStyle(color: Colors.black87),
        ),
        decoration: BoxDecoration(
            color: Color(0xffe4e5e8), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
