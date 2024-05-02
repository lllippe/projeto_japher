import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/screens/solicitacao_screen/solicitacao_card.dart';

List<SolicitacaoCard> generateListSolicitacaoCards({
  required Map<String, Sze010> database,
  required Map<int, Szh010> databaseSzh,
}) {
  List<SolicitacaoCard> list = [];
  List<String> containsName = [];

  databaseSzh.forEach((key, valueSzh) {
    database.forEach((key, value) {
      if (value.ze_mat == valueSzh.zh_mat) {
        if(!containsName.contains(value.ze_mat)){
          list.add(
            SolicitacaoCard(
              sze010: value,
              szh010:valueSzh,
            ),
          );
        }
        print(list);
        print(containsName);
        containsName.add(value.ze_mat);
      }
    });
  });

  return list;
}
