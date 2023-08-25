
class bancoHorasValidation{
  bool hourDifferentZero(double hour){
    bool validate = false;

    if(hour == 0.0){
      return validate = true;
    }

    return validate;
  }

  bool justificationDifferentBlank(String justification){
    bool validate = false;

    if(justification == ''){
      return validate = true;
    }

    return validate;
  }

  bool dateDifferenteBlank(String date){
    bool validate = false;

    if(date == ''){
      return validate = true;
    }

    return validate;
  }
}
