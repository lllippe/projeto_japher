import 'package:projeto_aucs/models/spi010.dart';
import 'package:projeto_aucs/screens/bancohoras_screen/bancoHoras_card.dart';

List<BancoHorasCard> generateListBancoHorasCards({
  required Map<String, Spi010> databaseSintetico,
  required Map<int, Spi010> database,
  required String titulo,
  required int detail,
}) {
  List<BancoHorasCard> list = [];
  int soma = 0;
  double totalDia = 0;

  databaseSintetico.forEach((key, value) {
    if (value.pi_data != '') {
      database.forEach((keya, valuea) {
        if(valuea.pi_data == value.pi_data){
          soma++;
          totalDia += valuea.pi_quant;
        }
      });
    }
  });
  list.add(BancoHorasCard(
    //data: value,
    database: database,
    soma: soma,
    totalDia: totalDia,
    titulo: titulo,
    detail: detail,
  ));

  return list;
}
