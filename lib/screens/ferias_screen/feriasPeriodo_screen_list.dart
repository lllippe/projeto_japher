import 'package:projeto_aucs/models/periodos.dart';
import 'package:projeto_aucs/screens/ferias_screen/feriasPeriodo_card.dart';

List<FeriasPeriodoCard> generateListFeriasPeriodoCards({
  required Map<String, Periodos> database,
}) {
  List<FeriasPeriodoCard> list = [];

  database.forEach((key, value) {
    if (value.rf_databas != '') {
      list.add(FeriasPeriodoCard(
        periodos: value,
      ));
    }
  });

  return list;
}
