import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/screens/homeoffice_screen/homeoffice_card.dart';

List<HomeOfficeCard> generateListHomeOfficeCards({

  required Map<String, Szh010> database,
  required Function refreshFunction,

}) {
  List<HomeOfficeCard> list = [];

  database.forEach((key, value) {
    if (value.zh_mat != '') {
      list.add(HomeOfficeCard(
        szh010: value,
        refreshFunction: refreshFunction,
      ));
    }
  });

  return list;
}
