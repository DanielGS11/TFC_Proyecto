import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba_1/result_screen.dart';

import 'game_portrait_screen.dart';
import 'in_game_screen.dart';

void main() {
  // Asegurar inicio
  WidgetsFlutterBinding.ensureInitialized();
  // Aqui ponemos la orientacion a bloquear
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Bloquea en modo vertical
    // DeviceOrientation.landscapeLeft, // Descomenta para bloquear en modo horizontal
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/portrait',

      routes: {
        '/portrait': (context) => GamePortraitScreen(),
        '/in_game': (context) => InGameScreen(),
        '/result': (context) => ResultScreen(),
      },
    );
  }
}
