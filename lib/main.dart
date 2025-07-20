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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Activando Material 3 para un look más moderno
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:HomeScreen(), // Nueva pantalla de inicio
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
      appBar: AppBar(
        title: const Text('A & N Muebles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/config'),
          ),
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/logoicon.jpg',
                height: 150, // Ajusta la altura según necesites
              ),
              const SizedBox(height: 40),
              const Text(
                'Seleccione el tipo de mueble a presupuestar:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.width_wide),
                onPressed: () => Navigator.pushNamed(context, '/horizontal'),
                label: const Text('Mueble Horizontal (Ej: Escritorio)'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.height),
                onPressed: () => Navigator.pushNamed(context, '/vertical'),
                label: const Text('Mueble Vertical (Ej: Ropero)'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
