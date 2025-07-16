import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/config_provider.dart';
import '../models/config_model.dart';

class ConfigScreen extends StatelessWidget {
  static const String routeName = '/config';
  final _formKey = GlobalKey<FormState>();
  
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _boardPriceController = TextEditingController();
  final _edgePriceController = TextEditingController();
  final _hingePriceController = TextEditingController();
  final _sliderPriceController = TextEditingController();
  final _screwPriceController = TextEditingController();
  final _laborController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context).config;
    
    // Inicializar controladores con valores actuales
    _widthController.text = config.boardWidth.toString();
    _heightController.text = config.boardHeight.toString();
    _boardPriceController.text = config.boardPrice.toStringAsFixed(2);
    _edgePriceController.text = config.edgePrice.toStringAsFixed(2);
    _hingePriceController.text = config.hingePrice.toStringAsFixed(2);
    _sliderPriceController.text = config.sliderPrice.toStringAsFixed(2);
    _screwPriceController.text = config.screwPrice.toStringAsFixed(2);
    _laborController.text = config.laborPercentage.toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Materiales'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dimensiones de Placa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildNumberField(
                      _widthController,
                      'Ancho (cm)',
                      Icons.straighten,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildNumberField(
                      _heightController,
                      'Alto (cm)',
                      Icons.height,
                    ),
                  ),
                ],
              ),
              const Divider(height: 30),
              
              const Text(
                'Precios de Materiales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildNumberField(
                _boardPriceController,
                'Precio placa melamina (\$)',
                Icons.attach_money,
              ),
              const SizedBox(height: 10),
              _buildNumberField(
                _edgePriceController,
                'Precio tapa canto (\$/metro)',
                Icons.attach_money,
              ),
              const SizedBox(height: 10),
              _buildNumberField(
                _hingePriceController,
                'Precio bisagra (\$)',
                Icons.attach_money,
              ),
              const SizedBox(height: 10),
              _buildNumberField(
                _sliderPriceController,
                'Precio corredera (\$)',
                Icons.attach_money,
              ),
              const SizedBox(height: 10),
              _buildNumberField(
                _screwPriceController,
                'Precio tornillos (\$/unidad)',
                Icons.attach_money,
              ),
              const Divider(height: 30),
              
              const Text(
                'Mano de Obra',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildNumberField(
                _laborController,
                'Porcentaje mano de obra (%)',
                Icons.construction,
              ),
              const SizedBox(height: 30),
              
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('GUARDAR CONFIGURACIÓN'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Provider.of<ConfigProvider>(context, listen: false).updateConfig(
                        Config(
                          boardWidth: double.parse(_widthController.text),
                          boardHeight: double.parse(_heightController.text),
                          boardPrice: double.parse(_boardPriceController.text),
                          edgePrice: double.parse(_edgePriceController.text),
                          hingePrice: double.parse(_hingePriceController.text),
                          sliderPrice: double.parse(_sliderPriceController.text),
                          screwPrice: double.parse(_screwPriceController.text),
                          laborPercentage: double.parse(_laborController.text),
                        )
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Configuración guardada correctamente'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obligatorio';
        if (double.tryParse(value) == null) return 'Ingrese un número válido';
        if (double.parse(value) <= 0) return 'Debe ser mayor que cero';
        return null;
      },
    );
  }
}