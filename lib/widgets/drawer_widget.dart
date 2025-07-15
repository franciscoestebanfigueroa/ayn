import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  final List<Map<String, dynamic>> drawerSpecs;

  const DrawerWidget({
    required this.drawerSpecs,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.only(top: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Detalles de Cajones:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ...drawerSpecs.asMap().entries.map<Widget>((entry) {
              final index = entry.key;
              final drawer = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Text(
                      'Cajón ${index + 1}: ',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${drawer['height']?.toStringAsFixed(2) ?? '0.00'} cm',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}