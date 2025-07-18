import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TelaSimulacaoDaltonismoFoto extends StatelessWidget {
  final File imagem;

  const TelaSimulacaoDaltonismoFoto({Key? key, required this.imagem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //matrizes de daltonismo 
    return Scaffold(
      appBar: AppBar(title: const Text('Simulação de Daltonismo na Foto')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _blocoImagem('Original', Image.file(imagem)),
          const SizedBox(height: 16),
          _blocoImagem(
            'Protanopia',
            ColorFiltered(
              colorFilter: ColorFilter.matrix(_protanopiaMatrix),
              child: Image.file(imagem),
            ),
          ),
          const SizedBox(height: 16),
          _blocoImagem(
            'Deuteranopia',
            ColorFiltered(
              colorFilter: ColorFilter.matrix(_deuteranopiaMatrix),
              child: Image.file(imagem),
            ),
          ),
          const SizedBox(height: 16),
          _blocoImagem(
            'Tritanopia',
            ColorFiltered(
              colorFilter: ColorFilter.matrix(_tritanopiaMatrix),
              child: Image.file(imagem),
            ),
          ),
        ],
      ),
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
  0.567, 0.433, 0.0,   0, 0,
  0.558, 0.442, 0.0,   0, 0,
  0.0,   0.242, 0.758, 0, 0,
  0,     0,     0,     1, 0,
];

final List<double> _deuteranopiaMatrix = [
  0.625, 0.375, 0.0,   0, 0,
  0.7,   0.3,   0.0,   0, 0,
  0.0,   0.3,   0.7,   0, 0,
  0,     0,     0,     1, 0,
];

final List<double> _tritanopiaMatrix = [
  0.95,  0.05,  0.0,   0, 0,
  0.0,   0.433, 0.567, 0, 0,
  0.0,   0.475, 0.525, 0, 0,
  0,     0,     0,     1, 0,
];
