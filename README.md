# Detector de Cores via Câmera

Aplicativo Flutter para detectar cores predominantes em fotos capturadas pela câmera do dispositivo, armazenando as imagens e informações das cores localmente. Ideal para designers, desenvolvedores, artistas ou qualquer pessoa que precise identificar e catalogar paletas de cores do mundo real.

## Funcionalidades

- Captura de fotos usando a câmera do dispositivo.
- Detecção automática das cores predominantes na imagem.
- Sugestão de nomes para as cores detectadas.
- Armazenamento local das fotos e informações das cores.
- Visualização de histórico de fotos e cores detectadas.
- Exclusão de registros.
- Interface moderna, escura e responsiva.
- Suporte multiplataforma: Android, iOS, Web, Windows, Linux e macOS.

---

## Tecnologias Utilizadas

### Framework

<a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-%2302569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"></a>
<a href="https://dart.dev/"><img src="https://img.shields.io/badge/Dart-%230175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"></a>

### Bibliotecas e Recursos

<a href="https://pub.dev/packages/camera"><img src="https://img.shields.io/badge/Camera-%2302569B?style=for-the-badge&logo=googlecamera&logoColor=white" alt="Camera"></a>
<a href="https://pub.dev/packages/sqflite"><img src="https://img.shields.io/badge/SQFLite-%2300C853?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQFLite"></a>
<a href="https://pub.dev/packages/image"><img src="https://img.shields.io/badge/Image-%23F7DF1E?style=for-the-badge&logo=image&logoColor=black" alt="Image"></a>
<a href="https://pub.dev/packages/palette_generator"><img src="https://img.shields.io/badge/Palette_Generator-%234285F4?style=for-the-badge&logo=google&logoColor=white" alt="Palette Generator"></a>
<a href="https://pub.dev/packages/google_fonts"><img src="https://img.shields.io/badge/Google_Fonts-%234285F4?style=for-the-badge&logo=google&logoColor=white" alt="Google Fonts"></a>
<a href="https://pub.dev/packages/path_provider"><img src="https://img.shields.io/badge/Path_Provider-%2300BFAE?style=for-the-badge&logo=folder&logoColor=white" alt="Path Provider"></a>

### Recursos Flutter Utilizados

<img src="https://img.shields.io/badge/Material_Design-%230081CB?style=for-the-badge&logo=materialdesign&logoColor=white" alt="Material Design">
<img src="https://img.shields.io/badge/Stateful_Widgets-%2302569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Stateful Widgets">
<img src="https://img.shields.io/badge/FutureBuilder-%2302569B?style=for-the-badge&logo=flutter&logoColor=white" alt="FutureBuilder">
<img src="https://img.shields.io/badge/Navigation-%2302569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Navigation">

---

## Estrutura de Dados

O app utiliza um modelo para armazenar cada cor detectada:

- **nomeCor**: Nome personalizado ou sugerido para a cor principal.
- **hexCor**: Código hexadecimal da cor principal.
- **caminhoFoto**: Caminho local da foto capturada.
- **coresSignificativas**: Lista das principais cores detectadas (nome e hex).
- **dataDetectada**: Data e hora da detecção.

---

## Como Executar

1. **Clone o repositório:**
   ```
   git clone https://github.com/seu-usuario/seu-repo.git
   cd ContaGotasCamera/detectordecores
   ```

2. **Instale as dependências:**
   ```
   flutter pub get
   ```

3. **Execute o app:**
   ```
   flutter run
   ```

> Para rodar no navegador, use `flutter run -d chrome`.

---

## Suporte Multiplataforma

- Android
- iOS
- Web (PWA)
- Windows
- Linux
- macOS

---

## PWA

O projeto já inclui `manifest.json` e ícones para instalação como aplicativo web progressivo (PWA).

---

## Licença

Este projeto está sob a licença MIT.
