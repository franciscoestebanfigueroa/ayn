import 'package:flutter/material.dart';
import '../models/furniture_model.dart';
import '../models/config_model.dart';

class FurnitureProvider with ChangeNotifier {
  Furniture _furniture = Furniture(
    width: 100,
    height: 80,
    depth: 50,
  );

  Furniture get furniture => _furniture;

  void updateDimensions(double width, double height, double depth) {
    _furniture = Furniture(
      width: width,
      height: height,
      depth: depth,
      divisions: _furniture.divisions,
    );
    notifyListeners();
  }

   void replaceDivisions(List<Division> newDivisions) {
    _furniture = Furniture(
      width: _furniture.width,
      height: _furniture.height,
      depth: _furniture.depth,
      divisions: newDivisions, // Esto ahora manejará correctamente la lista
    );
    notifyListeners();
  }

  void removeDivision(int index) {
    _furniture.divisions.removeAt(index);
    notifyListeners();
  }

  void updateDivision(int index, Division newDivision) {
    _furniture.divisions[index] = newDivision;
    notifyListeners();
  }

  Map<String, dynamic> calculateCosts(Config config) {
    double totalArea18mm = 0;
    double totalArea5mm = 0;
    int totalHinges = 0;
    int totalSliders = 0;

    // Partes principales (18mm)
    totalArea18mm += 2 * (_furniture.height * _furniture.depth); // Laterales
    totalArea18mm += _furniture.width * _furniture.depth; // Piso
    totalArea18mm += _furniture.width * _furniture.depth; // Techo

    // Divisiones internas
    for (Division division in _furniture.divisions) {
      // Madera división vertical (18mm) - solo una por división
      totalArea18mm += division.height * division.depth;
      
      // Estantes (18mm)
      totalArea18mm += division.shelves * (division.width * division.depth);
      
      // Puertas (18mm) - solo si tiene puertas
      if (division.doors > 0) {
        totalArea18mm += division.width * division.height;
        totalHinges += 2 * division.doors; // 2 bisagras por puerta
      }
      
      // Cajones (5mm para fondo, 18mm para estructura)
      for (Map<String, dynamic> drawer in division.drawerSpecs) {
        double drawerHeight = drawer['height'];
        totalArea18mm += 2 * (drawerHeight * division.depth); // Laterales del cajón
        totalArea18mm += division.width * drawerHeight; // Frente del cajón
        totalArea18mm += division.width * drawerHeight; // Trasera del cajón
        totalArea5mm += division.width * division.depth; // Fondo del cajón
        totalSliders += 1; // Una corredera por cajón
      }
    }

    // Cálculo de costos
    double boardCost18mm = (totalArea18mm / (config.boardWidth * config.boardHeight)) * config.boardPrice;
    double boardCost5mm = (totalArea5mm / (config.boardWidth * config.boardHeight)) * (config.boardPrice * config.thinBoardFactor);
    double hingesCost = totalHinges * config.hingePrice;
    double slidersCost = totalSliders * config.sliderPrice;
    double materialsCost = boardCost18mm + boardCost5mm + hingesCost + slidersCost;
    double laborCost = materialsCost * (config.laborPercentage / 100);
    double totalCost = materialsCost + laborCost;

    return {
      'totalArea18mm': totalArea18mm,
      'totalArea5mm': totalArea5mm,
      'boardCost18mm': boardCost18mm,
      'boardCost5mm': boardCost5mm,
      'hingesCost': hingesCost,
      'slidersCost': slidersCost,
      'materialsCost': materialsCost,
      'laborCost': laborCost,
      'totalCost': totalCost,
      'totalHinges': totalHinges,
      'totalSliders': totalSliders,
    };
  }
}