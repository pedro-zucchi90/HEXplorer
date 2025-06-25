class CorDetectadaModel {
  int? id;
  String nomeCor;
  String hexCor;
  String caminhoFoto;
  List<Map<String, String>> coresSignificativas;
  String? dataDetectada;

  CorDetectadaModel({
    this.id,
    required this.nomeCor,
    required this.hexCor,
    required this.caminhoFoto,
    required this.coresSignificativas,
    this.dataDetectada,
  });

  factory CorDetectadaModel.fromMap(Map map) {
    return CorDetectadaModel(
      id: map['id'],
      nomeCor: map['nome_cor'],
      hexCor: map['hex_cor'],
      caminhoFoto: map['caminho_foto'],
      coresSignificativas: List<Map<String, String>>.from(
        (map['cores_significativas'] != null && map['cores_significativas'] is String)
          ? (map['cores_significativas'] as String).isNotEmpty
            ? List<Map<String, String>>.from(
                (map['cores_significativas'] as String).split(';').map((e) {
                  var parts = e.split(',');
                  return {'nome': parts[0], 'hex': parts[1]};
                })
              )
            : []
          : [],
      ),
      dataDetectada: map['data_detectada'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome_cor': nomeCor,
      'hex_cor': hexCor,
      'caminho_foto': caminhoFoto,
      'cores_significativas': coresSignificativas.map((e) => "${e['nome']},${e['hex']}").join(';'),
      'data_detectada': dataDetectada,
    };
  }
} 