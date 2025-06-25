import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:palette_generator/palette_generator.dart';
import '../dao/cordao.dart';
import '../model/cordetectadamodel.dart';

class TelaDeteccao extends StatefulWidget {
  const TelaDeteccao({Key? key}) : super(key: key);

  @override
  State<TelaDeteccao> createState() => _TelaDeteccaoState();
}

class _TelaDeteccaoState extends State<TelaDeteccao> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  List<Map<String, String>> _coresSignificativas = [];
  bool _processando = false;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _controller = CameraController(camera, ResolutionPreset.medium, enableAudio: false);
    await _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capturarEProcessar() async {
    setState(() { _processando = true; });
    await _initializeControllerFuture;
    final file = await _controller!.takePicture();
    final imageBytes = await File(file.path).readAsBytes();
    final image = img.decodeImage(imageBytes)!;
    final paleta = await PaletteGenerator.fromImageProvider(
      FileImage(File(file.path)),
      size: const Size(200, 200),
      maximumColorCount: 16,
    );
    List<PaletteColor> coresOrdenadas = paleta.paletteColors.toList();
    coresOrdenadas.sort((a, b) {
      double satA = _saturacao(a.color) * a.population;
      double satB = _saturacao(b.color) * b.population;
      return satB.compareTo(satA);
    });
    _coresSignificativas = coresOrdenadas.take(8).map((c) => {
      'nome': _nomeCorProxima(c.color),
      'hex': '#${c.color.value.toRadixString(16).substring(2).toUpperCase()}'
    }).toList();
    final corPrincipal = coresOrdenadas.isNotEmpty ? coresOrdenadas.first.color : Colors.grey;
    final hex = '#${corPrincipal.value.toRadixString(16).substring(2).toUpperCase()}';
    // Salvar foto
    final dir = await getApplicationDocumentsDirectory();
    final caminhoFoto = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    await File(file.path).copy(caminhoFoto);
    // Solicitar nome ao usuário
    String? nomePersonalizado = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempNome = '';
        return AlertDialog(
          title: const Text('Nome para a foto'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Digite um nome (opcional)'),
            onChanged: (value) => tempNome = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(tempNome),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
    // Data/hora atual
    final dataHora = DateTime.now();
    final dataFormatada = '${dataHora.day.toString().padLeft(2, '0')}/${dataHora.month.toString().padLeft(2, '0')}/${dataHora.year} ${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}';
    // Salvar no banco
    final corDetectada = CorDetectadaModel(
      nomeCor: nomePersonalizado ?? '',
      hexCor: hex,
      caminhoFoto: caminhoFoto,
      coresSignificativas: _coresSignificativas,
      dataDetectada: dataFormatada,
    );
    await insertCor(corDetectada);
    setState(() { _processando = false; });
    Navigator.pop(context, true);
  }

  double _saturacao(Color color) {
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;
    final maxVal = [r, g, b].reduce((a, b) => a > b ? a : b);
    final minVal = [r, g, b].reduce((a, b) => a < b ? a : b);
    if (maxVal == minVal) return 0.0;
    final l = (maxVal + minVal) / 2.0;
    final d = maxVal - minVal;
    return l > 0.5 ? d / (2.0 - maxVal - minVal) : d / (maxVal + minVal);
  }

  String _nomeCorProxima(Color cor) {
    final cores = {
      'Vermelho': Color(0xFFFF0000),
      'Verde': Color(0xFF00FF00),
      'Azul': Color(0xFF0000FF),
      'Amarelo': Color(0xFFFFFF00),
      'Ciano': Color(0xFF00FFFF),
      'Magenta': Color(0xFFFF00FF),
      'Preto': Color(0xFF000000),
      'Branco': Color(0xFFFFFFFF),
      'Cinza': Color(0xFF888888),
      'Laranja': Color(0xFFFFA500),
      'Rosa': Color(0xFFFFC0CB),
      'Marrom': Color(0xFF8B4513),
      'Roxo': Color(0xFF800080),
      'Azul Claro': Color(0xFF87CEEB),
      'Verde Claro': Color(0xFF90EE90),
    };
    double distanciaMin = double.infinity;
    String nomeProxima = 'Desconhecida';
    cores.forEach((nome, valor) {
      final d = ((cor.red - valor.red) * (cor.red - valor.red)) +
                ((cor.green - valor.green) * (cor.green - valor.green)) +
                ((cor.blue - valor.blue) * (cor.blue - valor.blue));
      if (d < distanciaMin) {
        distanciaMin = d.toDouble();
        nomeProxima = nome;
      }
    });
    return nomeProxima;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Detectar Cor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(color: Colors.white70));
          }
          return Stack(
            children: [
              CameraPreview(_controller!),
              if (_processando)
                Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator(color: Colors.white70)),
                ),
            ],
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: _processando ? null : _capturarEProcessar,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 8,
          shape: const CircleBorder(),
          child: const Icon(Icons.camera, size: 40),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
} 