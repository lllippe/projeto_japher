import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/screens/homeoffice_screen/widget/HomeOffice_tile_card.dart';

List<HomeOfficeTileCard> generateListTilHomeOffice({
  required Map<String, Szh010>? database,
  required Map<String, Sze010>? databaseSze,
}) {

  List<HomeOfficeTileCard> list = [];

  if(database != null && databaseSze != null){
    database.forEach((key, value) {
      if (value.zh_mat != '') {
        databaseSze.forEach((keya, valuea) {
          if(value.zh_mat == valuea.ze_mat){
            list.add(HomeOfficeTileCard(
              name: valuea.ze_nome.trim(),
            ));
          }
        });
      }
    });
  }

  return list;

}
