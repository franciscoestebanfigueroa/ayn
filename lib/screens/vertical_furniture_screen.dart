import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/furniture_provider.dart';
import '../providers/config_provider.dart';
import '../models/furniture_model.dart';
import 'division_setup_vertical_screen.dart';
import '../widgets/division_widget.dart';
import '../widgets/drawer_widget.dart';

class VerticalFurnitureScreen extends StatefulWidget {
  @override
  _VerticalFurnitureScreenState createState() => _VerticalFurnitureScreenState();
}

class _VerticalFurnitureScreenState extends State<VerticalFurnitureScreen> {
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _depthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final furniture = Provider.of<FurnitureProvider>(context, listen: false).furniture;
    _widthController.text = furniture.width.toString();
    _heightController.text = furniture.height.toString();
    _depthController.text = furniture.depth.toString();
  }

  @override
  Widget build(BuildContext context) {
    final furnitureProvider = Provider.of<FurnitureProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final furniture = furnitureProvider.furniture;
    final results = furnitureProvider.calculateCosts(configProvider.config);
    final config = configProvider.config;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mueble Vertical'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/config'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Dimensiones Principales:', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(child: _buildDimensionField(_widthController, 'Ancho (cm)')),
                const SizedBox(width: 10),
                Expanded(child: _buildDimensionField(_heightController, 'Alto (cm)')),
                const SizedBox(width: 10),
                Expanded(child: _buildDimensionField(_depthController, 'Profundidad (cm)')),
                Tooltip(
                  message: 'Guardar dimensiones',
                  child: IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: () {
                      final width = double.tryParse(_widthController.text) ?? 0.0;
                      final height = double.tryParse(_heightController.text) ?? 0.0;
                      final depth = double.tryParse(_depthController.text) ?? 0.0;
                      furnitureProvider.updateDimensions(width, height, depth);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
            
            const Divider(thickness: 2),
            const Text('Secciones:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._buildSectionList(furnitureProvider, furniture),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DivisionSetupVerticalScreen(
                      furnitureHeight: furniture.height,
                      furnitureDepth: furniture.depth,
                      furnitureWidth: furniture.width,
                    ),
                  ),
                );
              },
              child: const Text('Configurar Secciones'),
            ),
            
            const Divider(thickness: 2),
            const Text('Resultados:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildResultsCard(context, results, config),
          ],
        ),
      ),
    );
  }

  Widget _buildDimensionField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
    );
  }

  List<Widget> _buildSectionList(FurnitureProvider provider, Furniture furniture) {
    return furniture.divisions.asMap().entries.map<Widget>((entry) {
      final index = entry.key;
      final division = entry.value;
      return Column(
        children: <Widget>[
          DivisionWidget(
            division: division,
            onDelete: () => provider.removeDivision(index),
          ),
          if (division.drawers > 0)
            DrawerWidget(
              drawerSpecs: division.drawerSpecs,
            ),
        ],
      );
    }).toList();
  }

  Widget _buildResultsCard(BuildContext context, Map<String, dynamic> results,  config) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detalle de Costos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildResultRow('Total Area 18mm:', '${(results['totalArea18mm'] / 10000).toStringAsFixed(2)} m²'),
            _buildResultRow('Melamina 18mm:', '\$${results['boardCost18mm'].toStringAsFixed(2)}'),
            _buildResultRow('Melamina 5mm:', '\$${results['boardCost5mm'].toStringAsFixed(2)}'),
            _buildResultRow('Tapa cantos (${results['totalEdgeLength'].toStringAsFixed(2)} cm):', '\$${results['edgeCost'].toStringAsFixed(2)}'),
            _buildResultRow('Bisagras (${results['totalHinges']}):', '\$${results['hingesCost'].toStringAsFixed(2)}'),
            _buildResultRow('Correderas (${results['totalSliders']}):', '\$${results['slidersCost'].toStringAsFixed(2)}'),
            _buildResultRow('Tornillos (${results['totalScrews']}):', '\$${results['screwsCost'].toStringAsFixed(2)}'),
            const Divider(),
            _buildResultRow('Total materiales:', '\$${results['materialsCost'].toStringAsFixed(2)}'),
            _buildResultRow('Mano de obra (${config.laborPercentage}%):', 
                '\$${results['laborCost'].toStringAsFixed(2)}'),
            const Divider(),
            _buildResultRow('TOTAL FINAL:', '\$${results['totalCost'].toStringAsFixed(2)}', isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
          )),
          Text(value, style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
          )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    _depthController.dispose();
    super.dispose();
  }
}