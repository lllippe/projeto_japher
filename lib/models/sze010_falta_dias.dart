
// ignore_for_file: non_constant_identifier_names

class Sze010FaltaDias {
  String ze_mat;
  String ze_nome;
  String ze_fperaq;
  double ze_saldfer;
  String ze_depto;
  int r_e_c_n_o_field;

  Sze010FaltaDias({
    required this.ze_mat,
    required this.ze_nome,
    required this.ze_fperaq,
    required this.ze_saldfer,
    required this.ze_depto,
    required this.r_e_c_n_o_field,
  });

  Sze010FaltaDias.empty()
      : ze_mat = '',
        ze_nome = '',
        ze_fperaq = '',
        ze_saldfer = 0,
        ze_depto = '',
        r_e_c_n_o_field = 0;

  Sze010FaltaDias.fromMap(Map<String, dynamic> map)
      : ze_mat = map['ze_mat'],
        ze_nome = map['ze_nome'],
        ze_fperaq = map['ze_fperaq'],
        ze_saldfer = map['ze_saldfer'],
        ze_depto = map['ze_depto'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'];

  @override
  String toString() {
    return "nome: $ze_nome";
  }

  Map<String, dynamic> toMap() {
    return {
      'ze_mat': ze_mat,
      'ze_nome': ze_nome,
      'ze_fperaq': ze_fperaq,
      'ze_saldfer': ze_saldfer,
      'ze_depto': ze_depto,
      'r_e_c_n_o_field': r_e_c_n_o_field,
    };
  }
}
