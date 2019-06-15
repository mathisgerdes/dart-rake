bool _isStandardNum(s) => _numRegex.hasMatch(s);

bool _isOtherNum(s) => _numAltRegex.hasMatch(s);

bool isNum(String s) =>
    num.tryParse(s) != null || _isStandardNum(s) || _isOtherNum(s);

num tryParseNum(String s) {
  try {
    return num.parse(s);
  } catch (FormatException) {
    if (_isStandardNum(s))
      return num.parse(s.replaceAll(',', ''));
    else if (_isOtherNum(s))
      return num.parse(s.replaceAll('.', '').replaceFirst(',', '.'));
    return null;
  }
}

// ,000 then end or . or ,
RegExp _numRegex =
    RegExp(r'^([1-9][0-9]{0,2}(?:,[0-9]{3}(?=[,.]|$))*(\.[0-9]+)?)$');

// .000 then end or. or ,
RegExp _numAltRegex = RegExp(
    r'^((?:[0-9]+|[1-9][0-9]{0,2}(?:\.[0-9]{3}(?=[,.]|$))+)(,[0-9]+)?)$');
