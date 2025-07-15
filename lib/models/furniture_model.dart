class Furniture {
  double width;
  double height;
  double depth;
  List<Division> divisions;
  
  Furniture({
    required this.width,
    required this.height,
    required this.depth,
    List<Division> divisions = const [],
  }) : this.divisions = divisions;
}
class Division {
  String name;
  double width;
  double height; // Ahora será editable independientemente
  double depth;
  int shelves;
  int doors;
  int drawers;
  List<Map<String, dynamic>> drawerSpecs;
  
  Division({
    required this.name,
    required this.width,
    required this.height, // Altura configurable
    required this.depth,
    this.shelves = 0,
    this.doors = 0,
    this.drawers = 0,
    List<Map<String, dynamic>> drawerSpecs = const [],
  }) : this.drawerSpecs = drawerSpecs;
}