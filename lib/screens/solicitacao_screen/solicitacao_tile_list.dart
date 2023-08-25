import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/screens/solicitacao_screen/Solicitacao_tile_card.dart';

List<SolicitacaoTileCard> generateListTileSolicitacao({
  required Map<String, Szh010> database,
  required matricula,
}) {

  List<SolicitacaoTileCard> list = [];

  database.forEach((key, value) {
    if (value.zh_mat != '') {
      if (value.zh_mat == matricula) {
        list.add(SolicitacaoTileCard(
          szh010: value,
          matricula: matricula,
        ));
      }
    }
  });

  return list;

}
