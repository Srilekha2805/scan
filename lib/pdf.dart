import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Pdf extends StatefulWidget {
  @override
  _PdfState createState() => _PdfState();
}

class _PdfState extends State<Pdf> {
  final pdf = pw.Document();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

    );
  }
}
