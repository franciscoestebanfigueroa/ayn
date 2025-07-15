import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/config_provider.dart';  // Asegúrate que esta ruta es correcta
import 'providers/furniture_provider.dart';  // Asegúrate que esta ruta es correcta
import 'screens/config_screen.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ConfigProvider()),
        ChangeNotifierProvider(create: (ctx) => FurnitureProvider()),  // Ahora debería reconocerse
      ],
      child: MaterialApp(
        title: 'Calculadora de Melamina',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:  CalculatorScreen(),
        routes: {
          ConfigScreen.routeName: (ctx) =>  ConfigScreen(),
        },
      ),
    );
  }
}