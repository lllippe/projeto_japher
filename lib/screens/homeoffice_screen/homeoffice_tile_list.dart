import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/screens/homeoffice_screen/homeoffice_tile_card.dart';

List<HomeOfficeTileCard> generateListTileHomeOffice({
  required Map<String, Sze010> database,
  required Map<String, Szh010> databaseSzh,
  required matricula,
  required recno,
  required data,
}) {

  List<HomeOfficeTileCard> list = [];

  database.forEach((key, value) {
    if (value.ze_mat != '') {
      databaseSzh.forEach((keySzh, valueSzh) {
        if (value.ze_mat == valueSzh.zh_mat) {
          list.add(HomeOfficeTileCard(
            sze010: value,
            matricula: matricula,
            recno: recno,
            data: data,
          ));
        }
      });
    }
  });

  return list;

}
