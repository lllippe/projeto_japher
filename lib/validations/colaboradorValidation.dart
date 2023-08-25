import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/services/sze010_service.dart';

Sze010Service _sze010service = Sze010Service();
Map<String, Sze010> database = {};

class colaboradorValidation{
  bool searchUniqueName(String name){
    bool validate = false;

    getNameUnique(name);

    database.forEach((key, value) {
      if(value.ze_nome.contains(name.toUpperCase())){
        validate = true;
      }
    });
    return validate;
  }
}

void getNameUnique(String name) async {
  _sze010service.getName(name).then((List<Sze010> listSze010) {
    for (Sze010 sze010 in listSze010) {
      database[sze010.ze_mat] = sze010;
    }
  });
}