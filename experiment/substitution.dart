part of web_cipher_crack;

class Substitution {
  final List<String> cipherAlphabet;
  String cipherEnglish = ''; /// May just be a guess.
  final List<String> usedLetters = [];
  int successRate = 0;
  
  Substitution.randomMap(this.cipherAlphabet) {
    final List<String> subGuess = new List<String>(population);
    
    for (String symbol in cipherAlphabet) {
      String randomGuess;
      do {
        randomGuess = getRandomSymbol();
      } while (usedLetters.contains(randomGuess) || randomGuess.toLowerCase() == randomGuess || randomGuess.toUpperCase() == randomGuess.toLowerCase());
      usedLetters.add(randomGuess);
      cipherEnglish = '$cipherEnglish$randomGuess';
    }
  }
  
  String getSubbedCipher(String cipher) {
    return applyConversionGuess(eradicateSymbols(cipher), listToString(cipherAlphabet), cipherEnglish);
  }
  
  toString() {
    return cipherEnglish;
  }

}