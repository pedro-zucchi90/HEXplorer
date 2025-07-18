# HEXplorer - Detector de Cores via Câmera

<div align="center">
  <!-- Badges minimalistas -->
  <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white" alt="Flutter"></a>
  <a href="https://dart.dev/"><img src="https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white" alt="Dart"></a>
  <a href="https://pub.dev/packages/camera"><img src="https://img.shields.io/badge/Camera-FF9800?style=flat-square&logo=photo&logoColor=white" alt="Camera"></a>
  <a href="https://pub.dev/packages/sqflite"><img src="https://img.shields.io/badge/SQFLite-4DB33D?style=flat-square&logo=sqlite&logoColor=white" alt="SQFLite"></a>
  <a href="https://pub.dev/packages/image"><img src="https://img.shields.io/badge/Image-607D8B?style=flat-square&logo=image&logoColor=white" alt="Image"></a>
  <a href="https://pub.dev/packages/palette_generator"><img src="https://img.shields.io/badge/Palette_Generator-9C27B0?style=flat-square&logo=palette&logoColor=white" alt="Palette Generator"></a>
  <a href="https://pub.dev/packages/google_fonts"><img src="https://img.shields.io/badge/Google_Fonts-4285F4?style=flat-square&logo=google&logoColor=white" alt="Google Fonts"></a>
</div>

---

Aplicativo Flutter para identificar, nomear, simular daltonismo e catalogar cores predominantes em fotos capturadas pela câmera do dispositivo. Ideal para designers, desenvolvedores, artistas ou qualquer pessoa que deseja criar paletas de cores do mundo real.

---

## Funcionalidades

- **Captura de Fotos:** Tire fotos diretamente pelo app usando a câmera do dispositivo.
- **Detecção Automática de Cores:** O app identifica automaticamente as cores predominantes na imagem capturada.
- **Simulação de Daltonismo:** Visualize como as cores aparecem para diferentes tipos de daltonismo (protanopia, deuteranopia, tritanopia), tanto em tempo real quanto em fotos salvas.
- **Armazenamento Local:** As fotos e informações das cores são salvas localmente no dispositivo, garantindo acesso offline.
- **Histórico de Detecções:** Visualize um histórico completo das fotos e cores já detectadas.
- **Exclusão de Registros:** Remova fotos e detecções do histórico quando desejar.
- **Interface Moderna e Responsiva:** Layout escuro, intuitivo e adaptado para diferentes tamanhos de tela.
- **Cópia rápida do código HEX:** Toque em uma cor para copiar seu código hexadecimal.
- **Exportação de paleta:** Exporte paletas de cores em XML para uso em outros projetos.

---

## Estrutura dos Dados

Cada cor detectada é armazenada com as seguintes informações:

- **nomeCor:** Nome personalizado ou sugerido para a cor principal.
- **hexCor:** Código hexadecimal da cor principal.
- **imagemPath:** Caminho local da foto capturada.
- **coresSignificativas:** Lista das principais cores detectadas (hex).
- **dataDetectada:** Data e hora em que a cor foi detectada.

---

## Tecnologias & Dependências

- **Flutter** e **Dart** para desenvolvimento multiplataforma.
- **camera:** Captura de imagens pela câmera do dispositivo.
- **sqflite:** Armazenamento local em banco de dados SQLite.
- **image:** Manipulação e análise de imagens.
- **palette_generator:** Extração das cores predominantes da imagem.
- **google_fonts:** Fontes personalizadas.
- **path_provider:** Gerenciamento de caminhos e arquivos locais.
- **image_picker:** Seleção de imagens da galeria.
- **color_blindness:** Simulação de daltonismo.
- **share_plus:** Compartilhamento de arquivos e paletas.

---

## Como Executar o Projeto

1. **Clone o repositório:**
   ```sh
   git clone https://github.com/seu-usuario/seu-repo.git
   cd ContaGotasCamera/detectordecores
   ```

2. **Instale as dependências:**
   ```sh
   flutter pub get
   ```

3. **Execute o app:**
   ```sh
   flutter run
   ```

---

## Badges de Frontend e Recursos (para referência)

<div align="left">
  <a href="https://developer.mozilla.org/pt-BR/docs/Web/HTML"><img src="https://img.shields.io/badge/HTML5-%23E34F26?style=for-the-badge&logo=html5&logoColor=white" alt="HTML5"></a>
  <a href="https://developer.mozilla.org/pt-BR/docs/Web/CSS"><img src="https://img.shields.io/badge/CSS3-%231572B6?style=for-the-badge&logo=css3&logoColor=white" alt="CSS3"></a>
  <a href="https://developer.mozilla.org/pt-BR/docs/Web/JavaScript"><img src="https://img.shields.io/badge/JavaScript-%23F7DF1E?style=for-the-badge&logo=javascript&logoColor=black" alt="JavaScript"></a>
  <a href="https://fontawesome.com/"><img src="https://img.shields.io/badge/Font_Awesome-%23339AF0?style=for-the-badge&logo=fontawesome&logoColor=white" alt="Font Awesome"></a>
  <a href="https://fonts.google.com/"><img src="https://img.shields.io/badge/Google_Fonts-%234285F4?style=for-the-badge&logo=google&logoColor=white" alt="Google Fonts"></a>
  <a href="https://getbootstrap.com/"><img src="https://img.shields.io/badge/Bootstrap-%237952B3?style=for-the-badge&logo=bootstrap&logoColor=white" alt="Bootstrap"></a>
  <a href="https://www.chartjs.org/"><img src="https://img.shields.io/badge/Chart.js-%23FF6384?style=for-the-badge&logo=chartdotjs&logoColor=white" alt="Chart.js"></a>
  <img src="https://img.shields.io/badge/ES6+-%23F7DF1E?style=for-the-badge&logo=javascript&logoColor=black" alt="ES6+">
  <img src="https://img.shields.io/badge/DOM_Manipulation-%23F7DF1E?style=for-the-badge&logo=javascript&logoColor=black" alt="DOM Manipulation">
  <img src="https://img.shields.io/badge/Event_Listeners-%23F7DF1E?style=for-the-badge&logo=javascript&logoColor=black" alt="Event Listeners">
  <img src="https://img.shields.io/badge/Intersection_Observer-%23F7DF1E?style=for-the-badge&logo=javascript&logoColor=black" alt="Intersection Observer">
</div>



