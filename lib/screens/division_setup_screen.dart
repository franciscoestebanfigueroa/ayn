import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/furniture_provider.dart';
import '../models/furniture_model.dart';

class DivisionSetupScreen extends StatefulWidget {
  final double furnitureHeight;
  final double furnitureDepth;
  final double furnitureWidth;

  const DivisionSetupScreen({
    required this.furnitureHeight,
    required this.furnitureDepth,
    required this.furnitureWidth,
    Key? key,
  }) : super(key: key);

  @override
  _DivisionSetupScreenState createState() => _DivisionSetupScreenState();
}

class _DivisionSetupScreenState extends State<DivisionSetupScreen> {
  int _divisionCount = 0; // 0 significa área única sin divisiones
  final List<Map<String, dynamic>> _areas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Áreas')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('¿Cuántas divisiones desea?', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (_divisionCount > 0) {
                      setState(() {
                        _divisionCount--;
                        if (_areas.length > _divisionCount + 1) {
                          _areas.removeLast();
                        }
                      });
                    }
                  },
                ),
                Text('$_divisionCount', style: const TextStyle(fontSize: 24)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _divisionCount++;
                      // Asegurar que tenemos suficientes áreas (divisiones + 1)
                      while (_areas.length < _divisionCount + 1) {
                        _areas.add({
                          'width': _divisionCount == 0 
                              ? widget.furnitureWidth 
                              : widget.furnitureWidth / (_divisionCount + 1),
                          'type': 'estante_sin_puerta',
                          'drawers': 0,
                          'shelves': 1,
                          'drawerSpecs': [],
                        });
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _divisionCount + 1, // Mostrar todas las áreas (divisiones + 1)
                itemBuilder: (context, index) {
                  if (index >= _areas.length) {
                    _areas.add({
                      'width': widget.furnitureWidth / (_divisionCount + 1),
                      'type': 'estante_sin_puerta',
                      'drawers': 0,
                      'shelves': 1,
                      'drawerSpecs': [],
                    });
                  }
                  return _buildAreaCard(index, _areas[index]);
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveAreas,
              child: const Text('Guardar Configuración'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard(int index, Map<String, dynamic> area) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Área ${index + 1}', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ancho (cm)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                area['width'] = double.tryParse(value) ?? 0.0;
              },
              controller: TextEditingController(text: area['width'].toStringAsFixed(2)),
            ),
            const SizedBox(height: 15),
            const Text('Tipo de área:'),
            DropdownButtonFormField<String>(
              value: area['type'],
              items: const [
                DropdownMenuItem(value: 'estante_sin_puerta', child: Text('Estante sin puerta')),
                DropdownMenuItem(value: 'estante_con_puerta', child: Text('Estante con puerta')),
                DropdownMenuItem(value: 'cajonera', child: Text('Cajonera')),
              ],
              onChanged: (value) {
                setState(() {
                  area['type'] = value;
                  // Resetear valores cuando cambia el tipo
                  if (value == 'cajonera') {
                    area['shelves'] = 0;
                    area['doors'] = 0;
                  } else if (value == 'estante_con_puerta') {
                    area['drawers'] = 0;
                    area['doors'] = 1;
                  } else {
                    area['drawers'] = 0;
                    area['doors'] = 0;
                  }
                });
              },
            ),
            const SizedBox(height: 15),
            if (area['type'] == 'estante_sin_puerta' || area['type'] == 'estante_con_puerta')
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de estantes',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  area['shelves'] = int.tryParse(value) ?? 1;
                },
                controller: TextEditingController(text: area['shelves'].toString()),
              ),
            if (area['type'] == 'cajonera')
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Text('Número de cajones:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (area['drawers'] > 0) {
                            setState(() {
                              area['drawers']--;
                              if (area['drawerSpecs'].length > area['drawers']) {
                                area['drawerSpecs'].removeLast();
                              }
                            });
                          }
                        },
                      ),
                      Text('${area['drawers']}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() => area['drawers']++);
                        },
                      ),
                    ],
                  ),
                  if (area['drawers'] > 0)
                    ...List.generate(area['drawers'], (drawerIndex) {
                      if (drawerIndex >= area['drawerSpecs'].length) {
                        area['drawerSpecs'].add({'height': 20.0});
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Altura cajón ${drawerIndex + 1} (cm)',
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            area['drawerSpecs'][drawerIndex]['height'] = double.tryParse(value) ?? 20.0;
                          },
                          controller: TextEditingController(
                            text: area['drawerSpecs'][drawerIndex]['height'].toStringAsFixed(2)),
                        ),
                      );
                    }),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _saveAreas() {
    final provider = Provider.of<FurnitureProvider>(context, listen: false);
    
    // Validar anchos
    double totalWidth = 0;
    for (var area in _areas) {
      if (area['width'] <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingrese un ancho válido para todas las áreas')),
        );
        return;
      }
      totalWidth += area['width'];
    }

    // Verificar que la suma de anchos coincida con el ancho del mueble
    if ((totalWidth - widget.furnitureWidth).abs() > 0.1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La suma de anchos (${totalWidth.toStringAsFixed(2)} cm) no coincide con el ancho del mueble (${widget.furnitureWidth} cm)')),
      );
      return;
    }

    final divisions = _areas.map((area) {
      return Division(
        name: 'Área',
        width: area['width'],
        height: widget.furnitureHeight,
        depth: widget.furnitureDepth,
        shelves: area['type'].contains('estante') ? (area['shelves'] ?? 1) : 0,
        doors: area['type'] == 'estante_con_puerta' ? 1 : 0,
        drawers: area['type'] == 'cajonera' ? (area['drawers'] ?? 0) : 0,
        drawerSpecs: area['type'] == 'cajonera' 
            ? List<Map<String, dynamic>>.from(area['drawerSpecs'] ?? []) 
            : [],
      );
    }).toList();

    provider.replaceDivisions(divisions);
    Navigator.pop(context);
  }
}