part of web_cipher_crack;

List<int> getFactors(int ofMe) {
  List<int> divisors = [];
  List<int> quotients = [];
  for (int x = 1; x < sqrt(ofMe); x++) {
    num quotient = ofMe / x;
    if (quotient.round() == quotient) {
      divisors.add(x);
      quotients.add(quotient.toInt());
    }
  }
  divisors.addAll(quotients.reversed);
  return divisors;
}