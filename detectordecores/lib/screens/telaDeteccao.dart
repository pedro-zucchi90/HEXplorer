import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:palette_generator/palette_generator.dart';
import '../dao/cordao.dart';
import '../model/cordetectadamodel.dart';
import 'package:image_picker/image_picker.dart';


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
  String? _erroCamera;

  @override
  void initState() {
    super.initState();
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
        ResolutionPreset.medium,
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
  
  // Calcula a saturação de uma cor (quão "viva" ou intensa ela é).
  // A saturação é usada para priorizar cores mais vivas na imagem, evitando tons acinzentados, muito claros ou muito escuros.
  // Quanto maior a saturação, mais "significativa" a cor tende a ser visualmente.
  double _saturacao(Color color) {
    // Converte os valores RGB de 0 a 255 para entre 0 e 1
    final r = color.red / 255.0;
    final g = color.green / 255.0;
    final b = color.blue / 255.0;

    // Calcula o valor máximo e mínimo entre R, G e B
    final maxVal = [r, g, b].reduce((a, b) => a > b ? a : b);
    final minVal = [r, g, b].reduce((a, b) => a < b ? a : b);

    // Se todos os canais são iguais, a cor é acinzentada (saturação 0)
    if (maxVal == minVal) return 0.0;

    // Calcula a saturação usando a fórmula do modelo HSL
    final l = (maxVal + minVal) / 2.0;
    final d = maxVal - minVal;
    return l > 0.5 ? d / (2.0 - maxVal - minVal) : d / (maxVal + minVal);
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
    await File(origemPath).copy(caminhoFoto);
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
    final dadosImagem = await _processarImagem(file.path);
    _coresSignificativas = List<Map<String, String>>.from(dadosImagem['coresSignificativas']);
    final hex = dadosImagem['hex'];
    final caminhoFoto = await _salvarFoto(file.path);
    final nomePersonalizado = await _solicitarNomeFoto(context);
    final dataFormatada = _dataHoraFormatada();

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

  //--- mesma coisa, mas com imagem da galeria
  Future<void> _selecionarDaGaleria() async {
    setState(() { _processando = true; });
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      setState(() { _processando = false; });
      return;
    }

    final dadosImagem = await _processarImagem(pickedFile.path);
    _coresSignificativas = List<Map<String, String>>.from(dadosImagem['coresSignificativas']);
    final hex = dadosImagem['hex'];
    final caminhoFoto = await _salvarFoto(pickedFile.path);

    final nomePersonalizado = await _solicitarNomeFoto(context);
    if (nomePersonalizado == null) {
      setState(() { _processando = false; });
      return;
    }

    final dataFormatada = _dataHoraFormatada();


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
                      return Center(child: Text('Erro ao carregar câmera: ${snapshot.error}', style: TextStyle(color: Colors.red)));
                    }
                    if (_controller == null || !_controller!.value.isInitialized) {
                      return const Center(child: Text('Câmera não inicializada', style: TextStyle(color: Colors.white)));
                    }
                    return Stack(
                      children: [
                        CameraPreview(_controller!),
                      ],
                    );
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
}
