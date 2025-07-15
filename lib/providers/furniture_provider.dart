import 'package:flutter/material.dart';
import '../models/furniture_model.dart';

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
    _furniture.divisions = newDivisions;
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

  Map<String, dynamic> calculateCosts( config) {
    double totalArea18mm = 0;
    double totalArea5mm = 0;
    int totalHinges = 0;
    int totalSliders = 0;

    // Partes principales (18mm)
    totalArea18mm += 2 * (_furniture.height * _furniture.depth); // Laterales
    totalArea18mm += 2 * (_furniture.width * _furniture.depth); // Piso + techo

    // Divisiones internas
    for (var division in _furniture.divisions) {
      // Madera división vertical (18mm)
      totalArea18mm += division.height * _furniture.depth;
      
      // Estantes (18mm)
      totalArea18mm += division.shelves * (division.width * _furniture.depth);
      
      // Puertas (18mm)
      if (division.doors == 1) {
        totalArea18mm += division.width * division.height;
        totalHinges += 2;
      }
      
      // Cajones (5mm)
      for (var drawer in division.drawerSpecs) {
        double drawerHeight = drawer['height'];
        totalArea5mm += 2 * (drawerHeight * _furniture.depth); // Laterales
        totalArea5mm += 2 * (drawerHeight * division.width); // Frente/trasera
        totalArea5mm += division.width * _furniture.depth; // Fondo
        totalSliders += 1;
      }
    }

    // Cálculo de costos
    double boardCost18mm = (totalArea18mm / (config.boardWidth * config.boardHeight)) * config.boardPrice;
    double boardCost5mm = (totalArea5mm / (config.boardWidth * config.boardHeight)) * (config.boardPrice * config.thinBoardFactor);
    double hingesCost = (totalHinges * config.hingePrice).toDouble();
    double slidersCost = (totalSliders * config.sliderPrice).toDouble() ;
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