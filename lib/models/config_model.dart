class Config {
  final double boardWidth;       // Ancho placa (cm)
  final double boardHeight;      // Alto placa (cm)
  final double boardPrice;       // Precio placa melamina (\$)
  final double edgePrice;        // Precio tapa canto (\$/m)
  final double hingePrice;       // Precio bisagra (\$)
  final double sliderPrice;      // Precio corredera (\$)
  final double screwPrice;       // Precio tornillos (\$/unidad)
  final double laborPercentage;  // % Mano de obra
  final double thinBoardFactor;  // Factor para melamina 5mm

  const Config({
    required this.boardWidth,
    required this.boardHeight,
    required this.boardPrice,
    required this.edgePrice,
    required this.hingePrice,
    required this.sliderPrice,
    required this.screwPrice,
    required this.laborPercentage,
    this.thinBoardFactor = 0.7,
  });
}