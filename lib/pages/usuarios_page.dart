// ignore_for_file: prefer_const_constructors, prefer_final_fields
import 'package:chat_pal/models/usuario.dart';
import 'package:chat_pal/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuarios = [
    //
    Usuario(uid: '1', nombre: 'Maria', online: false, email: 'maria@gmail.com'),
    Usuario(uid: '2', nombre: 'Pepe', online: false, email: 'pepe@gmail.com'),
    Usuario(uid: '3', nombre: 'Ricardo', online: false, email: 'ricardo@gmail.com'),
    Usuario(uid: '4', nombre: 'Pepita', online: false, email: 'pepita@gmail.com'),
    Usuario(uid: '5', nombre: 'Eusebio', online: false, email: 'eusebio@gmail.com'),
  ];

  @override
  Widget build(BuildContext context) {
    //
    final authServ = Provider.of<AuthService>(context);
    final usuario = authServ.usuario;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            usuario.nombre,
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
            onPressed: () {
              //
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: [
            //
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.check_circle,
                color: Colors.blue[200],
              ),
            )
          ],
        ),
        body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onLoading: _onLoading,
            onRefresh: _onRefresh,
            header: WaterDropHeader(
              waterDropColor: Colors.blue,
            ),
            child: _listViewusers()));
  }

  ListView _listViewusers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (_, i) => Divider(),
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(child: Text(usuario.nombre.substring(0, 2))),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    // if(mounted)
    // setState(() {

    // });
    _refreshController.loadComplete();
  }
}
