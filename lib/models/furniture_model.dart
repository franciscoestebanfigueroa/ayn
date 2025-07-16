class Furniture {
  double width;
  double height;
  double depth;
  List<Division> divisions;
  List<Map<String, dynamic>> drawerSpecs; // Para cajones en mueble sin divisiones
  
  Furniture({
    required this.width,
    required this.height,
    required this.depth,
    List<Division> divisions = const [],
    List<Map<String, dynamic>> drawerSpecs = const [],
  }) : divisions = List.from(divisions)..removeWhere((div) => div.width <= 0),
       drawerSpecs = List.from(drawerSpecs);
}
class Division {
  String name;
  double width;
  double height;
  double depth;
  int shelves;
  int doors;
  int drawers;
  List<Map<String, dynamic>> drawerSpecs;
  
  Division({
    required this.name,
    required this.width,
    required this.height,
    required this.depth,
    this.shelves = 0,
    this.doors = 0,
    this.drawers = 0,
    List<Map<String, dynamic>> drawerSpecs = const [],
  }) : this.drawerSpecs = drawerSpecs;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Division &&
          runtimeType == other.runtimeType &&
          width == other.width &&
          height == other.height &&
          depth == other.depth &&
          shelves == other.shelves &&
          doors == other.doors &&
          drawers == other.drawers;

  @override
  int get hashCode =>
      width.hashCode ^
      height.hashCode ^
      depth.hashCode ^
      shelves.hashCode ^
      doors.hashCode ^
      drawers.hashCode;
}