// Modelo que representa uma cor detectada
class CorDetectadaModel {
  int? id;
  String nomeCor;
  String hexCor;
  String? imagemPath; // novo campo para o path da imagem
  List<Map<String, String>> coresSignificativas; //lista de cores relacionadas (nome e hex)
  String? dataDetectada;

  CorDetectadaModel({
    this.id,
    required this.nomeCor,
    required this.hexCor,
    this.imagemPath,
    required this.coresSignificativas,
    this.dataDetectada,
  });

  //cria uma instância a partir de um map do bd
  factory CorDetectadaModel.fromMap(Map map) {
    //função para converter a string de cores significativas em lista
    List<Map<String, String>> converterCoresSignificativas(dynamic valor) {
      if (valor is String && valor.isNotEmpty) {
        return valor.split(';').map<Map<String, String>>((item) {
          var partes = item.split(',');
          return {
            'hex': partes.length > 1 ? partes[1] : '',
          };
        }).toList();
      }
      return [];
    }

    //verifica se o map contém a chave 'cores_significativas' e converte 
    return CorDetectadaModel(
      id: map['id'],
      nomeCor: map['nome_cor'],
      hexCor: map['hex_cor'],
      imagemPath: map['imagem_path'],
      coresSignificativas: converterCoresSignificativas(map['cores_significativas']),
      dataDetectada: map['data_detectada'],
    );
  }

  //converte a instância para um map
  Map<String, dynamic> toMap() {
    return {
      'nome_cor': nomeCor,
      'hex_cor': hexCor,
      'imagem_path': imagemPath,
      'cores_significativas': coresSignificativas.map((cor) => "${cor['nome']},${cor['hex']}").join(';'),
      'data_detectada': dataDetectada,
    };
  }
} 