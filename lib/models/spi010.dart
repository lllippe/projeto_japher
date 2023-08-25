

// ignore_for_file: non_constant_identifier_names

class Spi010 {
  String pi_mat;
  String pi_data;
  String pi_pd;
  double pi_quant;
  double pi_quantv;
  String pi_status;
  String pi_depto;
  String pi_justifi;
  String d_e_l_e_t_field;
  int r_e_c_n_o_field;
  int r_e_c_d_e_l_field;

  Spi010({
    required this.pi_mat,
    required this.pi_data,
    required this.pi_pd,
    required this.pi_quant,
    required this.pi_quantv,
    required this.pi_status,
    required this.pi_depto,
    required this.pi_justifi,
    required this.d_e_l_e_t_field,
    required this.r_e_c_n_o_field,
    required this.r_e_c_d_e_l_field,
  });

  Spi010.empty()
      : pi_mat = '',
        pi_data = '',
        pi_pd = '',
        pi_quant = 0.0,
        pi_quantv = 0.0,
        pi_status = '',
        pi_depto = '',
        pi_justifi = '',
        d_e_l_e_t_field = '',
        r_e_c_n_o_field = 0,
        r_e_c_d_e_l_field = 0;

  Spi010.fromMap(Map<String, dynamic> map)
      : pi_mat = map['pi_mat'],
        pi_data = map['pi_data'],
        pi_pd = map['pi_pd'],
        pi_quant = map['pi_quant'],
        pi_quantv = map['pi_quantv'],
        pi_status = map['pi_status'],
        pi_depto = map['pi_depto'],
        pi_justifi = map['pi_justifi'],
        d_e_l_e_t_field = map['d_e_l_e_t_field'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'],
        r_e_c_d_e_l_field = map['r_e_c_d_e_l_field'];

  @override
  String toString() {
    return "departamento: $pi_depto \nmatricula: $pi_mat";
  }

  Map<String, dynamic> toMap() {
    return {
      'pi_mat': pi_mat,
      'pi_data' : pi_data,
      'pi_pd' : pi_pd,
      'pi_quant' : pi_quant,
      'pi_quantv' : pi_quantv,
      'pi_status' : pi_status,
      'pi_depto' : pi_depto,
      'pi_justifi' : pi_justifi,
      'd_e_l_e_t_field' : d_e_l_e_t_field,
      'r_e_c_n_o_field' : r_e_c_n_o_field,
      'r_e_c_d_e_l_field' : r_e_c_d_e_l_field,
    };
  }
}
