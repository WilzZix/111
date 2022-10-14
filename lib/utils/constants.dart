class Constants {
  static final String URL = 'http://api.lendo.uz/lendo/graphql';
  static final int CODE_DEFAULT = 99999;
  static final int CODE_SUCCESS = 0;
  static final int CODE_SUCCESS_MSG = 1;
  static final int CODE_FAIL = -1;

  static String formatSumm(String value) {
    var val = value.split('.');
    if (val[0] == 'null') {
      return '0.00';
    } else {
      for (int i = val[0].length - 3; i > 0; i -= 3) {
        val[0] = val[0].substring(0, i) + ' ' + val[0].substring(i);
      }
    }
    var res = val.join('.');

    if (val.length == 1) {
      res = res + '.00';
    } else if (val[1] == '') {
      res = res + '00';
    } else if (val[1].length == 1) {
      res = res + '0';
    }
    return res;
  }
}
