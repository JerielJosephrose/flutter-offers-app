mixin ToAlias {

}

@deprecated
class CElement = CountryCode with ToAlias;

/// Country element. This is the element that contains all the information
class CountryCode {
  /// the name of the country
  String name;

  /// the flag of the country
  String flag;

  /// the country code (IT,AF..)
  String code;

  /// the dial code (+39,+93..)
  String dialCode;

  CountryCode({this.name, this.flag, this.code, this.dialCode});

  @override
  String toString() => "$dialCode";

  String toLongString() => "$name $dialCode";

  String toCountryStringOnly() => '$name';
}
