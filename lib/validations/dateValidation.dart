import 'dart:core';
import 'package:projeto_aucs/models/sx5010.dart';
import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/services/sx5010_service.dart';
import 'package:projeto_aucs/services/szh010_service.dart';

Sx5010Service _sx5010service = Sx5010Service();
Szh010Service _szh010service = Szh010Service();
Map<String, Sx5010> database = {};
Map<String, Szh010> databaseSzh010 = {};

class dateValidation {
  bool endHoliday(DateTime? start, DateTime? end, int? days) {
    getSx5010();

    bool validate = false;

    database.forEach((key, value) {
      DateTime dateHoliday = DateTime(int.parse(value.x5_descri.substring(6, 10)),
          int.parse(value.x5_descri.substring(3, 5)),
          int.parse(value.x5_descri.substring(0, 2)));

      if (end?.add(const Duration(days: 1)).compareTo(dateHoliday) == 0) {
        if (days! > 0) {
          validate = true;
        } else {
          validate = false;
        }
      }
    });

    return validate;
  }

  bool startHoliday(DateTime? start) {
    getSx5010();

    bool validate = false;

    database.forEach((key, value) {
      DateTime dateHoliday = DateTime(int.parse(value.x5_descri.substring(6, 10)),
          int.parse(value.x5_descri.substring(3, 5)),
          int.parse(value.x5_descri.substring(0, 2)));

      if (dateHoliday.compareTo(start!) == 0) {
        if (validate == false) {
          validate = true;
        }
      }
    });

    return validate;
  }

  bool dateWeekend(DateTime? end, int days) {
    bool validate = false;

    if (end?.weekday == 5 || end?.weekday == 6) {
      if (days != 0){
        validate = true;
      }
    }

    return validate;

  }

  bool daysAvailable(int days, int daysLeft) {

    if (daysLeft < 0) {
      return true;
    } else {
      return false;
    }
  }

  bool periodLong(int days, int daysLeft) {

    if (days < 7 && daysLeft > 0) {
      return true;
    } else {
      return false;
    }
  }

  bool periodAvailable(String mat, String initialDate, String finalDate,
      DateTime dateInitialRequision, DateTime dateFinalRequision) {
    bool validate = false;

    getPeriodSolicitated(mat, initialDate, finalDate);

    databaseSzh010.forEach((key, value) {
      DateTime dateInitialPeriod = DateTime(int.parse(value.zh_dataini.substring(0, 4)),
        int.parse(value.zh_dataini.substring(4, 6)),
        int.parse(value.zh_dataini.substring(6, 8)));
      DateTime dateFinalPeriod = DateTime(int.parse(value.zh_datafim.substring(0, 4)),
        int.parse(value.zh_datafim.substring(4, 6)),
        int.parse(value.zh_datafim.substring(6, 8)));

      if ((dateInitialRequision.isAfter(dateInitialPeriod)
          && dateInitialRequision.isBefore(dateFinalPeriod)) ||
          (dateInitialRequision.isAtSameMomentAs(dateInitialPeriod) ||
          dateInitialRequision.isAtSameMomentAs(dateFinalPeriod))) {
        validate = true;
      } else if ((dateFinalRequision.isAfter(dateInitialPeriod)
          && dateFinalRequision.isBefore(dateFinalPeriod)) ||
          (dateFinalRequision.isAtSameMomentAs(dateInitialPeriod) ||
              dateFinalRequision.isAtSameMomentAs(dateFinalPeriod))) {
        validate = true;
      }
    });
    return validate;
  }
}

void getSx5010() async {
  _sx5010service.getAll().then((List<Sx5010> listSx5010) {
    for (Sx5010 sx5010 in listSx5010) {
      database[sx5010.x5_descri] = sx5010;
    }
  });
}

void getPeriodSolicitated(String mat, String initialDate, String finalDate) async {
  _szh010service.searchUnique(mat, initialDate, finalDate).then((List<Szh010> listSzh010) {
    for (Szh010 szh010 in listSzh010) {
      databaseSzh010[szh010.zh_mat] = szh010;
    }
  });
}
