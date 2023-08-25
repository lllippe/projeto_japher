
// ignore_for_file: non_constant_identifier_names

class Sx5010 {
  String x5_descri;
  int r_e_c_n_o_field;

  Sx5010({
    required this.x5_descri,
    required this.r_e_c_n_o_field,
  });

  Sx5010.empty()
      : x5_descri = '',
        r_e_c_n_o_field = 0;

  Sx5010.fromMap(Map<String, dynamic> map)
      : x5_descri = map['x5_descri'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'];

  @override
  String toString() {
    return "feriado: $x5_descri";
  }

  Map<String, dynamic> toMap() {
    return {
      'x5_descri': x5_descri,
      'r_e_c_n_o_field': r_e_c_n_o_field,
    };
  }
}
