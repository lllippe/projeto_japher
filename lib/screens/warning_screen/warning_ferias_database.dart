import 'package:projeto_aucs/models/sze010_falta_dias.dart';
import 'package:projeto_aucs/screens/warning_screen/warning_ferias_container_screen.dart';

List<FeriasWarningScreen> generateWarningFeriasScreen({
  required Map<String, Sze010FaltaDias> databaseFaltaDias,
  required Function refreshFunction,
  required String userId,
}) {
  List<FeriasWarningScreen> list = [];

  databaseFaltaDias.forEach(
        (key, value) {
      if(value.ze_mat == userId){
        list.add(
            FeriasWarningScreen(
              userId: userId,
              faltaDias: value,
              refreshFunction: refreshFunction,
            )
        );
      }
    },
  );
  return list;
}
