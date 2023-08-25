import 'package:projeto_aucs/models/sqb010.dart';
import 'szh010_card.dart';

List<Szh010Card> generateListSzh010Cards({

  required Map<String, Sqb010> database,
  required Function refreshFunction,

}) {
  List<Szh010Card> list = [];

  database.forEach((key, value) {
    if (value.qb_depto != '') {
      list.add(Szh010Card(
        sqb010: value,
        refreshFunction: refreshFunction,
      ));
    }
  });

  return list;
}
