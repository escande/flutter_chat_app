// ignore_for_file: prefer_const_constructors
import 'package:chat_pal/routes/routes.dart';
import 'package:chat_pal/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Test Datalogic',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
