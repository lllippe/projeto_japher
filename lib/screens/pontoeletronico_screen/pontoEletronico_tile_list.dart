import 'package:projeto_aucs/models/sp8010.dart';
import 'package:projeto_aucs/screens/pontoeletronico_screen/PontoEletronico_tile_card.dart';

List<PontoEletronicoTileCard> generateListTilePontoEletronico({
  required Map<int, Sp8010>? database,
}) {

  List<PontoEletronicoTileCard> list = [];

  if(database != null){
    database.forEach((key, value) {
      if (value.p8_data != '') {
        list.add(PontoEletronicoTileCard(
          sp8010: value,
        ));
      }
    });
  }


  return list;

}
