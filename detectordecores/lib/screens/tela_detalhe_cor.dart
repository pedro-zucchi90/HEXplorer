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

  // Matiz por 12 faixas de cor (cada uma com 30 graus)
  if (hue >= 0 && hue < 30) { // VERMELHO
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Vermelho escuro e pouco saturado: introspecção, elegância reservada e paixão contida.'
          : 'Vermelho claro e pouco saturado: romantismo delicado, ternura e energia emocional suave.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Vermelho moderado: energia focada, força interior e coragem.'
          : 'Vermelho vibrante: calor humano, entusiasmo e vitalidade.';
    }
    return lightness < 0.5
        ? 'Vermelho intenso e escuro: poder, desejo profundo e liderança.'
        : 'Vermelho intenso e claro: paixão vibrante, dinamismo e ousadia.';
  } else if (hue >= 30 && hue < 60) { // LARANJA
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Laranja escuro e discreto: criatividade reservada e aconchego sutil.'
          : 'Laranja claro e suave: alegria tranquila e otimismo leve.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Laranja moderado: sociabilidade equilibrada e dinamismo positivo.'
          : 'Laranja vibrante: vitalidade, entusiasmo e criatividade.';
    }
    return lightness < 0.5
        ? 'Laranja intenso e escuro: inspiração poderosa e energia transformadora.'
        : 'Laranja intenso e claro: alegria contagiante e criatividade exuberante.';
  } else if (hue >= 60 && hue < 90) { // AMARELO-OURO
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Amarelo-ouro escuro e suave: otimismo discreto e reflexão positiva.'
          : 'Amarelo-ouro claro e suave: leveza mental e alegria delicada.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Amarelo-ouro moderado: criatividade focada e energia equilibrada.'
          : 'Amarelo-ouro vibrante: vitalidade luminosa e harmonia alegre.';
    }
    return lightness < 0.5
        ? 'Amarelo-ouro intenso e escuro: energia poderosa e estímulo mental.'
        : 'Amarelo-ouro intenso e claro: brilho radiante e otimismo exuberante.';
  } else if (hue >= 90 && hue < 120) { // AMARELO-LIMÃO
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Amarelo-limão escuro e suave: clareza interior e serenidade discreta.'
          : 'Amarelo-limão claro e suave: inspiração serena e leveza.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Amarelo-limão moderado: energia equilibrada e pensamento claro.'
          : 'Amarelo-limão vibrante: alegria radiante e criatividade leve.';
    }
    return lightness < 0.5
        ? 'Amarelo-limão intenso e escuro: estímulo mental e energia marcante.'
        : 'Amarelo-limão intenso e claro: otimismo contagiante e inspiração vibrante.';
  } else if (hue >= 120 && hue < 150) { // VERDE-LIMÃO
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Verde-limão escuro e suave: equilíbrio natural e serenidade introspectiva.'
          : 'Verde-limão claro e suave: rejuvenescimento leve e tranquilidade.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Verde-limão moderado: vitalidade saudável e frescor moderado.'
          : 'Verde-limão vibrante: energia serena e sensação de renovação.';
    }
    return lightness < 0.5
        ? 'Verde-limão intenso e escuro: força natural e energia revigorante.'
        : 'Verde-limão intenso e claro: frescor exuberante e vitalidade contagiante.';
  } else if (hue >= 150 && hue < 180) { // VERDE
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Verde escuro e suave: harmonia reservada e introspecção.'
          : 'Verde claro e suave: conexão com a natureza e serenidade.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Verde moderado: equilíbrio emocional e vitalidade.'
          : 'Verde vibrante: harmonia luminosa e sensação de crescimento.';
    }
    return lightness < 0.5
        ? 'Verde intenso e escuro: vitalidade profunda e energia revigorante.'
        : 'Verde intenso e claro: renovação vibrante e vitalidade contagiante.';
  } else if (hue >= 180 && hue < 210) { // VERDE-ÁGUA / CIANO
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Verde-água escuro e suave: calma profunda e serenidade sutil.'
          : 'Verde-água claro e suave: paz e relaxamento.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Verde-água moderado: harmonia equilibrada e frescor mental.'
          : 'Verde-água vibrante: vitalidade tranquila e clareza de ideias.';
    }
    return lightness < 0.5
        ? 'Verde-água intenso e escuro: energia relaxante e equilíbrio emocional.'
        : 'Verde-água intenso e claro: brilho revigorante e frescor contagiante.';
  } else if (hue >= 210 && hue < 240) { // AZUL-CIANO
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Azul-ciano escuro e suave: introspecção e serenidade profunda.'
          : 'Azul-ciano claro e suave: paz interior e harmonia delicada.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Azul-ciano moderado: calma equilibrada e estabilidade emocional.'
          : 'Azul-ciano vibrante: serenidade ativa e inspiração suave.';
    }
    return lightness < 0.5
        ? 'Azul-ciano intenso e escuro: força silenciosa e disciplina.'
        : 'Azul-ciano intenso e claro: clareza radiante e inspiração poderosa.';
  } else if (hue >= 240 && hue < 270) { // AZUL
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Azul escuro e suave: reflexão calma e introspecção.'
          : 'Azul claro e suave: tranquilidade e paz interior.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Azul moderado: foco interno e estabilidade.'
          : 'Azul vibrante: harmonia luminosa e serenidade ativa.';
    }
    return lightness < 0.5
        ? 'Azul intenso e escuro: energia concentrada e disciplina.'
        : 'Azul intenso e claro: tranquilidade vibrante e inspiração.';
  } else if (hue >= 270 && hue < 300) { // AZUL-ROXO
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Azul-roxo escuro e suave: misticismo discreto e criatividade reservada.'
          : 'Azul-roxo claro e suave: sonhos suaves e imaginação delicada.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Azul-roxo moderado: imaginação focada e energia introspectiva.'
          : 'Azul-roxo vibrante: criatividade moderada e harmonia imaginativa.';
    }
    return lightness < 0.5
        ? 'Azul-roxo intenso e escuro: expressão vibrante e misticismo marcante.'
        : 'Azul-roxo intenso e claro: criatividade radiante e espiritualidade luminosa.';
  } else if (hue >= 300 && hue < 330) { // ROXO
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Roxo escuro e suave: introspecção profunda e criatividade reservada.'
          : 'Roxo claro e suave: imaginação delicada e inspiração tranquila.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Roxo moderado: criatividade equilibrada e energia introspectiva.'
          : 'Roxo vibrante: inspiração luminosa e criatividade moderada.';
    }
    return lightness < 0.5
        ? 'Roxo intenso e escuro: energia criativa poderosa e misticismo marcante.'
        : 'Roxo intenso e claro: sonho exuberante e espiritualidade luminosa.';
  } else { // 330 a 360 - ROSA
    if (saturation < 0.4) {
      return lightness < 0.5
          ? 'Rosa escuro e suave: doçura introspectiva e delicadeza reservada.'
          : 'Rosa claro e suave: leveza serena e ternura delicada.';
    }
    if (saturation < 0.7) {
      return lightness < 0.5
          ? 'Rosa moderado: afeto equilibrado e energia suave.'
          : 'Rosa vibrante: ternura equilibrada e afeto luminoso.';
    }
    return lightness < 0.5
        ? 'Rosa intenso e escuro: paixão afetiva intensa e emoção vibrante.'
        : 'Rosa intenso e claro: amor radiante e máxima expressão afetiva.';
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
