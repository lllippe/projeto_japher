
// ignore_for_file: non_constant_identifier_names

class Sze010 {
  String ze_mat;
  String ze_nome;
  String ze_admissa;
  String ze_fperaq;
  String ze_fervenc;
  String ze_dirferi;
  String ze_feragen;
  double ze_diasfer;
  double ze_saldfer;
  String ze_antefer;
  String ze_ferpg;
  String ze_depto;
  String ze_niver;
  String ze_conveni;
  String ze_email;
  int r_e_c_n_o_field;

  Sze010({
    required this.ze_mat,
    required this.ze_nome,
    required this.ze_admissa,
    required this.ze_fperaq,
    required this.ze_fervenc,
    required this.ze_dirferi,
    required this.ze_feragen,
    required this.ze_diasfer,
    required this.ze_saldfer,
    required this.ze_antefer,
    required this.ze_ferpg,
    required this.ze_depto,
    required this.ze_niver,
    required this.ze_conveni,
    required this.ze_email,
    required this.r_e_c_n_o_field,
  });

  Sze010.empty()
      : ze_mat = '999999',
        ze_nome = '',
        ze_admissa = '',
        ze_fperaq = '',
        ze_fervenc = '',
        ze_dirferi = '',
        ze_feragen = '',
        ze_diasfer = 0,
        ze_saldfer = 0,
        ze_antefer = '',
        ze_ferpg = '',
        ze_depto = '',
        ze_niver = '',
        ze_conveni = '',
        ze_email = '',
        r_e_c_n_o_field = 0;

  Sze010.fromMap(Map<String, dynamic> map)
      : ze_mat = map['ze_mat'],
        ze_nome = map['ze_nome'],
        ze_admissa = map['ze_admissa'],
        ze_fperaq = map['ze_fperaq'],
        ze_fervenc = map['ze_fervenc'],
        ze_dirferi = map['ze_dirferi'],
        ze_feragen = map['ze_feragen'],
        ze_diasfer = map['ze_diasfer'],
        ze_saldfer = map['ze_saldfer'],
        ze_antefer = map['ze_antefer'],
        ze_ferpg = map['ze_ferpg'],
        ze_depto = map['ze_depto'],
        ze_niver = map['ze_niver'],
        ze_conveni = map['ze_conveni'],
        ze_email = map['ze_email'],
        r_e_c_n_o_field = map['r_e_c_n_o_field'];

  @override
  String toString() {
    return "matricula: $ze_mat \nnome: $ze_nome";
  }

  Map<String, dynamic> toMap() {
    return {
      'ze_mat': ze_mat,
      'ze_nome': ze_nome,
      'ze_admissa': ze_admissa,
      'ze_fperaq': ze_fperaq,
      'ze_fervenc': ze_fervenc,
      'ze_dirferi': ze_dirferi,
      'ze_feragen': ze_feragen,
      'ze_diasfer': ze_diasfer,
      'ze_saldfer': ze_saldfer,
      'ze_antefer': ze_antefer,
      'ze_ferpg': ze_ferpg,
      'ze_depto': ze_depto,
      'ze_niver' : ze_niver,
      'ze_conveni' : ze_conveni,
      'ze_email' : ze_email,
      'r_e_c_n_o_field': r_e_c_n_o_field,
    };
  }
}
