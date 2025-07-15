import 'package:ayn/screens/config_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/furniture_provider.dart';
import '../providers/config_provider.dart';
import 'division_setup_screen.dart';
import '../widgets/division_widget.dart';
import '../widgets/drawer_widget.dart';

class CalculatorScreen extends StatelessWidget {
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _depthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final furnitureProvider = Provider.of<FurnitureProvider>(context);
    final configProvider = Provider.of<ConfigProvider>(context);
    final furniture = furnitureProvider.furniture;
    final results = furnitureProvider.calculateCosts(configProvider.config);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Muebles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, ConfigScreen.routeName),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Dimensiones Principales:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(child:_buildDimensionField(_widthController, 'Ancho (cm)', furniture.width.toString())),
                const SizedBox(width: 10),
                Expanded(child:_buildDimensionField(_heightController, 'Alto (cm)', furniture.height.toString())),
                const SizedBox(width: 10),
                Expanded(child:_buildDimensionField(_depthController, 'Profundidad (cm)', furniture.depth.toString())),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    furnitureProvider.updateDimensions(
                      double.parse(_widthController.text),
                      double.parse(_heightController.text),
                      double.parse(_depthController.text),
                    );
                  },
                ),
              ],
            ),
            
            const Divider(thickness: 2),
            const Text('Divisiones:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._buildDivisionList(furnitureProvider, furniture),
            ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DivisionSetupScreen(
          furnitureHeight: furniture.height,
          furnitureDepth: furniture.depth,
          furnitureWidth: furniture.width,
        ),
      ),
    );
  },
  child: const Text('Configurar Áreas'),
),
            
            const Divider(thickness: 2),
            const Text('Resultados:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildResultsCard(context, results),
          ],
        ),
      ),
    );
  }

  Widget _buildDimensionField(TextEditingController controller, String label, String value) {
    controller.text = value;
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
    );
  }

  List<Widget> _buildDivisionList(FurnitureProvider provider,  furniture) {
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
  

  Widget _buildResultsCard(BuildContext context, Map<String, dynamic> results) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildResultRow('Área melamina 18mm:', '${results['totalArea18mm'].toStringAsFixed(2)} cm²'),
            _buildResultRow('Área melamina 5mm:', '${results['totalArea5mm'].toStringAsFixed(2)} cm²'),
            _buildResultRow('Costo melamina 18mm:', '\$${results['boardCost18mm'].toStringAsFixed(2)}'),
            _buildResultRow('Costo melamina 5mm:', '\$${results['boardCost5mm'].toStringAsFixed(2)}'),
            _buildResultRow('Bisagras (${results['totalHinges']}):', '\$${results['hingesCost'].toStringAsFixed(2)}'),
            _buildResultRow('Correderas (${results['totalSliders']}):', '\$${results['slidersCost'].toStringAsFixed(2)}'),
            _buildResultRow('Costo materiales:', '\$${results['materialsCost'].toStringAsFixed(2)}'),
            _buildResultRow('Mano de obra (${Provider.of<ConfigProvider>(context).config.laborPercentage}%):', 
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
}