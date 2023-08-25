import 'package:projeto_aucs/models/sx5010.dart';
import 'package:projeto_aucs/services/sx5010_service.dart';

Sx5010Service _sx5010service = Sx5010Service();
Map<String, Sx5010> database = {};

class pontoEletronicoValidation{
  bool availableTime(DateTime time){
    int initialHourAvailable = 7;
    int initialMinuteAvailable = 49;
    int finalHourAvailable = 18;
    int finalHourAvailableTh = 17;
    int finalMinuteAvailable = 9;
    int finalMinuteAvailableTh = 39;
    bool validate = false;

    if(time.weekday == 6 || time.weekday == 7){
      return validate = true;
    }

    if(time.hour == initialHourAvailable && time.minute < initialMinuteAvailable){
      return validate = true;
    }

    if(time.hour < initialHourAvailable){
      return validate = true;
    }

    if(time.weekday == 4 || time.weekday == 5){
      if(time.hour == finalHourAvailableTh && time.minute > finalMinuteAvailableTh){
        return validate = true;
      }
    } else {
      if(time.hour == finalHourAvailable && time.minute > finalMinuteAvailable){
        return validate = true;
      }
    }

    if(time.weekday == 4 || time.weekday == 5){
      if(time.hour > finalHourAvailableTh){
        return validate = true;
      }
    } else {
      if(time.hour > finalHourAvailable){
        return validate = true;
      }
    }

    return validate;
  }

  bool dayHoliday(DateTime? time) {
    getSx5010();

    bool validate = false;

    database.forEach((key, value) {
      DateTime dateHoliday = DateTime(int.parse(value.x5_descri.substring(6, 10)),
          int.parse(value.x5_descri.substring(3, 5)),
          int.parse(value.x5_descri.substring(0, 2)));

      if (dateHoliday.compareTo(time!) == 0) {
        if (validate == false) {
          validate = true;
        }
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