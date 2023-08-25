import 'package:projeto_aucs/models/sze010.dart';

class deleteHomeOfficeValidation{
  Map<String, Sze010> databaseGestor = {};

  bool colaboradorBelongs(String matColaborador, String matGestor){
    bool validate = false;

    if(matGestor != matColaborador){
      validate = true;
    }

    return validate;

  }
}
