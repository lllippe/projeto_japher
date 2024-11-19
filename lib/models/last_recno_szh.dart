
// ignore_for_file: non_constant_identifier_names

class LastRecnoSzh {
  int r_e_c_n_o_field;

  LastRecnoSzh({
    required this.r_e_c_n_o_field,
  });

  LastRecnoSzh.empty()
      : r_e_c_n_o_field = 0;

  LastRecnoSzh.fromMap(Map<String, dynamic> map)
      : r_e_c_n_o_field = map['r_e_c_n_o_field'];

  @override
  String toString() {
    return "recno: $r_e_c_n_o_field";
  }

  Map<String, dynamic> toMap() {
    return {
      'r_e_c_n_o_field' : r_e_c_n_o_field,
    };
  }
}
