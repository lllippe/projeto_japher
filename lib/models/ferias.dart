
// ignore_for_file: non_constant_identifier_names

class FeriasSze {
  String rh_mat;
  String rh_databas;
  double rh_dferias;
  String rh_dataini;
  String rh_datafim;
  int r_e_c_n_o_field;

  FeriasSze({
    required this.rh_mat,
    required this.rh_databas,
    required this.rh_dataini,
    required this.rh_datafim,
    required this.rh_dferias,
    required this.r_e_c_n_o_field,
  });

  FeriasSze.empty()
      : rh_mat = '',
        rh_databas = '',
        rh_dataini = '',
        rh_datafim = '',
        rh_dferias = 0,
        r_e_c_n_o_field = 0;

  FeriasSze.fromMap(Map<String, dynamic> map)
      : rh_mat = map['rh_mat'],
        rh_databas = map['rh_databas'],
        rh_dataini = map['rh_dataini'],
        rh_datafim = map['rh_datafim'],
        rh_dferias = map['rh_dferias'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'];

  @override
  String toString() {
    return "nome: $rh_mat";
  }

  Map<String, dynamic> toMap() {
    return {
      'rh_mat': rh_mat,
      'rh_databas': rh_databas,
      'rh_dataini': rh_dataini,
      'rh_datafim': rh_datafim,
      'rh_dferias': rh_dferias,
      'r_e_c_n_o_field': r_e_c_n_o_field,
    };
  }
}
