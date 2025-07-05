import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testesqlite/dao/cordao.dart';
import 'package:testesqlite/model/cordetectadamodel.dart';
import 'screens/teladeteccao.dart';
import 'dart:io';
import 'screens/tela_detalhe_cor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HexplorerApp());
}

class HexplorerApp extends StatelessWidget {
  const HexplorerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const TelaPrincipal(),
    );
  }

  //configuração do tema
  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.white,
        onPrimary: Colors.black,
        secondary: Colors.grey.shade800,
        onSecondary: Colors.white,
        error: Colors.red.shade400,
        onError: Colors.white,
        background: Colors.black,
        onBackground: Colors.white,
        surface: Colors.grey.shade900,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8,
        shape: StadiumBorder(),
      ),
      cardTheme: CardThemeData(
        color: Colors.grey.shade900,
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: Colors.white.withOpacity(0.05),
      ),
      textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme).copyWith(
        titleLarge: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        bodyLarge: GoogleFonts.montserrat(fontSize: 16, color: Colors.white70),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade800,
        labelStyle: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        selectedColor: Colors.white24,
        secondaryLabelStyle: GoogleFonts.montserrat(color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        hintStyle: GoogleFonts.montserrat(color: Colors.white38),
      ),
      iconTheme: const IconThemeData(color: Colors.white70, size: 24),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.white70),
    );
  }
}

//tela principal do app
class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({Key? key}) : super(key: key);

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HEXplorer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  //---- corpo da tela principal (cards)
  Widget _buildBody() {
    return FutureBuilder<List<CorDetectadaModel>>(
      future: findAllCores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma foto armazenada', style: TextStyle(fontSize: 18, color: Colors.grey)));
        }
        final cores = snapshot.data!;
        return ListView.builder(
          itemCount: cores.length,
          itemBuilder: (context, index) {
            final cor = cores[index];
            return _buildCorCard(cor);
          },
        );
      },
    );
  }

  //----- exibir cada cor detectada
  Widget _buildCorCard(CorDetectadaModel cor) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFoto(cor.caminhoFoto),
            const SizedBox(height: 14),
            _buildInfoCor(cor),
            const SizedBox(height: 10),
            _buildCoresSignificativas(cor.coresSignificativas),
          ],
        ),
      ),
    );
  }

  //----- exibir a foto
  Widget _buildFoto(String caminhoFoto) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: caminhoFoto.isNotEmpty
          ? Image.file(
              File(caminhoFoto),
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
            )
          : Container(width: double.infinity, height: 180, color: Colors.grey[300]),
    );
  }

  //----- exibe informações (nome hex e data)
  Widget _buildInfoCor(CorDetectadaModel cor) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cor.nomeCor.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.label, size: 18, color: Colors.indigo),
                    const SizedBox(width: 6),
                    Text(
                      cor.nomeCor,
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              Row(
                children: [
                  const Icon(Icons.color_lens, size: 18, color: Colors.indigo),
                  const SizedBox(width: 6),
                  Text(
                    cor.hexCor,
                    style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              if (cor.dataDetectada != null && cor.dataDetectada!.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      cor.dataDetectada!,
                      style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.white70),
          onPressed: () {
            final corPrincipal = Color(int.parse('FF${cor.hexCor.substring(1)}', radix: 16));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TelaDetalheCor(
                  corPrincipal: corPrincipal,
                  hexCor: cor.hexCor,
                ),
              ),
            );
          },
        ),
        _buildDeleteButton(cor),
      ],
    );
  }

  //----- botão para deletar um card e tudo relacionado
  Widget _buildDeleteButton(CorDetectadaModel cor) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja realmente excluir esta cor?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Excluir', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        if (confirm == true) {
          await removeCor(cor.id!);
          setState(() {});
        }
      },
    );
  }

  //----- botão para redirecionar
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TelaDeteccao()),
        );
        if (result == true) {
          setState(() {});
        }
      },
      child: const Icon(Icons.camera_alt, size: 32),
    );
  }

  //----- exibe as cores significativas em quadrados coloridos
  Widget _buildCoresSignificativas(List<Map<String, String>> cores) {
    return Wrap(
      spacing: 6,
      children: cores.map((c) => Chip(
        label: Text(c['hex'] ?? ''),
        backgroundColor: Color(int.parse('FF${c['hex']!.substring(1)}', radix: 16)),
        labelStyle: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
        elevation: 2,
      )).toList(),
    );
  }
}

