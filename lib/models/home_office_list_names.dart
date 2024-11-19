
// ignore_for_file: non_constant_identifier_names

class HomeOfficeListNames {
  String ze_nome;

  HomeOfficeListNames({
    required this.ze_nome,
  });

  HomeOfficeListNames.empty()
      : ze_nome = '';

  HomeOfficeListNames.fromMap(Map<String, dynamic> map)
      : ze_nome = map['ze_nome'];

  @override
  String toString() {
    return "nome: $ze_nome";
  }

  Map<String, dynamic> toMap() {
    return {
      'ze_nome': ze_nome,
    };
  }
}
