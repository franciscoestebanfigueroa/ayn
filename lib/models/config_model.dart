class Config {
  final double boardWidth;
  final double boardHeight;
  final double boardPrice;
  final double hingePrice;
  final double sliderPrice;
  final double laborPercentage;
  final double thinBoardFactor;
  
  const Config({
    required this.boardWidth,
    required this.boardHeight,
    required this.boardPrice,
    required this.hingePrice,
    required this.sliderPrice,
    required this.laborPercentage,
    this.thinBoardFactor = 0.7,
  });
}