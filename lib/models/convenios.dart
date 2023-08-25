
// ignore_for_file: non_constant_identifier_names

class Convenios {
  String ze_mat;
  String ze_nome;
  String ze_conveni;
  int r_e_c_n_o_field;

  Convenios({
    required this.ze_mat,
    required this.ze_nome,
    required this.ze_conveni,
    required this.r_e_c_n_o_field,
  });

  Convenios.empty()
      : ze_mat = '',
        ze_nome = '',
        ze_conveni = '',
        r_e_c_n_o_field = 0;

  Convenios.fromMap(Map<String, dynamic> map)
      : ze_mat = map['ze_mat'],
        ze_nome = map['ze_nome'],
        ze_conveni = map['ze_conveni'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'];

  @override
  String toString() {
    return "nome: $ze_nome";
  }

  Map<String, dynamic> toMap() {
    return {
      'ze_mat': ze_mat,
      'ze_nome': ze_nome,
      'ze_conveni': ze_conveni,
      'r_e_c_n_o_field': r_e_c_n_o_field,
    };
  }
}
