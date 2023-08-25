
// ignore_for_file: non_constant_identifier_names

class Szh010 {
  String zh_mat;
  String zh_inipaq;
  String zh_fimpaq;
  double zh_saldfer;
  double zh_diasfer;
  String zh_dataini;
  String zh_datafim;
  String zh_aprvges;
  String zh_aprvdir;
  String zh_recibvi;
  String zh_dtrecvi;
  String zh_recibap;
  String zh_dtrecap;
  String zh_integra;
  String zh_depto;
  int r_e_c_n_o_field;
  int r_e_c_d_e_l_field;
  String d_e_l_e_t_field;

  Szh010({
    required this.zh_mat,
    required this.zh_inipaq,
    required this.zh_fimpaq,
    required this.zh_saldfer,
    required this.zh_diasfer,
    required this.zh_dataini,
    required this.zh_datafim,
    required this.zh_aprvges,
    required this.zh_aprvdir,
    required this.zh_recibvi,
    required this.zh_dtrecvi,
    required this.zh_recibap,
    required this.zh_dtrecap,
    required this.zh_integra,
    required this.zh_depto,
    required this.r_e_c_n_o_field,
    required this.d_e_l_e_t_field,
    required this.r_e_c_d_e_l_field
  });

  Szh010.empty()
      :   zh_mat = '',
          zh_inipaq = '',
          zh_fimpaq = '',
          zh_saldfer = 0.0,
          zh_diasfer = 0.0,
          zh_dataini = '',
          zh_datafim = '',
          zh_aprvges = '',
          zh_aprvdir = '',
          zh_recibvi = '',
          zh_dtrecvi = '',
          zh_recibap = '',
          zh_dtrecap = '',
          zh_integra = '',
          zh_depto = '',
          r_e_c_n_o_field = 0,
          r_e_c_d_e_l_field = 0,
          d_e_l_e_t_field = '';

  Szh010.fromMap(Map<String, dynamic> map)
      : zh_mat = map['zh_mat'],
        zh_inipaq = map['zh_inipaq'],
        zh_fimpaq = map['zh_fimpaq'],
        zh_saldfer = map['zh_saldfer'],
        zh_diasfer = map['zh_diasfer'],
        zh_dataini = map['zh_dataini'],
        zh_datafim = map['zh_datafim'],
        zh_aprvges = map['zh_aprvges'],
        zh_aprvdir = map['zh_aprvdir'],
        zh_recibvi = map['zh_recibvi'],
        zh_dtrecvi = map['zh_dtrecvi'],
        zh_recibap = map['zh_recibap'],
        zh_dtrecap = map['zh_dtrecap'],
        zh_integra = map['zh_integra'],
        zh_depto = map['zh_depto'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'],
        r_e_c_d_e_l_field = map['r_e_c_d_e_l_field'],
        d_e_l_e_t_field = map['d_e_l_e_t_field'];

  @override
  String toString() {
    return "matricula: $zh_mat \nnome: $zh_depto";
  }

  Map<String, dynamic> toMap() {
    return {
      'zh_mat' : zh_mat,
      'zh_inipaq' : zh_inipaq,
      'zh_fimpaq' : zh_fimpaq,
      'zh_saldfer' : zh_saldfer,
      'zh_diasfer' : zh_diasfer,
      'zh_dataini' : zh_dataini,
      'zh_datafim' : zh_datafim,
      'zh_aprvges' : zh_aprvges,
      'zh_aprvdir' : zh_aprvdir,
      'zh_recibvi' : zh_recibvi,
      'zh_dtrecvi' : zh_dtrecvi,
      'zh_recibap' : zh_recibap,
      'zh_dtrecap' : zh_dtrecap,
      'zh_integra' : zh_integra,
      'zh_depto' : zh_depto,
      'r_e_c_n_o_field' : r_e_c_n_o_field,
      'r_e_c_d_e_l_field' : r_e_c_d_e_l_field,
      'd_e_l_e_t_field' : d_e_l_e_t_field,
    };
  }
}
