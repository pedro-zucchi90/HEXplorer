import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:palette_generator/palette_generator.dart';
import '../dao/cordao.dart';
import '../model/cordetectadamodel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';


class TelaDeteccao extends StatefulWidget {
  final String? modoDaltonismo;
  const TelaDeteccao({Key? key, this.modoDaltonismo}) : super(key: key);

  @override
  State<TelaDeteccao> createState() => _TelaDeteccaoState();
}

class _TelaDeteccaoState extends State<TelaDeteccao> {
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  List<Map<String, String>> _coresSignificativas = [];
  bool _processando = false;
  String? _erroCamera;



  // Matrizes de simulação de daltonismo (ajustadas conforme espectro da imagem)
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

  // NOVO: tipo de daltonismo selecionado em tempo real
  late String _tipoDaltonismoAtual;

  @override
  void initState() {
    super.initState();
    _tipoDaltonismoAtual = widget.modoDaltonismo ?? '';
    _initializeControllerFuture = _initCamera();
  }

  //inicializa a câmera
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _erroCamera = 'Nenhuma câmera disponível.';
        });
        return;
      }

      final camera = cameras.first;
      _controller = CameraController(
        camera,
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await _controller!.initialize();

      setState(() {
        _erroCamera = null;
      });
    } 
    catch (e) 
    {
      setState(() {
        _erroCamera = 'Erro ao inicializar a câmera: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }



  // ------ funções utilitárias e helpers (utilitários = Algo mais geral/genérico; Helpers = Algo mais específico)
  
  //calcula a saturação de uma cor
  double _saturacao(Color color) {
    // Converte os valores RGB de 0 a 255 para entre 0 e 1
    final r = color.r / 255.0;
    final g = color.g / 255.0;
    final b = color.b / 255.0;

    //calcula o valor máximo e mínimo entre R, G e B
    final maxVal = [r, g, b].reduce((a, b) => a > b ? a : b);
    final minVal = [r, g, b].reduce((a, b) => a < b ? a : b);

    //se todos os canais são iguais, a cor é acinzentada (saturação 0)
    if (maxVal == minVal) return 0.0;

    //calcula a saturação usando a fórmula do modelo HSL
    final l = (maxVal + minVal) / 2.0;
    final d = maxVal - minVal;
    return l > 0.5 ? d / (2.0 - maxVal - minVal) : d / (maxVal + minVal);
  }

  // Função para aplicar filtro de daltonismo na imagem
  img.Image aplicarFiltroDaltonismo(img.Image src, List<double> matrix) {
    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        var pixel = src.getPixel(x, y);
        int r = pixel.r.toInt();
        int g = pixel.g.toInt();
        int b = pixel.b.toInt();
        int a = pixel.a.toInt();

        // Matriz 4x5
        double nr = (matrix[0] * r) + (matrix[1] * g) + (matrix[2] * b) + (matrix[3] * a) + matrix[4];
        double ng = (matrix[5] * r) + (matrix[6] * g) + (matrix[7] * b) + (matrix[8] * a) + matrix[9];
        double nb = (matrix[10] * r) + (matrix[11] * g) + (matrix[12] * b) + (matrix[13] * a) + matrix[14];
        double na = (matrix[15] * r) + (matrix[16] * g) + (matrix[17] * b) + (matrix[18] * a) + matrix[19];

        src.setPixelRgba(
          x, y,
          nr.clamp(0, 255).toInt(),
          ng.clamp(0, 255).toInt(),
          nb.clamp(0, 255).toInt(),
          na.clamp(0, 255).toInt(),
        );
      }
    }
    return src;
  }


  //--- mostra diálogo para solicitar nome da foto
  Future<String?> _solicitarNomeFoto(BuildContext context) async {
    String tempNome = '';
    return showDialog<String>(
      context: context,
      builder: (context) {
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
  }


  //--- processa imagem e retorna dados relevantes (cores mais significativas, cor principal...)
  Future<Map<String, dynamic>> _processarImagem(String path) async {
    final imageBytes = await File(path).readAsBytes(); // lê os bytes da imagem do caminho fornecido
    final image = img.decodeImage(imageBytes)!; // decodifica a imagem usando a biblioteca image (para o código conseguir "ver" a imagem)

    final paleta = await PaletteGenerator.fromImageProvider(
      FileImage(File(path)), // usa FileImage para carregar a imagem do caminho
      size: const Size(200, 200), //redimensiona a imagem para 200x200 pixels
      maximumColorCount: 16, //limita o número de cores processadas para 16
    );

    //ordena as cores pela saturação
    List<PaletteColor> coresOrdenadas = paleta.paletteColors.toList();
    coresOrdenadas.sort((a, b) {
      double satA = _saturacao(a.color) * a.population; // calcula a saturação da cor A e multiplica pela quantidade de pixels daquela cor
      double satB = _saturacao(b.color) * b.population; // mesmo que A, mas para a cor B
      return satB.compareTo(satA); // ordena as cores pela saturação (mais saturada primeiro)
    });

    //seleciona as 8 cores mais significativas
    final coresSignificativas = coresOrdenadas.take(8).map((c) => {
      'hex': '#${c.color.value.toRadixString(16).substring(2).toUpperCase()}' 
    }).toList(); //converte as cores significativas para o formato hexadecimal (toRadixString(16)) e formata para ficar em maiúsculas (.toUpperCase()). 
    //substring(2) remove o prefixo 'ff' do valor ARGB

    final corPrincipal = coresOrdenadas.isNotEmpty ? coresOrdenadas.first.color : Colors.grey;

    final hex = '#${corPrincipal.value.toRadixString(16).substring(2).toUpperCase()}';
    return {
      'coresSignificativas': coresSignificativas,
      'corPrincipal': corPrincipal,
      'hex': hex,
    };
  }

  //--- salva foto em diretório da aplicação
  Future<String> _salvarFoto(String origemPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final caminhoFoto = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Carrega a imagem
    final imageBytes = await File(origemPath).readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);

    // Aplica o filtro se necessário
    if (_tipoDaltonismoAtual == 'protanopia') {
      image = aplicarFiltroDaltonismo(image!, _protanopiaMatrix);
    } else if (_tipoDaltonismoAtual == 'deuteranopia') {
      image = aplicarFiltroDaltonismo(image!, _deuteranopiaMatrix);
    } else if (_tipoDaltonismoAtual == 'tritanopia') {
      image = aplicarFiltroDaltonismo(image!, _tritanopiaMatrix);
    } else if (_tipoDaltonismoAtual == 'achromatopsia') {
      image = aplicarFiltroDaltonismo(image!, _achromatopsiaMatrix);
    }

    // Salva a imagem (com ou sem filtro)
    await File(caminhoFoto).writeAsBytes(img.encodeJpg(image!));
    return caminhoFoto;
  }

  //--- retorna data e hora formatada
  String _dataHoraFormatada() {
    final dataHora = DateTime.now();
    return '${dataHora.day.toString().padLeft(2, '0')}/${dataHora.month.toString().padLeft(2, '0')}/${dataHora.year} ${dataHora.hour.toString().padLeft(2, '0')}:${dataHora.minute.toString().padLeft(2, '0')}';
  }


  //--------------- fluxo principal

  //---captura foto, processa e salva no banco de dados
  Future<void> _capturarEProcessar() async {
    setState(() { _processando = true; });
    await _initializeControllerFuture;

    final file = await _controller!.takePicture();
    final caminhoFoto = await _salvarFoto(file.path);
    final dadosImagem = await _processarImagem(file.path);
    _coresSignificativas = List<Map<String, String>>.from(dadosImagem['coresSignificativas']);
    final hex = dadosImagem['hex'];
    final nomePersonalizado = await _solicitarNomeFoto(context);
    final dataFormatada = _dataHoraFormatada();

    final corDetectada = CorDetectadaModel(
      nomeCor: nomePersonalizado ?? '',
      hexCor: hex,
      imagemPath: caminhoFoto, // use o path salvo
      coresSignificativas: _coresSignificativas,
      dataDetectada: dataFormatada,
    );

    await insertCor(corDetectada);
    setState(() { _processando = false; });
    Navigator.pop(context, true);
  }

  //--- mesma coisa, mas com imagem da galeria
  Future<void> _selecionarDaGaleria() async {
    setState(() { _processando = true; });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      setState(() { _processando = false; });
      return;
    }

    final caminhoFoto = await _salvarFoto(pickedFile.path);
    final dadosImagem = await _processarImagem(pickedFile.path);
    _coresSignificativas = List<Map<String, String>>.from(dadosImagem['coresSignificativas']);
    final hex = dadosImagem['hex'];
    final nomePersonalizado = await _solicitarNomeFoto(context);
    if (nomePersonalizado == null) {
      setState(() { _processando = false; });
      return;
    }
    final dataFormatada = _dataHoraFormatada();

    final corDetectada = CorDetectadaModel(
      nomeCor: nomePersonalizado ?? '',
      hexCor: hex,
      imagemPath: caminhoFoto, // use o path salvo
      coresSignificativas: _coresSignificativas,
      dataDetectada: dataFormatada,
    );

    await insertCor(corDetectada);
    setState(() { _processando = false; });
    Navigator.pop(context, true);
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

      body: _processando
          ? const Center(child: CircularProgressIndicator(color: Colors.white70))
          : _erroCamera != null
              ? Center(child: Text(_erroCamera!, style: const TextStyle(color: Colors.red, fontSize: 18)))
              : FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white70));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Erro ao carregar câmera:  ${snapshot.error}', style: TextStyle(color: Colors.red)));
                    }
                    if (_controller == null || !_controller!.value.isInitialized) {
                      return const Center(child: Text('Câmera não inicializada', style: TextStyle(color: Colors.white)));
                    }
                    return _buildCameraPreviewComFiltro();
                  },
                ),

      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            //botão tirar foto
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
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
            ),

            // Botão de galeria
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 32.0, bottom: 8.0),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: FloatingActionButton(
                    onPressed: _processando ? null : _selecionarDaGaleria,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.photo_library, size: 32),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCameraPreviewComFiltro() {
    if (_tipoDaltonismoAtual == 'protanopia') {
      return ColorFiltered(
        colorFilter: ColorFilter.matrix(_protanopiaMatrix),
        child: CameraPreview(_controller!),
      );
    } else if (_tipoDaltonismoAtual == 'deuteranopia') {
      return ColorFiltered(
        colorFilter: ColorFilter.matrix(_deuteranopiaMatrix),
        child: CameraPreview(_controller!),
      );
    } else if (_tipoDaltonismoAtual == 'tritanopia') {
      return ColorFiltered(
        colorFilter: ColorFilter.matrix(_tritanopiaMatrix),
        child: CameraPreview(_controller!),
      );
    } else if (_tipoDaltonismoAtual == 'achromatopsia') {
      return ColorFiltered(
        colorFilter: ColorFilter.matrix(_achromatopsiaMatrix),
        child: CameraPreview(_controller!),
      );
    } else {
      return CameraPreview(_controller!);
    }
  }
}
