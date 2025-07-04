# Detector de Cores via Câmera

Aplicativo Flutter para identificar, nomear e catalogar cores predominantes em fotos capturadas pela câmera do dispositivo. Ideal para designers, desenvolvedores, artistas ou qualquer pessoa que deseja criar paletas de cores do mundo real.

---

## Funcionalidades

- **Captura de Fotos:** Tire fotos diretamente pelo app usando a câmera do dispositivo.
- **Detecção Automática de Cores:** O app identifica automaticamente as cores predominantes na imagem capturada.
- **Armazenamento Local:** As fotos e informações das cores são salvas localmente no dispositivo, garantindo acesso offline.
- **Histórico de Detecções:** Visualize um histórico completo das fotos e cores já detectadas.
- **Exclusão de Registros:** Remova fotos e detecções do histórico quando desejar.
- **Interface Moderna e Responsiva:** Layout escuro, intuitivo e adaptado para diferentes tamanhos de tela.

---

## Estrutura dos Dados

Cada cor detectada é armazenada com as seguintes informações:

- **nomeCor:** Nome personalizado ou sugerido para a cor principal.
- **hexCor:** Código hexadecimal da cor principal.
- **caminhoFoto:** Caminho local da foto capturada.
- **coresSignificativas:** Lista das principais cores detectadas (nome e hex).
- **dataDetectada:** Data e hora em que a cor foi detectada.

---

## Tecnologias Utilizadas

- **Flutter** e **Dart** para desenvolvimento multiplataforma.
- **camera:** Captura de imagens pela câmera do dispositivo.
- **sqflite:** Armazenamento local em banco de dados SQLite.
- **image:** Manipulação e análise de imagens.
- **palette_generator:** Extração das cores predominantes da imagem.
- **google_fonts:** Fontes personalizadas.
- **path_provider:** Gerenciamento de caminhos e arquivos locais.

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



