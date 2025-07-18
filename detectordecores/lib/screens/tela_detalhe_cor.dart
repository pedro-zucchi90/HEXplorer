import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:color_blindness/color_blindness.dart';
import 'telaSimulacaoDaltonismoFoto.dart';

class TelaDetalheCor extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // obtem a representação RGB da cor principal para exibição
    final rgb = 'RGB(${corPrincipal.r}, ${corPrincipal.g}, ${corPrincipal.b})';

    // Converte a cor principal para o modelo HSL para facilitar manipulações
    final hsl = HSLColor.fromColor(corPrincipal);

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
      corPrincipal,
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
          _blocoCor(context, "Cor Principal", corPrincipal, hexCor),
          const SizedBox(height: 16),
          _exemploContraste(corPrincipal),
          const SizedBox(height: 16),
          SimulacaoDaltonismoBloco(corPrincipal: corPrincipal, imagemPath: imagemPath),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 80,
              decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(10)),
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
            // Removido o Text(rgb, ...)
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
      [0.567, 0.433, 0.000],
      [0.558, 0.442, 0.000],
      [0.000, 0.242, 0.758],
    ],
    'deuteranopia': [
      [0.625, 0.375, 0.000],
      [0.700, 0.300, 0.000],
      [0.000, 0.300, 0.700],
    ],
    'tritanopia': [
      [0.950, 0.050, 0.000],
      [0.000, 0.433, 0.567],
      [0.000, 0.475, 0.525],
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
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Aqui você pode obter o caminho da imagem associada à cor, se existir
                    // Exemplo: supondo que você tenha o caminho salvo em widget.imagemPath
                    // Substitua pelo caminho correto se necessário
                    final imagemPath = widget.imagemPath;
                    if (imagemPath != null && imagemPath.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TelaSimulacaoDaltonismoFoto(imagem: File(imagemPath)),
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
