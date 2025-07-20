// lib/services/pdf_service.dart

import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/config_model.dart';
import '../models/furniture_model.dart';

class PdfService {
  Future<String> generateQuotePdf({
    required Map<String, dynamic> results,
    required Furniture furniture,
    required Config config,
  }) async {
    final pdf = pw.Document();
    // Opcional: Cargar una fuente que soporte símbolos como '$'
    // final font = await PdfGoogleFonts.robotoRegular();

    // Cargar la imagen del logo desde los assets
    final logoByteData = await rootBundle.load('assets/logoicon.jpg');
    final logoImage = pw.MemoryImage(logoByteData.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        header: (context) => _buildHeader(logoImage),
        build: (pw.Context context) {
          return [
            _buildTitle(),
            _buildDimensions(furniture),
            pw.Divider(height: 20),
            _buildCostDetails(results, config),
            pw.Divider(height: 20),
            _buildTotals(results, config),
          ];
        },
        footer: (context) => _buildFooter(),
      ),
    );

    // Guardar el PDF en un directorio temporal
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/presupuesto_mueble.pdf");
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  pw.Widget _buildHeader(pw.ImageProvider logo) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 15),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey, width: 1.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.SizedBox(
            height: 50,
            width: 50,
            child: pw.Image(logo),
          ),
          pw.Text('Presupuesto de Mueble',
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, fontSize: 24, color: PdfColors.blueGrey800)),
        ],
      ),
    );
  }

  pw.Widget _buildTitle() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Detalle del Presupuesto',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Generado el: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
        pw.SizedBox(height: 20),
      ],
    );
  }

  pw.Widget _buildDimensions(Furniture furniture) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Dimensiones Generales:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
        pw.SizedBox(height: 5),
        pw.Text('Ancho: ${furniture.width.toStringAsFixed(2)} cm'),
        pw.Text('Alto: ${furniture.height.toStringAsFixed(2)} cm'),
        pw.Text('Profundidad: ${furniture.depth.toStringAsFixed(2)} cm'),
      ],
    );
  }

  pw.Widget _buildCostDetails(Map<String, dynamic> results, Config config) {
    final data = <List<String>>[
      ['Concepto', 'Detalle', 'Costo'],
      [
        'Melamina 18mm',
        '${(results['totalArea18mm'] / 10000).toStringAsFixed(2)} m²',
        '${results['boardCost18mm'].toStringAsFixed(2)}'
      ],
      [
        'Melamina 5mm (fondo)',
        '${(results['totalArea5mm'] / 10000).toStringAsFixed(2)} m²',
        '${results['boardCost5mm'].toStringAsFixed(2)}'
      ],
      [
        'Tapa Cantos',
        '${(results['totalEdgeLength'] / 100).toStringAsFixed(2)} m',
        '${results['edgeCost'].toStringAsFixed(2)}'
      ],
      ['Bisagras', '${results['totalHinges']} u.', '${results['hingesCost'].toStringAsFixed(2)}'],
      ['Correderas', '${results['totalSliders']} u.', '${results['slidersCost'].toStringAsFixed(2)}'],
      ['Tornillos', '${results['totalScrews']} u. (aprox)', '${results['screwsCost'].toStringAsFixed(2)}'],
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Costos de Materiales:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          data: data,
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          cellAlignment: pw.Alignment.centerLeft,
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          cellAlignments: {
            2: pw.Alignment.centerRight,
          },
        ),
      ],
    );
  }

  pw.Widget _buildTotals(Map<String, dynamic> results, Config config) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.SizedBox(
        width: 200,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Subtotal Materiales:'),
                pw.Text('${results['materialsCost'].toStringAsFixed(2)}'),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Mano de Obra (${config.laborPercentage}%):'),
                pw.Text('${results['laborCost'].toStringAsFixed(2)}'),
              ],
            ),
            pw.Divider(height: 10),
            pw.DefaultTextStyle(
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 18),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TOTAL:'),
                  pw.Text('${results['totalCost'].toStringAsFixed(2)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildFooter() {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Text('Gracias por su consulta - Presupuesto generado con A&N Muebles App',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
    );
  }
}
