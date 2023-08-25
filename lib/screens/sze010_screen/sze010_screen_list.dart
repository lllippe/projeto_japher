import 'package:projeto_aucs/models/sqb010.dart';
import 'sze010_card.dart';

List<Sze010Card> generateListSze010Cards({
  required int windowPage,
  required DateTime currentDay,
  required Map<String, Sqb010> database,
  required refreshFunction,
}) {
  List<Sze010Card> list = [];

  database.forEach((key, value) {
    if (value.qb_depto != '') {
      list.add(Sze010Card(
        showedDate: currentDay,
        sqb010: value,
        refreshFunction: refreshFunction,
      ));
    }
  });

  return list;
}
