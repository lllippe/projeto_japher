import 'package:projeto_aucs/models/ferias.dart';
import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/services/homeoffice_service.dart';
import 'package:projeto_aucs/services/srh010_service.dart';

final HomeOfficeService _homeOfficeService = HomeOfficeService();
final Srh010Service _srh010Service = Srh010Service();
Map<int, FeriasSze> databaseVacation = {};
Map<int, Szh010> databaseHomeOffice = {};

class homeOfficeValidation{
  bool searchUniqueName(String matriculaColab, String initialDate){
    bool validate = false;

    getSzh010();

    databaseHomeOffice.forEach((key, value) {
      if(value.zh_mat == matriculaColab && value.zh_dataini == initialDate){
        validate = true;
      }
    });

    databaseHomeOffice = {};

    return validate;

  }

  bool SearchColabVacation(String name, DateTime initialDate) {
    bool validate = false;
    getSrh010(name);

    databaseVacation.forEach((key, value) {
      if(value.rh_dataini != '        ' && value.rh_datafim != '        ') {
        DateTime dateInitialPeriod = DateTime(int.parse(value.rh_dataini.substring(0, 4)),
            int.parse(value.rh_dataini.substring(4, 6)),
            int.parse(value.rh_dataini.substring(6, 8)));
        DateTime dateFinalPeriod = DateTime(int.parse(value.rh_datafim.substring(0, 4)),
            int.parse(value.rh_datafim.substring(4, 6)),
            int.parse(value.rh_datafim.substring(6, 8)));
        if ((initialDate.isAfter(dateInitialPeriod)
            && initialDate.isBefore(dateFinalPeriod)) ||
            (initialDate.isAtSameMomentAs(dateInitialPeriod) ||
                initialDate.isAtSameMomentAs(dateFinalPeriod))) {
          validate = true;
        }
      }
    });

    databaseVacation = {};

    return validate;

  }

}

void getSrh010(String matriculaColab) async{
  _srh010Service.getId(matriculaColab).then((List<FeriasSze> listSrh010) {
    for(FeriasSze srh010 in listSrh010){
      databaseVacation[srh010.r_e_c_n_o_field] = srh010;
    }
  });
}

void getSzh010() async {
  _homeOfficeService.getAll().then((List<Szh010> listSzh010) {
    for (Szh010 szh010 in listSzh010) {
      databaseHomeOffice[szh010.r_e_c_n_o_field] = szh010;
    }
  });
}

