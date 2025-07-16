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
void updateFurnitureWithDrawers(List<Map<String, dynamic>> drawerSpecs) {
  _furniture = Furniture(
    width: _furniture.width,
    height: _furniture.height,
    depth: _furniture.depth,
    divisions: _furniture.divisions,
    drawerSpecs: drawerSpecs,
  );
  notifyListeners();
}
 Map<String, dynamic> calculateCosts(Config config) {
  double totalArea18mm = 0;
  double totalArea5mm = 0;
  int totalHinges = 0;
  int totalSliders = 0;
  double totalEdgeLength = 0;
  int totalScrews = 0;

  // Partes principales (18mm)
  totalArea18mm += 2 * (_furniture.height * _furniture.depth); // Laterales
  totalArea18mm += _furniture.width * _furniture.depth; // Piso
  totalArea18mm += _furniture.width * _furniture.depth; // Techo

  // Determinar si es mueble vertical (divisiones horizontales)
  bool isVertical = _furniture.divisions.isNotEmpty && 
                   _furniture.divisions.first.width == _furniture.width;

  // Calcular separaciones
  if (_furniture.divisions.isNotEmpty) {
    if (isVertical) {
      // Para muebles verticales (divisiones horizontales)
      int numberOfSeparations = _furniture.divisions.length - 1;
      totalArea18mm += numberOfSeparations * _furniture.width * _furniture.depth;
    } else {
      // Para muebles horizontales (divisiones verticales)
      int numberOfSeparations = _furniture.divisions.length - 1;
      totalArea18mm += numberOfSeparations * _furniture.height * _furniture.depth;
    }
  }

  // Calcular componentes para cada área
  for (Division area in _furniture.divisions) {
    // Estantes (18mm)
    totalArea18mm += area.shelves * (area.width * area.depth);
    
    // Puertas (18mm) - solo para muebles horizontales
    if (!isVertical && area.doors > 0) {
      totalArea18mm += area.width * area.height;
      totalHinges += 2 * area.doors;
    }
    
    // Cajones
    for (Map<String, dynamic> drawer in area.drawerSpecs) {
      double drawerHeight = drawer['height'];
      totalArea18mm += 2 * (drawerHeight * area.depth); // Laterales cajón
      totalArea18mm += area.width * drawerHeight; // Frente cajón
      totalArea18mm += area.width * drawerHeight; // Trasera cajón
      totalArea5mm += area.width * area.depth; // Fondo cajón
      totalSliders += 1;
    }
  }

  // Cálculo de cantos (perímetro de todas las piezas visibles)
  totalEdgeLength += 2 * (_furniture.width + _furniture.height) * 2; // Laterales
  totalEdgeLength += 2 * (_furniture.width + _furniture.depth) * 2; // Piso y techo
  
  // Tornillos estimados (base + por área/división)
  totalScrews = 50 + (_furniture.divisions.length * 20);

  // Cálculo de costos
  double boardCost18mm = (totalArea18mm / (config.boardWidth * config.boardHeight)) * config.boardPrice;
  double boardCost5mm = (totalArea5mm / (config.boardWidth * config.boardHeight)) * (config.boardPrice * config.thinBoardFactor);
  double hingesCost = totalHinges * config.hingePrice;
  double slidersCost = totalSliders * config.sliderPrice;
  double edgeCost = (totalEdgeLength / 100) * config.edgePrice;
  double screwsCost = totalScrews * config.screwPrice;
  
  double materialsCost = boardCost18mm + boardCost5mm + hingesCost + slidersCost + edgeCost + screwsCost;
  double laborCost = materialsCost * (config.laborPercentage / 100);
  double totalCost = materialsCost + laborCost;

  return {
    'totalArea18mm': totalArea18mm,
    'totalArea5mm': totalArea5mm,
    'boardCost18mm': boardCost18mm,
    'boardCost5mm': boardCost5mm,
    'hingesCost': hingesCost,
    'slidersCost': slidersCost,
    'edgeCost': edgeCost,
    'screwsCost': screwsCost,
    'materialsCost': materialsCost,
    'laborCost': laborCost,
    'totalCost': totalCost,
    'totalHinges': totalHinges,
    'totalSliders': totalSliders,
    'totalEdgeLength': totalEdgeLength,
    'totalScrews': totalScrews,
  };
}

// ... (código existente)





}