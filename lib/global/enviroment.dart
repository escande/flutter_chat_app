import 'dart:io';

class Enviroment {
  //
  static String apiUrl = Platform.isAndroid ? '10.0.2.2:3001' : 'localhost:3001/api';
  static String socketUrl =
      Platform.isAndroid ? 'http://10.0.2.2:3001' : 'http://localhost:3001';
}
