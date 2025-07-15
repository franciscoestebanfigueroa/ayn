import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/config_provider.dart';
import '../models/config_model.dart';

class ConfigScreen extends StatelessWidget {
  static const String routeName = '/config';
  final _formKey = GlobalKey<FormState>();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _priceController = TextEditingController();
  final _hingeController = TextEditingController();
  final _sliderController = TextEditingController();
  final _laborController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigProvider>(context).config;
    
    _widthController.text = config.boardWidth.toString();
    _heightController.text = config.boardHeight.toString();
    _priceController.text = config.boardPrice.toString();
    _hingeController.text = config.hingePrice.toString();
    _sliderController.text = config.sliderPrice.toString();
    _laborController.text = config.laborPercentage.toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_widthController, 'Ancho placa (cm)', TextInputType.number),
              _buildTextField(_heightController, 'Alto placa (cm)', TextInputType.number),
              _buildTextField(_priceController, 'Precio placa (\$)', TextInputType.number),
              _buildTextField(_hingeController, 'Precio bisagra (\$)', TextInputType.number),
              _buildTextField(_sliderController, 'Precio corredera (\$)', TextInputType.number),
              _buildTextField(_laborController, 'Mano de obra (%)', TextInputType.number),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<ConfigProvider>(context, listen: false).updateConfig(
                      Config(
                        boardWidth: double.parse(_widthController.text),
                        boardHeight: double.parse(_heightController.text),
                        boardPrice: double.parse(_priceController.text),
                        hingePrice: double.parse(_hingeController.text),
                        sliderPrice: double.parse(_sliderController.text),
                        laborPercentage: double.parse(_laborController.text),
                      )
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Configuración guardada!')),
                    );
                  }
                },
                child: const Text('Guardar Configuración'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Campo obligatorio';
          if (double.tryParse(value) == null) return 'Valor inválido';
          return null;
        },
      ),
    );
  }
}