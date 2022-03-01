library r_router.src.utils.string;

int? stringToInt(String value, [int? defaultValue]) =>
    int.tryParse(value) ?? defaultValue;

double? stringToDouble(String value, [double? defaultValue]) =>
    double.tryParse(value) ?? defaultValue;

num? stringToNum(String value, [num? defaultValue]) =>
    num.tryParse(value) ?? defaultValue;

bool? stringToBool(String value, [bool? defaultValue]) {
  if (value == 'true') {
    return true;
  } else if (value == 'false') {
    return false;
  }
  return defaultValue;
}
