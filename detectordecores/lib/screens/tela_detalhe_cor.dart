import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'TelaSimulacaoDaltonismoFoto.dart';

class TelaDetalheCor extends StatefulWidget {
  final Color corPrincipal;
  final String hexCor;
  final String? imagemPath;

  const TelaDetalheCor({
    Key? key,
    required this.corPrincipal,
    required this.hexCor,
    this.imagemPath,
  }) : super(key: key);

  @override
  State<TelaDetalheCor> createState() => _TelaDetalheCorState();
}

class _TelaDetalheCorState extends State<TelaDetalheCor> {

  // Função para calcular saturação de forma consistente com a tela de detecção
  double _saturacao(Color color) {
    final r = color.r / 255.0;
    final g = color.g / 255.0;
    final b = color.b / 255.0;

    final maxVal = [r, g, b].reduce((a, b) => a > b ? a : b);
    final minVal = [r, g, b].reduce((a, b) => a < b ? a : b);

    if (maxVal == minVal) return 0.0;

    final l = (maxVal + minVal) / 2.0;
    final d = maxVal - minVal;
    return l > 0.5 ? d / (2.0 - maxVal - minVal) : d / (maxVal + minVal);
  }

  String get significadoCor {
    return _getSignificadoPorHSL(widget.corPrincipal);
  }

