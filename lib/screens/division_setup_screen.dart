import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/furniture_provider.dart';
import '../models/furniture_model.dart';

class DivisionSetupScreen extends StatefulWidget {
  final double furnitureHeight;
  final double furnitureDepth;

  const DivisionSetupScreen({
    required this.furnitureHeight,
    required this.furnitureDepth,
    Key? key,
  }) : super(key: key);

  @override
  _DivisionSetupScreenState createState() => _DivisionSetupScreenState();
}

class _DivisionSetupScreenState extends State<DivisionSetupScreen> {
  int _divisionCount = 1;
  final List<Map<String, dynamic>> _divisions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar Divisiones')),
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
                    if (_divisionCount > 1) {
                      setState(() {
                        _divisionCount--;
                        if (_divisions.length > _divisionCount) {
                          _divisions.removeLast();
                        }
                      });
                    }
                  },
                ),
                Text('$_divisionCount', style: const TextStyle(fontSize: 24)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() => _divisionCount++);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _divisionCount,
                itemBuilder: (context, index) {
                  if (index >= _divisions.length) {
                    _divisions.add({
                      'width': 0.0,
                      'type': 'estante_sin_puerta',
                      'drawers': 0,
                      'shelves': 1,
                      'drawerSpecs': [],
                    });
                  }
                  return _buildDivisionCard(index, _divisions[index]);
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveDivisions,
              child: const Text('Guardar Divisiones'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivisionCard(int index, Map<String, dynamic> division) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('División ${index + 1}', 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ancho (cm)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                division['width'] = double.tryParse(value) ?? 0.0;
              },
            ),
            const SizedBox(height: 15),
            const Text('Tipo de división:'),
            DropdownButtonFormField<String>(
              value: division['type'],
              items: const [
                DropdownMenuItem(value: 'estante_sin_puerta', child: Text('Estante sin puerta')),
                DropdownMenuItem(value: 'estante_con_puerta', child: Text('Estante con puerta')),
                DropdownMenuItem(value: 'cajonera', child: Text('Cajonera')),
              ],
              onChanged: (value) {
                setState(() {
                  division['type'] = value;
                });
              },
            ),
            const SizedBox(height: 15),
            if (division['type'] == 'estante_sin_puerta' || division['type'] == 'estante_con_puerta')
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de estantes',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  division['shelves'] = int.tryParse(value) ?? 1;
                },
              ),
            if (division['type'] == 'cajonera')
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
                          if (division['drawers'] > 0) {
                            setState(() => division['drawers']--);
                          }
                        },
                      ),
                      Text('${division['drawers']}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() => division['drawers']++);
                        },
                      ),
                    ],
                  ),
                  if (division['drawers'] > 0)
                    ...List.generate(division['drawers'], (drawerIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Altura cajón ${drawerIndex + 1} (cm)',
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            if (drawerIndex >= division['drawerSpecs'].length) {
                              division['drawerSpecs'].add({'height': double.tryParse(value) ?? 20.0});
                            } else {
                              division['drawerSpecs'][drawerIndex]['height'] = double.tryParse(value) ?? 20.0;
                            }
                          },
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

  void _saveDivisions() {
    final provider = Provider.of<FurnitureProvider>(context, listen: false);
    
    // Validar anchos
    for (var division in _divisions) {
      if (division['width'] <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingrese un ancho válido para todas las divisiones')),
        );
        return;
      }
    }

    final divisions = _divisions.map((div) {
      return Division(
        name: 'División',
        width: div['width'],
        height: widget.furnitureHeight,
        depth: widget.furnitureDepth,
        shelves: div['type'].contains('estante') ? (div['shelves'] ?? 1) : 0,
        doors: div['type'] == 'estante_con_puerta' ? 1 : 0,
        drawers: div['type'] == 'cajonera' ? (div['drawers'] ?? 0) : 0,
        drawerSpecs: div['type'] == 'cajonera' ? (div['drawerSpecs'] ?? []) : [],
      );
    }).toList();

    provider.replaceDivisions(divisions);
    Navigator.pop(context);
  }
}