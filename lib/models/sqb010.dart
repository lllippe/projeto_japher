

// ignore_for_file: non_constant_identifier_names

class Sqb010 {
  String qb_depto;
  String qb_descric;
  int r_e_c_n_o_field;

  Sqb010({
    required this.qb_depto,
    required this.qb_descric,
    required this.r_e_c_n_o_field,
  });

  Sqb010.empty()
      : qb_depto = '',
        qb_descric = '',
        r_e_c_n_o_field = 0;

  Sqb010.fromMap(Map<String, dynamic> map)
      : qb_depto = map['qb_depto'],
        qb_descric = map['qb_descric'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'];

  @override
  String toString() {
    return "departamento: $qb_depto \ndescrição: $qb_descric";
  }

  Map<String, dynamic> toMap() {
    return {
      'qb_depto': qb_depto,
      'qb_descric': qb_descric,
      'r_e_c_n_o_field': r_e_c_n_o_field,
    };
  }
}
