// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_final_fields
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_pal/models/mensajes_response.dart';
import 'package:chat_pal/services/auth_service.dart';
import 'package:chat_pal/services/socket_service.dart';
import 'package:chat_pal/widgets/chat_message_widget.dart';
import '../services/chat_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final textController = TextEditingController();
  final focusNode = FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  bool _estaScribiendo = false;
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    //Cargar historia
    _cargarHistoria(chatService.usuarioPara.uid);
  }

  void _cargarHistoria(String usuarioID) async {
    //
    List<Mensaje> chat = await chatService.getChat(usuarioID);

    //print(chat);
    final history = chat
        .map((m) => ChatMessage(
              texto: m.mensaje,
              uid: m.de,
              animationController:
                  AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
                    ..forward(),
            ))
        .toList();

    setState(() {
      _messages.insertAll(0, history);
    });

    //print(_messages);
  }

  void _escucharMensaje(dynamic data) {
    //
    //print('tengo mensaje - $data');
    ChatMessage message = ChatMessage(
      texto: data['mensaje'],
      uid: data['de'],
      animationController:
          AnimationController(vsync: this, duration: Duration(milliseconds: 1000)),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    //
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            //
            CircleAvatar(
              child: Text(usuarioPara.nombre.substring(0, 2),
                  style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              usuarioPara.nombre,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            //
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) => _messages[index],
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              height: 80,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    //
    return SafeArea(
      bottom: true,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            //
            Flexible(
              child: TextField(
                controller: textController,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  //
                  setState(() {
                    //
                    if (value.trim().length > 0) {
                      _estaScribiendo = true;
                    } else {
                      _estaScribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
                focusNode: focusNode,
              ),
            ),
            //Boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estaScribiendo
                          ? () => _handleSubmit(textController.text)
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            Icons.send,
                          ),
                          onPressed: _estaScribiendo
                              ? () => _handleSubmit(textController.text)
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String txt) {
    //print(txt);
    if (txt.isEmpty) return;

    textController.clear();
    focusNode.requestFocus();

    final chatMessage = ChatMessage(
      uid: authService.usuario.uid,
      texto: txt,
      animationController:
          AnimationController(vsync: this, duration: Duration(milliseconds: 200)),
    );

    _messages.insert(0, chatMessage);

    chatMessage.animationController.forward();

    setState(() {
      _estaScribiendo = false;
    });

    socketService.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': txt
    });
  }

  @override
  void dispose() {
    // TODO: implementar sockets

    for (ChatMessage message in _messages) {
      //
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
