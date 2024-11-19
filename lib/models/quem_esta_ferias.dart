
// ignore_for_file: non_constant_identifier_names

class QuemEstaFerias {
  String ze_nome;
  String rh_databas;
  double rh_dferias;
  String rh_dataini;
  String rh_datafim;
  int r_e_c_n_o_field;

  QuemEstaFerias({
    required this.ze_nome,
    required this.rh_databas,
    required this.rh_dataini,
    required this.rh_datafim,
    required this.rh_dferias,
    required this.r_e_c_n_o_field,
  });

  QuemEstaFerias.empty()
      : ze_nome = '',
        rh_databas = '',
        rh_dataini = '',
        rh_datafim = '',
        rh_dferias = 0,
        r_e_c_n_o_field = 0;

  QuemEstaFerias.fromMap(Map<String, dynamic> map)
      : ze_nome = map['ze_nome'],
        rh_databas = map['rh_databas'],
        rh_dataini = map['rh_dataini'],
        rh_datafim = map['rh_datafim'],
        rh_dferias = map['rh_dferias'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'];

  @override
  String toString() {
    return "nome: $ze_nome";
  }

  Map<String, dynamic> toMap() {
    return {
      'ze_nome': ze_nome,
      'rh_databas': rh_databas,
      'rh_dataini': rh_dataini,
      'rh_datafim': rh_datafim,
      'rh_dferias': rh_dferias,
      'r_e_c_n_o_field': r_e_c_n_o_field,
    };
  }
}
