
// ignore_for_file: non_constant_identifier_names

class Aniversarios {
  String ze_mat;
  String ze_nome;
  String ze_niver;
  int r_e_c_n_o_field;

  Aniversarios({
    required this.ze_mat,
    required this.ze_nome,
    required this.ze_niver,
    required this.r_e_c_n_o_field,
  });

  Aniversarios.empty()
      : ze_mat = '',
        ze_nome = '',
        ze_niver = '',
        r_e_c_n_o_field = 0;

  Aniversarios.fromMap(Map<String, dynamic> map)
      : ze_mat = map['ze_mat'],
        ze_nome = map['ze_nome'],
        ze_niver = map['ze_niver'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'];

  @override
  String toString() {
    return "nome: $ze_nome";
  }

  Map<String, dynamic> toMap() {
    return {
      'ze_mat': ze_mat,
      'ze_nome': ze_nome,
      'ze_niver': ze_niver,
      'r_e_c_n_o_field': r_e_c_n_o_field,
    };
  }
}