  String _getSignificadoPorHSL(Color cor) {
  final hsl = HSLColor.fromColor(cor);
  final hue = hsl.hue;
  final saturation = _saturacao(cor);
  final lightness = hsl.lightness;

  // Cores muito escuras
  if (lightness < 0.15) {
    if (saturation < 0.05) return 'Poder absoluto, elegância sofisticada, mistério profundo, luto respeitoso.';
    if (saturation < 0.15) return 'Poder discreto, elegância refinada, mistério sutil, sofisticação.';
    if (saturation < 0.35) return 'Poder moderado, elegância equilibrada, mistério envolvente, autoridade.';
    return 'Poder intenso, elegância dramática, mistério envolvente, autoridade.';
  }

  // Cores muito claras
  if (lightness > 0.85) {
    if (saturation < 0.05) return 'Pureza absoluta, paz interior, inocência celestial, simplicidade divina.';
    if (saturation < 0.15) return 'Pureza suave, paz tranquila, inocência delicada, simplicidade elegante.';
    if (saturation < 0.35) return 'Pureza equilibrada, paz serena, inocência radiante, simplicidade refinada.';
    return 'Pureza luminosa, paz serena, inocência radiante, simplicidade refinada.';
  }

  // Matiz por faixa de cor
  if (hue >= 0 && hue < 30) { // VERMELHOS
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Vermelho escuro e pouco saturado: transmite introspecção, elegância reservada e uma paixão contida, quase misteriosa.'
          : 'Vermelho claro e pouco saturado: sugere romantismo delicado, ternura e uma energia emocional suave e acolhedora.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Vermelho moderado: representa energia focada, força interior, coragem e determinação sem excessos.'
          : 'Vermelho vibrante: expressa calor humano, entusiasmo, vitalidade e uma paixão equilibrada e positiva.';
    }
    return lightness < 0.5
        ? 'Vermelho intenso e escuro: simboliza poder, desejo profundo, intensidade emocional e liderança marcante.'
        : 'Vermelho intenso e claro: reflete paixão vibrante, dinamismo, ousadia e uma energia contagiante.';
  } else if (hue >= 30 && hue < 60) { // LARANJA
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Laranja discreto e escuro: inspira criatividade reservada, aconchego sutil e entusiasmo moderado.'
          : 'Laranja claro e suave: transmite alegria tranquila, otimismo leve e motivação gentil.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Laranja moderado: sugere sociabilidade equilibrada, dinamismo positivo e energia acolhedora.'
          : 'Laranja vibrante: expressa vitalidade, entusiasmo, criatividade e otimismo radiante.';
    }
    return lightness < 0.5
        ? 'Laranja intenso e escuro: representa inspiração poderosa, motivação forte e energia transformadora.'
        : 'Laranja intenso e claro: simboliza alegria contagiante, criatividade exuberante e entusiasmo expansivo.';
        
  } else if (hue >= 60 && hue < 90) { // AMARELOS
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Amarelo escuro e suave: evoca otimismo discreto, clareza interior e reflexão positiva.'
          : 'Amarelo claro e suave: transmite leveza mental, alegria delicada e inspiração serena.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Amarelo moderado: sugere criatividade focada, energia equilibrada e pensamento claro.'
          : 'Amarelo vibrante: expressa vitalidade luminosa, entusiasmo moderado e harmonia alegre.';
    }
    return lightness < 0.5
        ? 'Amarelo intenso e escuro: simboliza energia poderosa, alegria marcante e estímulo mental vibrante.'
        : 'Amarelo intenso e claro: reflete brilho radiante, otimismo exuberante e inspiração contagiante.';

  } else if (hue >= 90 && hue < 150) { // VERDE
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Verde escuro e suave: transmite serenidade introspectiva, equilíbrio natural e harmonia reservada.'
          : 'Verde claro e suave: sugere tranquilidade, conexão com a natureza e rejuvenescimento leve.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Verde moderado: representa vitalidade saudável, equilíbrio emocional e frescor moderado.'
          : 'Verde vibrante: expressa harmonia luminosa, energia serena e sensação de crescimento e renovação.';
    }
    return lightness < 0.5
        ? 'Verde intenso e escuro: simboliza força natural, vitalidade profunda e energia revigorante.'
        : 'Verde intenso e claro: reflete frescor exuberante, renovação vibrante e vitalidade contagiante.';

  } else if (hue >= 150 && hue < 210) { // CIANO
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Ciano escuro e suave: evoca calma profunda, introspecção e serenidade sutil.'
          : 'Ciano claro e suave: transmite paz, relaxamento e harmonia mental leve.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Ciano moderado: sugere harmonia equilibrada, concentração serena e frescor mental.'
          : 'Ciano vibrante: expressa vitalidade tranquila, serenidade luminosa e clareza de ideias.';
    }
    return lightness < 0.5
        ? 'Ciano intenso e escuro: simboliza energia relaxante, foco profundo e equilíbrio emocional.'
        : 'Ciano intenso e claro: reflete brilho revigorante, tranquilidade vibrante e frescor contagiante.';
  } else if (hue >= 210 && hue < 270) { // AZUL
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Azul escuro e suave: transmite serenidade profunda, introspecção e reflexão calma.'
          : 'Azul claro e suave: sugere tranquilidade, paz interior e harmonia delicada.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Azul moderado: representa calma equilibrada, foco interno e estabilidade emocional.'
          : 'Azul vibrante: expressa harmonia luminosa, serenidade ativa e inspiração suave.';
    }
    return lightness < 0.5
        ? 'Azul intenso e escuro: simboliza força silenciosa, disciplina e energia concentrada.'
        : 'Azul intenso e claro: reflete clareza radiante, tranquilidade vibrante e inspiração poderosa.';

  } else if (hue >= 270 && hue < 330) { // ROXO
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Roxo escuro e suave: evoca misticismo discreto, introspecção profunda e criatividade reservada.'
          : 'Roxo claro e suave: transmite sonhos suaves, imaginação delicada e inspiração tranquila.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Roxo moderado: sugere criatividade equilibrada, imaginação focada e energia introspectiva.'
          : 'Roxo vibrante: expressa inspiração luminosa, criatividade moderada e harmonia imaginativa.';
    }
    return lightness < 0.5
        ? 'Roxo intenso e escuro: simboliza energia criativa poderosa, expressão vibrante e misticismo marcante.'
        : 'Roxo intenso e claro: reflete criatividade radiante, sonho exuberante e espiritualidade luminosa.';

  } else { // ROSA
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Rosa escuro e suave: transmite doçura introspectiva, delicadeza reservada e ternura contida.'
          : 'Rosa claro e suave: sugere leveza serena, carinho tranquilo e ternura delicada.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Rosa moderado: representa afeto equilibrado, calor emocional e energia suave.'
          : 'Rosa vibrante: expressa ternura equilibrada, harmonia calorosa e afeto luminoso.';
    }
    return lightness < 0.5
        ? 'Rosa intenso e escuro: simboliza paixão afetiva intensa, emoção vibrante e expressão sentimental profunda.'
        : 'Rosa intenso e claro: reflete amor radiante, ternura exuberante e máxima expressão afetiva.';
  }
}


  @override
  Widget build(BuildContext context) {
    // obtem a representação RGB da cor principal para exibição
    final rgb = 'RGB(${widget.corPrincipal.r}, ${widget.corPrincipal.g}, ${widget.corPrincipal.b})';

    // Converte a cor principal para o modelo HSL para facilitar manipulações
    final hsl = HSLColor.fromColor(widget.corPrincipal);

    //cores complementares: são cores opostas no círculo cromático
    //calcula a complementar (180°) e duas variações próximas (150° e 210°)
    final corComplementar = hsl.withHue((hsl.hue + 180) % 360).toColor();
    final corComp1 = hsl.withHue((hsl.hue + 150) % 360).toColor();
    final corComp2 = hsl.withHue((hsl.hue + 210) % 360).toColor();

    //cores análogas são cores vizinhas no círculo cromático
    //deslocamentos de +30°, -30°, +60° e -60° 
    final corAn1 = hsl.withHue((hsl.hue + 30) % 360).toColor();
    final corAn2 = hsl.withHue((hsl.hue - 30 + 360) % 360).toColor();
    final corAn3 = hsl.withHue((hsl.hue + 60) % 360).toColor();
    final corAn4 = hsl.withHue((hsl.hue - 60 + 360) % 360).toColor();

    //tríades são três cores equidistantes no círculo cromático (120° de diferença)
    final corTri1 = hsl.withHue((hsl.hue + 120) % 360).toColor();
    final corTri2 = hsl.withHue((hsl.hue - 120 + 360) % 360).toColor();

    //variações de luminosidade da cor principal
    final tons = List.generate(4, (i) => hsl.withLightness((0.3 + i * 0.15).clamp(0.0, 1.0)).toColor());

    //inclui a cor principal, duas análogas e um tom mais claro da cor principal.
    final paletaSugerida = [
      widget.corPrincipal,
      corAn1, // +30°
      corAn2, // -30°
      hsl.withLightness((hsl.lightness + 0.25).clamp(0.0, 1.0)).toColor(), // tom mais claro
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Cor'),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _blocoCor(context, "Cor Principal", widget.corPrincipal, widget.hexCor),
          const SizedBox(height: 16),
          _exemploContraste(widget.corPrincipal),
          const SizedBox(height: 16),
          SimulacaoDaltonismoBloco(corPrincipal: widget.corPrincipal, imagemPath: widget.imagemPath),
          const SizedBox(height: 16),
          _blocoCores(context, "Tons", tons),
          _blocoCores(context, "Paleta Sugerida", paletaSugerida),
          _blocoCores(context, "Cores Complementares", [corComplementar, corComp1, corComp2]),
          _blocoCores(context, "Cores Análogas", [corAn1, corAn2, corAn3, corAn4]),
          _blocoCores(context, "Tríade ", [corTri1, corTri2])
        ],
      ),
    );
  }

  Widget _blocoCor(BuildContext context, String titulo, Color cor, String hex) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Container(
              height: 80,
              decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 8),
            Text(
              significadoCor,
              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 12, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text('HEX: $hex', style: GoogleFonts.montserrat(color: Colors.white70)),
                IconButton(
                  icon: Icon(Icons.copy, size: 18, color: Colors.white54),
                  tooltip: 'Copiar HEX',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: hex));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('HEX copiado!')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _exemploContraste(Color cor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text('Contraste de Texto', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        const SizedBox(height: 10),
        Container(
          height: 100,
          decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text('Texto Preto', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Texto Branco', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  // Adiciona o parâmetro BuildContext ao _blocoCores
  Widget _blocoCores(BuildContext context, String titulo, List<Color> cores) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(titulo, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.white70),
                  tooltip: 'Exportar XML',
                  onPressed: () async {
                    await _exportarPaletaXml(context, cores);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: cores.map((c) {
                final hex = '#${c.value.toRadixString(16).substring(2).toUpperCase()}';
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(height: 4),
                    Text(hex, style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white70)),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Remove o método _exportarPaleta (JSON)
  Future<void> _exportarPaletaXml(BuildContext context, List<Color> paleta) async {
    // Gera o XML
    final buffer = StringBuffer();
    buffer.writeln('<resources>');
    for (int i = 0; i < paleta.length; i++) {
      final hex = '#${paleta[i].value.toRadixString(16).substring(2).toUpperCase()}';
      buffer.writeln('  <color name="cor${i + 1}">$hex</color>');
    }
    buffer.writeln('</resources>');

    // Salva em arquivo temporário
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/paleta.xml');
    await file.writeAsString(buffer.toString());

    // Compartilha o arquivo
    await Share.shareXFiles([XFile(file.path)], text: 'Paleta exportada em XML!');
  }
}

class SimulacaoDaltonismoBloco extends StatefulWidget {
  final Color corPrincipal;
  final String? imagemPath;
  const SimulacaoDaltonismoBloco({Key? key, required this.corPrincipal, this.imagemPath}) : super(key: key);

  @override
  State<SimulacaoDaltonismoBloco> createState() => _SimulacaoDaltonismoBlocoState();
}

class _SimulacaoDaltonismoBlocoState extends State<SimulacaoDaltonismoBloco> {
  String tipoDaltonismo = 'protanopia';

  static const Map<String, List<List<double>>> matrizes = {
    'protanopia': [
      [0.20, 0.80, 0.00],
      [0.20, 0.80, 0.00],
      [0.00, 0.20, 0.80],
    ],
    'deuteranopia': [
      [0.80, 0.20, 0.00],
      [0.80, 0.20, 0.00],
      [0.00, 0.20, 0.80],
    ],
    'tritanopia': [
      [0.95, 0.05, 0.00],
      [0.00, 0.43, 0.57],
      [0.00, 0.47, 0.53],
    ],
    'achromatopsia': [
      [0.299, 0.587, 0.114],
      [0.299, 0.587, 0.114],
      [0.299, 0.587, 0.114],
    ],
  };

  Color simularDaltonismo(Color original, List<List<double>> matriz) {
    int r = original.red;
    int g = original.green;
    int b = original.blue;
    int r2 = (r * matriz[0][0] + g * matriz[0][1] + b * matriz[0][2]).round().clamp(0, 255);
    int g2 = (r * matriz[1][0] + g * matriz[1][1] + b * matriz[1][2]).round().clamp(0, 255);
    int b2 = (r * matriz[2][0] + g * matriz[2][1] + b * matriz[2][2]).round().clamp(0, 255);
    return Color.fromARGB(original.alpha, r2, g2, b2);
  }

  Color corBotaoSelecionado() {
    final hsl = HSLColor.fromColor(widget.corPrincipal);
    return hsl.withLightness(0.25).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final matriz = matrizes[tipoDaltonismo]!;
    final corSimulada = simularDaltonismo(widget.corPrincipal, matriz);
    final corSelecionado = corBotaoSelecionado();
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Simulação de Daltonismo', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Original', style: TextStyle(color: Colors.white70)),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: widget.corPrincipal,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(tipoDaltonismo[0].toUpperCase() + tipoDaltonismo.substring(1), style: const TextStyle(color: Colors.white70)),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: corSimulada,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Tipo de Daltonismo:', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => tipoDaltonismo = 'protanopia'),
                  child: const Text('Protanopia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tipoDaltonismo == 'protanopia' ? corSelecionado : Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() => tipoDaltonismo = 'deuteranopia'),
                  child: const Text('Deuteranopia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tipoDaltonismo == 'deuteranopia' ? corSelecionado : Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() => tipoDaltonismo = 'tritanopia'),
                  child: const Text('Tritanopia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tipoDaltonismo == 'tritanopia' ? corSelecionado : Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => setState(() => tipoDaltonismo = 'achromatopsia'),
                  child: const Text('Achromatopsia'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tipoDaltonismo == 'achromatopsia' ? corSelecionado : Colors.grey.shade800,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final imagemPath = widget.imagemPath;
                    if (imagemPath != null && imagemPath.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TelaSimulacaoDaltonismoFoto(
                            imagem: File(imagemPath),
                            tipoDaltonismo: tipoDaltonismo,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nenhuma foto disponível para simulação.')),
                      );
                    }
                  },
                  icon: const Icon(Icons.photo),
                  label: const Text('Simular na Foto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
