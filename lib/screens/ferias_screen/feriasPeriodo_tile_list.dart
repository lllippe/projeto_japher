import 'package:projeto_aucs/models/srh010.dart';
import 'package:projeto_aucs/screens/ferias_screen/FeriasPeriodo_tile_card.dart';

List<FeriasPeriodoTileCard> generateListTileFeriasPeriodo({
  required Map<String, Srh010> database,
  required depto,
}) {

  List<FeriasPeriodoTileCard> list = [];

  database.forEach((key, value) {
    if (value.rh_mat != '') {
      list.add(FeriasPeriodoTileCard(
        srh010: value,
      ));
    }
  });

  return list;

}
