import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/screens/add_screen/widgets/add_homeoffice_tile_card.dart';

List<AddHomeOfficeTileCard> generateListTileBancoHoras({
  required Map<String, Sze010>? database,
  required List<String>? selectedItems,
}) {

  List<AddHomeOfficeTileCard> list = [];

  if(database != null){
    database.forEach((key, value) {
      list.add(AddHomeOfficeTileCard(
        sze010: value,
        selectedItems: selectedItems,
      ));
    });
  }

  return list;

}
