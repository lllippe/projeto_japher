import 'package:projeto_aucs/screens/sze010_screen/Sze010_tile_card.dart';
import '../../../models/sze010.dart';

List<Sze010TileCard> generateListTileSze010({
  required Map<String, Sze010> database,
  required depto,
}) {

  List<Sze010TileCard> list = [];

  database.forEach((key, value) {
    if (value.ze_depto != '') {
      if (value.ze_depto == depto.substring(0,1)) {
        list.add(Sze010TileCard(
          sze010: value,
          depto: depto,
        ));
      }
    }
  });

  return list;

}
