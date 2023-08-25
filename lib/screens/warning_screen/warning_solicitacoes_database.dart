import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/screens/warning_screen/warning_solicitacoes_container_screen.dart';

List<SolicitacoesWarningScreen> generateWarningSolicitacoesScreen({
  required Map<String, Szh010> database,
  required Function refreshFunction,
  required String userId,
}) {
  int soma = 0;
  List<SolicitacoesWarningScreen> list = [];
  database.forEach(
        (key, value) {
      if(value.zh_mat != ''){
        list.add(
            SolicitacoesWarningScreen(
              userId: userId,
              solicitacoes: value,
              refreshFunction: refreshFunction,
              soma: soma,
            )
        );
      }
      soma++;
    },
  );
  return list;
}
