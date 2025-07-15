import 'package:flutter/material.dart';
import '../models/furniture_model.dart';

class DivisionWidget extends StatelessWidget {
  final Division division;
  final VoidCallback onDelete;

  const DivisionWidget({
    required this.division,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    String type;
    if (division.drawers > 0) {
      type = 'Cajonera (${division.drawers} cajones)';
    } else if (division.doors > 0) {
      type = 'Estante con puerta';
    } else {
      type = 'Estante sin puerta';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('División', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
            Text('Ancho: ${division.width.toStringAsFixed(2)} cm'),
            Text('Tipo: $type'),
            if (division.shelves > 0) Text('Estantes: ${division.shelves}'),
          ],
        ),
      ),
    );
  }
}