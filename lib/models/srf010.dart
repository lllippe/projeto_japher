
// ignore_for_file: non_constant_identifier_names

class Srf010 {
  String rf_mat;
  String rf_databas;
  String rf_dataini;
  String rf_datafim;
  int r_e_c_n_o_field;

  Srf010({
    required this.rf_mat,
    required this.rf_databas,
    required this.rf_dataini,
    required this.rf_datafim,
    required this.r_e_c_n_o_field,
  });

  Srf010.empty()
      : rf_mat = '',
        rf_databas = '',
        rf_dataini = '',
        rf_datafim = '',
        r_e_c_n_o_field = 0;

  Srf010.fromMap(Map<String, dynamic> map)
      : rf_mat = map['rf_mat'],
        rf_databas = map['rf_databas'],
        rf_dataini = map['rf_dataini'],
        rf_datafim = map['rf_datafim'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'];

  @override
  String toString() {
    return "matricula: $rf_mat";
  }

  Map<String, dynamic> toMap() {
    return {
      'rf_mat': rf_mat,
      'rf_databas': rf_databas,
      'rf_dataini': rf_dataini,
      'rf_datafim': rf_datafim,
      'r_e_c_n_o_field': r_e_c_n_o_field,
    };
  }
}
