import 'package:projeto_aucs/models/convenios.dart';
import 'package:projeto_aucs/screens/warning_screen/warning_convenio_container_screen.dart';

List<ConvenioWarningScreen> generateWarningConvenioScreen({
  required Map<String, Convenios> database,
  required Function refreshFunction,
  required String userId,
}) {
  List<ConvenioWarningScreen> list = [];
  //Preenche os espaços que possuem entradas no banco
  database.forEach(
        (key, value) {
      if(value.ze_mat == userId){
        list.add(
          ConvenioWarningScreen(
            userId: userId,
            convenio: value,
            refreshFunction: refreshFunction,
          )
        );
      }
    },
  );
  return list;
}
