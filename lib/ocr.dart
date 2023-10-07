import 'package:flutter/material.dart';

class ocr extends StatefulWidget {
  const ocr({super.key});

  @override
  State<ocr> createState() => _ocrState();
}

class _ocrState extends State<ocr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "ocr",
          style: TextStyle(
              fontSize: 20
          ),
        ),
      ),
    );
  }
}