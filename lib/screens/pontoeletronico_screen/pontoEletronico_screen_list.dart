import 'package:projeto_aucs/models/sp8010.dart';
import 'package:projeto_aucs/screens/pontoeletronico_screen/pontoEletronico_card.dart';

List<PontoEletronicoCard> generateListPontoEletronicoCards({
  required Map<String, Sp8010> databaseSintetico,
  required Map<int, Sp8010> database
}) {
  List<PontoEletronicoCard> list = [];
  int soma = 0;

  databaseSintetico.forEach((key, value) {
    if (value.p8_data != '') {
      database.forEach((keya, valuea) {
        if(valuea.p8_data == value.p8_data){
          soma++;
        }
      });
      list.add(PontoEletronicoCard(
        data: value,
        database: database,
        soma: soma,
      ));
    }
  });

  return list;
}
