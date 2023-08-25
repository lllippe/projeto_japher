
// ignore_for_file: non_constant_identifier_names

class Srh010 {
  String rh_mat;
  String rh_dataini;
  String rh_datafim;
  double rh_dferias;
  double rh_dferven;

  Srh010({
    required this.rh_mat,
    required this.rh_dataini,
    required this.rh_datafim,
    required this.rh_dferias,
    required this.rh_dferven,
  });

  Srh010.empty()
      : rh_mat = '',
        rh_dataini = '',
        rh_datafim = '',
        rh_dferias = 0,
        rh_dferven = 0;

  Srh010.fromMap(Map<String, dynamic> map)
      : rh_mat = map['rh_mat'],
        rh_dataini = map['rh_dataini'],
        rh_datafim = map['rh_datafim'],
        rh_dferias = map['rh_dferias'],
        rh_dferven = map['rh_dferven'];

  @override
  String toString() {
    return "nome: $rh_mat";
  }

  Map<String, dynamic> toMap() {
    return {
      'rh_mat': rh_mat,
      'rh_dataini': rh_dataini,
      'rh_datafim': rh_datafim,
      'rh_dferias': rh_dferias,
      'rh_dferven': rh_dferven,
    };
  }
}
