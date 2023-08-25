import 'package:projeto_aucs/models/spi010.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/screens/bancohoras_screen/bancoHoras_tile_card.dart';

List<BancoHorasTileCard> generateListTileBancoHoras({
  required Map<int, Spi010>? database,
  required Map<String, Sze010>? databaseSze,
  required int detail,
  //required Spi010? data,
}) {

  List<BancoHorasTileCard> list = [];

  if(database != null && databaseSze != null){
    database.forEach((key, value) {
      if (value.pi_data != '') {
        //if(data!.pi_data == value.pi_data){
        databaseSze.forEach((keya, valuea) {
          if(value.pi_mat == valuea.ze_mat){
            list.add(BancoHorasTileCard(
              spi010: value,
              nome: valuea.ze_nome.trim(),
              detail: detail,
            ));
          }
        });
           //}
      }
    });
  }

  return list;

}
