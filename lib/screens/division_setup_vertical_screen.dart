import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/furniture_provider.dart';
import '../models/furniture_model.dart';

class DivisionSetupVerticalScreen extends StatefulWidget {
  final double furnitureHeight;
  final double furnitureDepth;
  final double furnitureWidth;

  const DivisionSetupVerticalScreen({
    required this.furnitureHeight,
    required this.furnitureDepth,
    required this.furnitureWidth,
    Key? key,
  }) : super(key: key);

  @override
  _DivisionSetupVerticalScreenState createState() => _DivisionSetupVerticalScreenState();
}

class _DivisionSetupVerticalScreenState extends State<DivisionSetupVerticalScreen> {
  int _divisionCount = 0;
  final List<Map<String, dynamic>> _sections = [];

  @override
  void initState() {
    super.initState();
    _sections.add({
      'height': widget.furnitureHeight,
      'type': 'seccion_superior',
      'shelves': 1,
      'doors': 0,
      'drawers': 0,
      'drawerSpecs': [],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Divisiones Verticales')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('¿Cuántas divisiones verticales desea?', 
                style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (_divisionCount > 0) {
                      setState(() {
                        _divisionCount--;
                        if (_sections.length > _divisionCount + 1) {
                          _sections.removeLast();
                        }
                        _distributeHeights();
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
                      while (_sections.length < _divisionCount + 1) {
                        _sections.add({
                          'height': widget.furnitureHeight / (_divisionCount + 1),
                          'type': 'seccion_media',
                          'shelves': 1,
                          'doors': 0,
                          'drawers': 0,
                          'drawerSpecs': [],
                        });
                      }
                      _distributeHeights();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _divisionCount + 1,
                itemBuilder: (context, index) {
                  return _buildSectionCard(index, _sections[index]);
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveSections,
              child: const Text('Guardar Configuración'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(int index, Map<String, dynamic> section) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sección ${index + 1}', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Alto (cm)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                section['height'] = double.tryParse(value) ?? 0.0;
                _adjustOtherHeights(index, section['height']);
              },
              controller: TextEditingController(text: section['height'].toStringAsFixed(2)),
            ),
            const SizedBox(height: 15),
            const Text('Tipo de sección:'),
            DropdownButtonFormField<String>(
              value: section['type'],
              items: const [
                DropdownMenuItem(
                  value: 'seccion_superior',
                  child: Text('Sección Superior'),
                ),
                DropdownMenuItem(
                  value: 'seccion_media',
                  child: Text('Sección Media'),
                ),
                DropdownMenuItem(
                  value: 'seccion_inferior',
                  child: Text('Sección Inferior'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  section['type'] = value;
                  if (value == 'seccion_superior') {
                    section['drawers'] = 0;
                  } else if (value == 'seccion_inferior') {
                    section['shelves'] = 0;
                  }
                });
              },
            ),
            const SizedBox(height: 15),
            if (section['type'] != 'seccion_inferior')
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de estantes',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  section['shelves'] = int.tryParse(value) ?? 1;
                },
                controller: TextEditingController(text: section['shelves'].toString()),
              ),
            if (section['type'] == 'seccion_inferior')
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
                          if (section['drawers'] > 0) {
                            setState(() {
                              section['drawers']--;
                              if (section['drawerSpecs'].length > section['drawers']) {
                                section['drawerSpecs'].removeLast();
                              }
                            });
                          }
                        },
                      ),
                      Text('${section['drawers']}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() => section['drawers']++);
                        },
                      ),
                    ],
                  ),
                  if (section['drawers'] > 0)
                    ...List.generate(section['drawers'], (drawerIndex) {
                      if (drawerIndex >= section['drawerSpecs'].length) {
                        section['drawerSpecs'].add({'height': 20.0});
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
                            section['drawerSpecs'][drawerIndex]['height'] = double.tryParse(value) ?? 20.0;
                          },
                          controller: TextEditingController(
                            text: section['drawerSpecs'][drawerIndex]['height'].toStringAsFixed(2)),
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

  void _distributeHeights() {
    double remainingHeight = widget.furnitureHeight;
    double equalHeight = remainingHeight / (_divisionCount + 1);

    for (var section in _sections) {
      section['height'] = equalHeight;
    }
    setState(() {});
  }

  void _adjustOtherHeights(int changedIndex, double newHeight) {
    double totalHeight = newHeight;
    for (int i = 0; i < _sections.length; i++) {
      if (i != changedIndex) {
        totalHeight += _sections[i]['height'];
      }
    }

    if (totalHeight > widget.furnitureHeight) {
      double excess = totalHeight - widget.furnitureHeight;
      double totalOtherHeight = totalHeight - newHeight;
      double ratio = (totalOtherHeight - excess) / totalOtherHeight;

      for (int i = 0; i < _sections.length; i++) {
        if (i != changedIndex) {
          _sections[i]['height'] *= ratio;
          if (_sections[i]['height'] < 10) {
            _sections[i]['height'] = 10; // Altura mínima
          }
        }
      }
    }
    setState(() {});
  }

  void _saveSections() {
    final provider = Provider.of<FurnitureProvider>(context, listen: false);
    
    double totalHeight = _sections.fold(0, (sum, section) => sum + (section['height'] ?? 0));
    
    if (_divisionCount > 0 && (totalHeight - widget.furnitureHeight).abs() > 0.1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La suma de alturas (${totalHeight.toStringAsFixed(2)} cm) no coincide con la altura total (${widget.furnitureHeight} cm)')),
      );
      return;
    }

    // Para muebles verticales, usamos el ancho completo para cada división vertical
    final divisions = _sections.map((section) => Division(
      name: 'Sección ${_sections.indexOf(section) + 1}',
      width: widget.furnitureWidth,
      height: section['height'],
      depth: widget.furnitureDepth,
      shelves: section['type'] != 'seccion_inferior' ? (section['shelves'] ?? 1) : 0,
      doors: 0, // Puertas se manejan diferente en vertical
      drawers: section['type'] == 'seccion_inferior' ? (section['drawers'] ?? 0) : 0,
      drawerSpecs: section['type'] == 'seccion_inferior' 
          ? List<Map<String, dynamic>>.from(section['drawerSpecs'] ?? []) 
          : [],
    )).toList();

    provider.replaceDivisions(divisions);
    Navigator.pop(context);
  }
}