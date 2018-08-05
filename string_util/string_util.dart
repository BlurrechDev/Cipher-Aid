part of web_cipher_crack;

String listToString(List list) {
  return list.toString().replaceAll(',', '').replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '');
}

String shift(String cipher, int shiftVal) {
  for (int x = 0; x < shiftVal; x++) cipher = translateLetter(cipher);
  return cipher;
}

String translateLetter(String str) {
    StringBuffer sb = new StringBuffer();
    for (int i = 0; i < str.length; i++) {
        int ch = str.codeUnitAt(i);
        if ((ch >= 65 && ch <= 90) || (ch >= 97 && ch <= 122)) {
            if (ch == 90 || ch == 122) {
              ch -= 25;
            } else {
              ch++;
            }
        }
        sb.writeCharCode(ch);
    }
    return sb.toString();
}

String cipherSpaceSeperate(String cipher, int spaceGap) {
  int space = spaceGap;
  String newString = '';
  for (String letter in stripToText(cipher).split('')) {
    newString = '$newString$letter';
    if (space == 0) {
      newString = '$newString ';
      space = spaceGap;
    } else {
      space--;
    }
  }
  return newString;
}

String reorderSequence(String cipher, List<int> newMappings) {
  if (newMappings.isEmpty) {
    window.alert('You must enter a map before you can remap the sequence.');
    shouldRemap = false;    ///UI Code
    updateIO();
    return cipher;
  } else if ((textCount(stripToText(cipher)) / newMappings.length).round() != (textCount(stripToText(cipher)) / newMappings.length)) {
    window.alert('You must enter a map that divides the ciphers letter pattern exactly.');
    shouldRemap = false;    ///UI Code
    updateIO();
    return cipher;
  }
  String newSequence = '';
  cipher = stripToText(cipher);
  for (int x = newMappings.length; x < cipher.length; x += newMappings.length) {
      newSequence = '$newSequence${reorderMapping(cipher.substring(x - newMappings.length, x), newMappings)}';
  }
  return newSequence;
}

String reorderMapping(String toRemap, List<int> newMappings) {
  String newMapping = '';
  for (int x = 0; x < newMappings.length; x++) {
    String remap = toRemap.substring(newMappings[x] - 1, newMappings[x]);
    newMapping = '$newMapping$remap';
  }
  return newMapping;
}

String applyConversionGuess(String cipher, String a, String b) {
  for (int x = 0; x < a.length; x++) {
    String aLetter = a.substring(x, x + 1);
    String bLetter = b.substring(x, x + 1);
    cipher = cipher
        .replaceAll('$CHANGE$aLetter', HOLDER)
        .replaceAll(aLetter, '$CHANGE$bLetter')
        .replaceAll(HOLDER, '$CHANGE$aLetter');
  }
  return cipher;
}

String applyConversionDigraph(String cipher, String a, String b) {
  for (int x = 0; x + 1 < a.length; x++) {
    String aLetter = a.substring(x, x + 2);
    String bLetter = b.substring(x, x + 1);
    cipher = cipher
        .replaceAll('$CHANGE$aLetter', HOLDER)
        .replaceAll(aLetter, '$CHANGE$bLetter')
        .replaceAll(HOLDER, '$CHANGE$aLetter');
  }
  return cipher;
}