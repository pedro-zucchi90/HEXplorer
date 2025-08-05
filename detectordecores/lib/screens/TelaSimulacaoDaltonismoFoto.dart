import 'dart:io';
import 'package:flutter/material.dart';

class TelaSimulacaoDaltonismoFoto extends StatefulWidget {
  final File imagem;
  final String tipoDaltonismo;

  const TelaSimulacaoDaltonismoFoto({Key? key, required this.imagem, required this.tipoDaltonismo}) : super(key: key);

  @override
  State<TelaSimulacaoDaltonismoFoto> createState() => _TelaSimulacaoDaltonismoFotoState();
}

class _TelaSimulacaoDaltonismoFotoState extends State<TelaSimulacaoDaltonismoFoto> {
  late String tipoDaltonismoAtual;

  @override
  void initState() {
    super.initState();
    tipoDaltonismoAtual = widget.tipoDaltonismo;
  }

  List<double> _getMatrix(String tipo) {
    switch (tipo) {
      case 'protanopia':
        return _protanopiaMatrix;
      case 'deuteranopia':
        return _deuteranopiaMatrix;
      case 'tritanopia':
        return _tritanopiaMatrix;
      case 'achromatopsia':
        return _achromatopsiaMatrix;
      default:
        return _protanopiaMatrix;
    }
  }

  String _getLabel(String tipo) {
    switch (tipo) {
      case 'protanopia':
        return 'Protanopia';
      case 'deuteranopia':
        return 'Deuteranopia';
      case 'tritanopia':
        return 'Tritanopia';
      case 'achromatopsia':
        return 'Achromatopsia';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulação de Daltonismo na Foto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _blocoImagem('Original', Image.file(widget.imagem)),
          const SizedBox(height: 16),
          _blocoImagem(
            _getLabel(tipoDaltonismoAtual),
            ColorFiltered(
              colorFilter: ColorFilter.matrix(_getMatrix(tipoDaltonismoAtual)),
              child: Image.file(widget.imagem),
            ),
          ),
          const SizedBox(height: 24),
          Text('Tipo de Daltonismo:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _botaoTipo('protanopia'),
              _botaoTipo('deuteranopia'),
              _botaoTipo('tritanopia'),
              _botaoTipo('achromatopsia'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _botaoTipo(String tipo) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          tipoDaltonismoAtual = tipo;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: tipoDaltonismoAtual == tipo ? Colors.blueGrey : Colors.grey.shade800,
        foregroundColor: Colors.white,
      ),
      child: Text(_getLabel(tipo)),
    );
  }

  Widget _blocoImagem(String titulo, Widget imagem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imagem,
        ),
      ],
    );
  }
}

//matrizes de simulação de daltonismo (fonte: color_blindness e ChatGPT XD)
final List<double> _protanopiaMatrix = [
  0.20, 0.80, 0.00, 0, 0,
  0.20, 0.80, 0.00, 0, 0,
  0.00, 0.20, 0.80, 0, 0,
  0,    0,    0,    1, 0,
];

final List<double> _deuteranopiaMatrix = [
  0.80, 0.20, 0.00, 0, 0,
  0.80, 0.20, 0.00, 0, 0,
  0.00, 0.20, 0.80, 0, 0,
  0,    0,    0,    1, 0,
];

final List<double> _tritanopiaMatrix = [
  0.95, 0.05, 0.00, 0, 0,
  0.00, 0.43, 0.57, 0, 0,
  0.00, 0.47, 0.53, 0, 0,
  0,    0,    0,    1, 0,
];

final List<double> _achromatopsiaMatrix = [
  0.299, 0.587, 0.114, 0, 0,
  0.299, 0.587, 0.114, 0, 0,
  0.299, 0.587, 0.114, 0, 0,
  0,     0,     0,     1, 0,
];
