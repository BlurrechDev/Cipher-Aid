part of web_cipher_crack;

int population = 10;
int survival = 4;
int iterations = 1000;
int currentIteration = 0;

List<Substitution> subs = new List<Substitution>(population);

fineTune(int pop, int surv, int iter) {
  population = pop;
  survival = surv;
  iterations = iter;
}

List<String> possiblez() {
  List<String> sNarrow = fScan.getPatternsOfLength(1);
  sNarrow.removeWhere((String s) => s == s.toLowerCase());
  sNarrow.removeWhere((String s) => s.toUpperCase() == s.toLowerCase());
  return sNarrow;
}

int percentageSuccessMatch(Substitution subMap, String cipher) {
  int score = 0;
  String plainTextAttempt = subMap.getSubbedCipher(cipher);
  getWordsWithLength(3).then((String words) {
    for (String word in words.split('\n')) {
      if (plainTextAttempt.contains(word)) score += 1;
    }
  });
  getWordsWithLength(2).then((String words) {
    for (String word in words.split('\n')) {
      if (plainTextAttempt.contains(word)) score += 1;
    }
  });
  getWordsWithLength(4).then((String words) {
    for (String word in words.split('\n')) {
      if (plainTextAttempt.contains(word)) score += 1;
    }
  });
  getWordsWithLength(5).then((String words) {
    for (String word in words.split('\n')) {
      if (plainTextAttempt.contains(word)) score += 1;
    }
  });
  subMap.successRate = score;
  return subMap.successRate;
}

bool generateInitialSubMaps(String cipher) {
  List<String> possibleSymbols = fScan.getPatternsOfLength(1);
  if (possibleSymbols.isEmpty) {
    window.alert('You need some frequency data for the algorithm to work.');
    return false;
  }
  for (int x = 0; x < population; x++) {
    subs[x] = new Substitution.randomMap(possibleSymbols);
  }
  return true;
}

Substitution adjustSub(Substitution sub) {
  Random ran = new Random();
  int changed = ran.nextInt(sub.cipherEnglish.length);
  String a = sub.cipherEnglish[changed]; 
  String randomGuess;
  do {
    randomGuess = getRandomSymbol();
  } while (sub.cipherEnglish.contains(randomGuess) || randomGuess.toLowerCase() == randomGuess || randomGuess.toUpperCase() == randomGuess.toLowerCase());
  sub.cipherEnglish = sub.cipherEnglish.replaceFirst(a, randomGuess);
  return sub;
}

growSurvivingSubMaps(List<String> survivingMaps) {
  List<String> newGuesses = new List<String>(population);
  for (String guess in survivingMaps) newGuesses.add(guess);
}

Iterable getSurvivingSubMaps(String cipher) {
  Map<Substitution, int> scores = new Map<Substitution, int>();
  for (Substitution subMap in subs) {
    scores.putIfAbsent(subMap, () => percentageSuccessMatch(subMap, cipher));
  }
  Map<Substitution, int> survivingSubMaps = new Map<Substitution, int>();
  int count = 0;
  scores.forEach((Substitution sub, int value) {
    count++;
    if (count <= survival) survivingSubMaps.putIfAbsent(sub, () => value);
    for (int x = 0; x < survivingSubMaps.length; x++) {
      if (survivingSubMaps.values.elementAt(x) < value) {
        survivingSubMaps.remove(survivingSubMaps.keys.elementAt(x));
        survivingSubMaps.putIfAbsent(sub, () => value);
        return;
      }
    }
  });
  return survivingSubMaps.keys;
}

garnerSurvivers(String cipher) {
  List<Substitution> survivers = getSurvivingSubMaps(cipher).toList();
  for (int x = 0; x < survivers.length; x++) {
    subs[x] = adjustSub(survivers[x]);
  }
  List<String> possibleSymbols = fScan.getPatternsOfLength(1);
  for (int x = survivers.length; x < subs.length; x++) {
    subs[x] = new Substitution.randomMap(possibleSymbols);
  }
}

sortInSuccessOrder() {
  List<Substitution> orderedSubs = subs.toList();
  for (int x = 0; x < 200; x++) {
    for (int x = 1; x < subs.length; x++) {
      Substitution sub1 = orderedSubs[x - 1];
      Substitution sub2 = orderedSubs[x];
      if (sub2.successRate > sub1.successRate) {
        orderedSubs[x] = sub1;
        orderedSubs[x - 1] = sub2;
      }
    }
  }
  subs = orderedSubs;
}

evolve(String cipher) {
  if (generateInitialSubMaps(cipher)) {
    for (currentIteration; currentIteration < iterations; currentIteration++) {
      garnerSurvivers(cipher);
      sortInSuccessOrder();
      //print(subs);
    }
    print(subs);
    print(listToString(fScan.getPatternsOfLength(1)));
  }
}

printSurvivingMaps(String cipher) {
  frequencyScan(querySelector('#genetics'));
  new Timer(new Duration(seconds: 20), () {
    evolve(cipher);
    createGeneTable();
  });
}

createGeneTable() {
  TableElement t = querySelector('#gene_table');
  TableRowElement tr = t.addRow();
  List<String> collumnTitles = ['Gene Number', 'Cipher', 'Success', 'SurvivalRate'];
  for (String title in collumnTitles) {
    tr.addCell().text = title;
  }
}
