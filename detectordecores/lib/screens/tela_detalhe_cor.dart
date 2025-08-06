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
    final saturation = _saturacao(cor); // Usa a função personalizada
    final lightness = hsl.lightness;
    
    // Cores muito escuras (pretos e cinzas escuros)
    if (lightness < 0.15) {
      if (saturation < 0.1) return 'Poder absoluto, elegância sofisticada, mistério profundo, luto respeitoso.';
      if (saturation < 0.3) return 'Poder discreto, elegância refinada, mistério sutil, sofisticação.';
      return 'Poder intenso, elegância dramática, mistério envolvente, autoridade.';
    }
    
    // Cores muito claras (brancos e tons pastéis muito claros)
    if (lightness > 0.85) {
      if (saturation < 0.1) return 'Pureza absoluta, paz interior, inocência celestial, simplicidade divina.';
      if (saturation < 0.3) return 'Pureza suave, paz tranquila, inocência delicada, simplicidade elegante.';
      return 'Pureza luminosa, paz serena, inocência radiante, simplicidade refinada.';
    }
    
    // Cores com saturação muito baixa (tons neutros)
    if (saturation < 0.15) {
      if (lightness < 0.4) return 'Neutralidade profunda, equilíbrio interior, indecisão contemplativa, formalidade elegante.';
      if (lightness < 0.7) return 'Neutralidade equilibrada, equilíbrio harmonioso, indecisão ponderada, formalidade discreta.';
      return 'Neutralidade suave, equilíbrio delicado, indecisão serena, formalidade refinada.';
    }
    
    // VERMELHOS (0-30°)
    if (hue >= 0 && hue < 30) {
      if (saturation < 0.4) {
        if (lightness < 0.5) return 'Paixão suave e introspectiva, ternura profunda, carinho maternal, amor discreto.';
        return 'Paixão delicada e romântica, ternura gentil, carinho infantil, amor puro.';
      } else if (saturation < 0.7) {
        if (lightness < 0.5) return 'Energia moderada e focada, paixão determinada, coragem interior, amor sincero.';
        return 'Energia equilibrada e calorosa, paixão romântica, entusiasmo contido, amor verdadeiro.';
      } else {
        if (lightness < 0.5) return 'Energia intensa e poderosa, paixão ardente e irresistível, ação decisiva, amor profundo e apaixonado.';
        return 'Energia vibrante e exuberante, paixão ardente e contagiante, ação dinâmica, amor intenso e romântico.';
      }
    }
    
    // LARANJAS (30-60°)
    if (hue >= 30 && hue < 60) {
      if (saturation < 0.4) {
        if (lightness < 0.5) return 'Alegria suave e acolhedora, criatividade introspectiva, otimismo discreto, calor humano.';
        return 'Alegria delicada e radiante, criatividade gentil, otimismo puro, calor maternal.';
      } else if (saturation < 0.7) {
        if (lightness < 0.5) return 'Alegria equilibrada e confiante, criatividade focada, otimismo realista, entusiasmo moderado.';
        return 'Alegria harmoniosa e contagiante, criatividade inspiradora, otimismo genuíno, entusiasmo sincero.';
      } else {
        if (lightness < 0.5) return 'Alegria exuberante e energética, criatividade vibrante e inovadora, otimismo contagiante, entusiasmo irresistível.';
        return 'Alegria radiante e luminosa, criatividade vibrante e expressiva, otimismo exuberante, entusiasmo contagiante.';
      }
    }
    
    // AMARELOS (60-90°)
    if (hue >= 60 && hue < 90) {
      if (saturation < 0.4) {
        if (lightness < 0.5) return 'Alegria suave e intelectual, criatividade contemplativa, atenção sutil, energia mental.';
        return 'Alegria delicada e luminosa, criatividade gentil, atenção pura, energia espiritual.';
      } else if (saturation < 0.7) {
        if (lightness < 0.5) return 'Alegria equilibrada e focada, criatividade produtiva, atenção concentrada, energia vital.';
        return 'Alegria harmoniosa e inspiradora, criatividade expressiva, atenção genuína, energia positiva.';
      } else {
        if (lightness < 0.5) return 'Alegria vibrante e energética, criatividade inovadora e dinâmica, atenção irresistível, energia contagiante.';
        return 'Alegria radiante e luminosa, criatividade vibrante e expressiva, atenção magnética, energia exuberante.';
      }
    }
    
    // VERDES (90-150°)
    if (hue >= 90 && hue < 150) {
      if (saturation < 0.4) {
        if (lightness < 0.5) return 'Natureza suave e contemplativa, tranquilidade profunda, paz interior, crescimento sutil.';
        return 'Natureza delicada e serena, tranquilidade celestial, paz pura, crescimento gentil.';
      } else if (saturation < 0.7) {
        if (lightness < 0.5) return 'Natureza equilibrada e estável, tranquilidade confiante, paz harmoniosa, crescimento constante.';
        return 'Natureza harmoniosa e vital, tranquilidade serena, paz genuína, crescimento saudável.';
      } else {
        if (lightness < 0.5) return 'Natureza vibrante e vigorosa, saúde robusta, crescimento vigoroso e dinâmico, esperança inabalável.';
        return 'Natureza radiante e exuberante, saúde vibrante, crescimento vigoroso e contagiante, esperança luminosa.';
      }
    }
    
    // AZUIS (150-210°)
    if (hue >= 150 && hue < 210) {
      if (saturation < 0.4) {
        if (lightness < 0.5) return 'Calma profunda e contemplativa, serenidade interior, conforto espiritual, estabilidade emocional.';
        return 'Calma delicada e celestial, serenidade pura, conforto maternal, estabilidade gentil.';
      } else if (saturation < 0.7) {
        if (lightness < 0.5) return 'Calma confiante e estável, serenidade equilibrada, conforto seguro, estabilidade sólida.';
        return 'Calma harmoniosa e serena, serenidade genuína, conforto acolhedor, estabilidade tranquila.';
      } else {
        if (lightness < 0.5) return 'Calma profunda e absoluta, confiança inabalável, estabilidade inquebrantável, serenidade suprema.';
        return 'Calma radiante e luminosa, confiança absoluta, estabilidade perfeita, serenidade celestial.';
      }
    }
    
    // ROXOS/VIOLETAS (210-270°)
    if (hue >= 210 && hue < 270) {
      if (saturation < 0.4) {
        if (lightness < 0.5) return 'Espiritualidade suave e introspectiva, intuição sutil, mistério discreto, criatividade contemplativa.';
        return 'Espiritualidade delicada e celestial, intuição pura, mistério gentil, criatividade espiritual.';
      } else if (saturation < 0.7) {
        if (lightness < 0.5) return 'Espiritualidade equilibrada e focada, mistério harmonioso, criatividade produtiva, nobreza discreta.';
        return 'Espiritualidade harmoniosa e inspiradora, mistério sereno, criatividade expressiva, nobreza genuína.';
      } else {
        if (lightness < 0.5) return 'Espiritualidade intensa e profunda, mistério envolvente e hipnótico, criatividade inovadora, nobreza majestosa.';
        return 'Espiritualidade radiante e luminosa, mistério fascinante, criatividade vibrante, nobreza celestial.';
      }
    }
    
    // MAGENTAS/ROSAS (270-330°)
    if (hue >= 270 && hue < 330) {
      if (saturation < 0.4) {
        if (lightness < 0.5) return 'Romance suave e introspectivo, ternura profunda, carinho maternal, feminilidade discreta.';
        return 'Romance delicado e celestial, ternura pura, carinho infantil, feminilidade gentil.';
      } else if (saturation < 0.7) {
        if (lightness < 0.5) return 'Romance equilibrado e sincero, ternura harmoniosa, carinho genuíno, feminilidade elegante.';
        return 'Romance harmonioso e inspirador, ternura serena, carinho acolhedor, feminilidade refinada.';
      } else {
        if (lightness < 0.5) return 'Romance intenso e apaixonado, ternura profunda e envolvente, carinho maternal, feminilidade majestosa.';
        return 'Romance radiante e luminoso, ternura vibrante, carinho contagiante, feminilidade celestial.';
      }
    }
    
    // VERMELHOS-MAGENTA (330-360°)
    if (hue >= 330 && hue < 360) {
      if (saturation < 0.4) {
        if (lightness < 0.5) return 'Paixão suave e romântica, amor discreto, carinho maternal, energia sutil.';
        return 'Paixão delicada e pura, amor celestial, carinho infantil, energia gentil.';
      } else if (saturation < 0.7) {
        if (lightness < 0.5) return 'Paixão equilibrada e sincera, amor verdadeiro, carinho genuíno, energia harmoniosa.';
        return 'Paixão harmoniosa e inspiradora, amor sereno, carinho acolhedor, energia positiva.';
      } else {
        if (lightness < 0.5) return 'Paixão ardente e irresistível, energia intensa e dinâmica, ação decisiva, amor profundo e apaixonado.';
        return 'Paixão radiante e luminosa, energia vibrante e contagiante, ação dinâmica, amor intenso e romântico.';
      }
    }
    
    return 'Cor única com características especiais e distintivas.';
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
