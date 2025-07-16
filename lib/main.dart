import 'package:ayn/screens/vertical_furniture_screen.dart';
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
        ChangeNotifierProvider(create: (ctx) => FurnitureProvider()),
      ],
      child: MaterialApp(
        title: 'Calculadora de Melamina',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(), // Nueva pantalla de inicio
        routes: {
          ConfigScreen.routeName: (ctx) =>  ConfigScreen(),
          '/vertical': (ctx) =>  VerticalFurnitureScreen(),
          '/horizontal': (ctx) => CalculatorScreen(),
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Muebles')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/horizontal'),
              child: const Text('Mueble Horizontal'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/vertical'),
              child: const Text('Mueble Vertical'),
            ),
          ],
        ),
      ),
    );
  }
}