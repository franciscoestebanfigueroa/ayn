import 'package:flutter/material.dart';
import '../models/config_model.dart';

class ConfigProvider with ChangeNotifier {
  Config _config = Config(
    boardWidth: 250,
    boardHeight: 180,
    boardPrice: 150.0,
    hingePrice: 2.5,
    sliderPrice: 8.0,
    laborPercentage: 30.0,
  );

  Config get config => _config;

  void updateConfig(Config newConfig) {
    _config = newConfig;
    notifyListeners();
  }
}