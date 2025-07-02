import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaDetalheCor extends StatelessWidget {
  final Color corPrincipal;
  final String hexCor;

  const TelaDetalheCor({
    Key? key,
    required this.corPrincipal,
    required this.hexCor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // obtem a representação RGB da cor principal para exibição
    final rgb = 'RGB(${corPrincipal.red}, ${corPrincipal.green}, ${corPrincipal.blue})';

    // Converte a cor principal para o modelo HSL para facilitar manipulações
    final hsl = HSLColor.fromColor(corPrincipal);

    // cores complementares: são cores opostas no círculo cromático
    // calcula a complementar (180°) e duas variações próximas (150° e 210°)
    final corComplementar = hsl.withHue((hsl.hue + 180) % 360).toColor();
    final corComp1 = hsl.withHue((hsl.hue + 150) % 360).toColor();
    final corComp2 = hsl.withHue((hsl.hue + 210) % 360).toColor();

    // cores análogas são cores vizinhas no círculo cromático
    // aqui, usamos deslocamentos de +30°, -30°, +60° e -60° para obter quatro análogas
    final corAn1 = hsl.withHue((hsl.hue + 30) % 360).toColor();
    final corAn2 = hsl.withHue((hsl.hue - 30 + 360) % 360).toColor();
    final corAn3 = hsl.withHue((hsl.hue + 60) % 360).toColor();
    final corAn4 = hsl.withHue((hsl.hue - 60 + 360) % 360).toColor();

    // tríades são três cores equidistantes no círculo cromático (120° de diferença)
    final corTri1 = hsl.withHue((hsl.hue + 120) % 360).toColor();
    final corTri2 = hsl.withHue((hsl.hue - 120 + 360) % 360).toColor();

    // tons são variações de luminosidade da cor principal, criando do mais escuro ao mais claro.
    final tons = List.generate(4, (i) => hsl.withLightness((0.3 + i * 0.15).clamp(0.0, 1.0)).toColor());

    // paleta harmônica sugerida inclui a cor principal, duas análogas e um tom mais claro da cor principal.
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
          _blocoCor(context, "Cor Principal", corPrincipal, hexCor, rgb),
          const SizedBox(height: 16),
          _exemploContraste(corPrincipal),
          const SizedBox(height: 16),
          _blocoCores("Cores Complementares", [corComplementar, corComp1, corComp2]),
          _blocoCores("Cores Análogas", [corAn1, corAn2, corAn3, corAn4]),
          _blocoCores("Tons", tons),
          _blocoCores("Paleta Sugerida", paletaSugerida),
          _blocoCores("Tríade ", [corTri1, corTri2])
        ],
      ),
    );
  }

  Widget _blocoCor(BuildContext context, String titulo, Color cor, String hex, String rgb) {
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
                IconButton(
                  icon: Icon(Icons.info_outline, color: Colors.white70),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TelaDetalheCor(
                          corPrincipal: cor,
                          hexCor: hex,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 80,
              decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 10),
            Text('HEX: $hex', style: GoogleFonts.montserrat(color: Colors.white70)),
            Text(rgb, style: GoogleFonts.montserrat(color: Colors.white70)),
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

  Widget _blocoCores(String titulo, List<Color> cores) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
}
