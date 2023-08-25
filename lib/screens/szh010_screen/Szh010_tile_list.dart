import 'package:projeto_aucs/models/sze010_falta_dias.dart';
import 'package:projeto_aucs/screens/szh010_screen/Szh010_tile_card.dart';

List<Szh010TileCard> generateListTileSzh010({
  required Map<String, Sze010FaltaDias> database,
  required depto,
}) {

  List<Szh010TileCard> list = [];

  database.forEach((key, value) {
    if (value.ze_depto != '') {
      if (value.ze_depto == depto.substring(0,1)) {
        list.add(Szh010TileCard(
          sze010: value,
          depto: depto,
        ));
      }
    }
  });

  return list;

}
