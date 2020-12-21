class CommonUtils {
  static String convertToDay(int i) {
    switch (i){
      case 0 :
        return "M";
      case 1 :
        return "T";
      case 2 :
        return "W";
      case 3 :
        return "T";
      case 4 :
        return "F";
      case 5 :
        return "S";
      case 6 :
        return "S";
      default:
        return "";
    }
  }
}