

// ignore_for_file: non_constant_identifier_names

class Sp8010 {
  String p8_mat;
  String p8_data;
  double p8_hora;
  String p8_depto;
  double p8_seqjrn;
  String p8_motivrg;
  String p8_usuario;
  String d_e_l_e_t_field;
  int r_e_c_n_o_field;
  int r_e_c_d_e_l_field;

  Sp8010({
    required this.p8_mat,
    required this.p8_data,
    required this.p8_hora,
    required this.p8_depto,
    required this.p8_seqjrn,
    required this.p8_motivrg,
    required this.p8_usuario,
    required this.d_e_l_e_t_field,
    required this.r_e_c_n_o_field,
    required this.r_e_c_d_e_l_field,
  });

  Sp8010.empty()
      : p8_mat = '',
        p8_data = '',
        p8_hora = 0.0,
        p8_depto = '',
        p8_seqjrn = 0.0,
        p8_motivrg = '',
        p8_usuario = '',
        d_e_l_e_t_field = '',
        r_e_c_n_o_field = 0,
        r_e_c_d_e_l_field = 0;

  Sp8010.fromMap(Map<String, dynamic> map)
      : p8_mat = map['p8_mat'],
        p8_data = map['p8_data'],
        p8_hora = map['p8_hora'],
        p8_depto = map['p8_depto'],
        p8_seqjrn = map['p8_seqjrn'],
        p8_motivrg = map['p8_motivrg'],
        p8_usuario = map['p8_usuario'],
        d_e_l_e_t_field = map['d_e_l_e_t_field'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'],
        r_e_c_d_e_l_field = map['r_e_c_d_e_l_field'];

  @override
  String toString() {
    return "departamento: $p8_depto \nmatricula: $p8_mat";
  }

  Map<String, dynamic> toMap() {
    return {
      'p8_mat' : p8_mat,
      'p8_data' : p8_data,
      'p8_hora' : p8_hora,
      'p8_depto' : p8_depto,
      'p8_seqjrn' : p8_seqjrn,
      'p8_motivrg' : p8_motivrg,
      'p8_usuario' : p8_usuario,
      'd_e_l_e_t_field' : d_e_l_e_t_field,
      'r_e_c_n_o_field' : r_e_c_n_o_field,
      'r_e_c_d_e_l_field' : r_e_c_d_e_l_field,
    };
  }
}
