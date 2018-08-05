part of web_cipher_crack;

final DivElement inputCipher = querySelector('#input_cipher');
final DivElement outputMessage = querySelector('#output_message');
final DivElement guessPanel = querySelector('#guess_panel');

final TextAreaElement wordsReplace = querySelector('#words_replace');
final TextAreaElement wordsGuess = querySelector('#words_guess');

final DivElement controls = querySelector('#controls');
final DivElement cipherData = querySelector('#cipher_data');

final ButtonElement toggleControls = querySelector('#show_controls');
final ButtonElement toggleCipher = querySelector('#show_cipher');
final ButtonElement togglePlaintext = querySelector('#show_plaintext');
final ButtonElement toggleGuesses = querySelector('#show_guesses');

final InputElement newMap = querySelector('#new_map');
final ProgressElement cipherProgress = querySelector('#cipher_progress');

void loadInterfaceListeners() {
  print(controls == null);
  controls.style.display = 'block'; ///workaround required.
  toggleControls.onClick.listen((e) {
    if (controls.style.display == 'block') {
      toggleControls.text = 'Show Controls';
      controls.style.display = 'none';
    } else {
      toggleControls.text = 'Hide Controls';
      controls.style.display = 'block';
    }
  });
  
  inputCipher.style.display = 'block'; ///workaround required.
  toggleCipher.onClick.listen((e) {
    if (inputCipher.style.display == 'block') {
      toggleCipher.text = 'Show Cipher';
      inputCipher.style.display = 'none';
    } else {
      toggleCipher.text = 'Hide Cipher';
      inputCipher.style.display = 'block';
    }
  });
  
  outputMessage.style.display = 'block'; ///workaround required.
  togglePlaintext.onClick.listen((e) {
    if (outputMessage.style.display == 'block') {
      togglePlaintext.text = 'Show Plaintext';
      outputMessage.style.display = 'none';
    } else {
      togglePlaintext.text = 'Hide Plaintext';
      outputMessage.style.display = 'block';
    }
  });

  guessPanel.style.display = 'block'; ///workaround required.
  toggleGuesses.onClick.listen((e) {
    if (guessPanel.style.display == 'block') {
      toggleGuesses.text = 'Show Guesses';
      guessPanel.style.display = 'none';
    } else {
      toggleGuesses.text = 'Hide Guesses';
      guessPanel.style.display = 'block';
    }
  });

  inputCipher.onPaste.listen((e) {
    if (e.clipboardData == null) return;
    String pastedText = e.clipboardData.getData('text/plain');
    e.clipboardData.clearData();
    e.preventDefault();
    inputCipher.text = strip(pastedText);
    lock();
    updateIO();
  });
  
  querySelector('#reset_cipher').onClick.listen((e) {
    if (stripToText(inputCipher.text) == '') {
      window.alert("You can't reset the cipher until you have input a cipher.");
    } else {
      inputCipher.contentEditable = 'true';
      outputMessage.contentEditable = 'true';
      inputCipher.text = '';
      updateIO();
    }
  });
  
  querySelector('#update_cipher').onClick.listen((_) => updateIO());
  querySelector('#crack_sequence').onChange.listen((_) => updateIO());
  querySelector('#remap_sequence').onChange.listen((_) => updateIO());
  querySelector('#spaces').onChange.listen((_) => updateIO());
  querySelector('#alphabetical').onChange.listen((_) => updateIO());
  querySelector('#frequency').onChange.listen((_) => updateIO());
  querySelector('#aggregate').onChange.listen((_) => updateIO());

  querySelector('#guess_sort_alphabet').onClick.listen((_) {
    List<String> sorted = sortBy(ALPHABETICAL, wordsGuess.value, wordsReplace.value);
    for (int x = 0; x < 500; x++) sorted = sortBy(ALPHABETICAL, sorted[0], sorted[1]);
    wordsGuess.value = sorted[0];
    wordsReplace.value = sorted[1];
  });

  querySelector('#freq_scan').onClick.listen((MouseEvent e) => frequencyScan(e.relatedTarget));
  querySelector('#freq_cap').onChange.listen((Event e) => cacheFrequencyCap());
  querySelector('#genetics').onClick.listen((_) => printSurvivingMaps(inputCipher.text));
}

frequencyScan(Element e) {
  showSpinner(e);
  new Timer(new Duration(seconds: 1), () {
    while (!generateFrequencyData(8));
    FrequencyScanner fScan = new FrequencyScanner(querySelector('#freq_table'), [patterns, frequencies, freqAggregates, patterns, patterns], 
        ['Pattern', 'Frequency', 'Aggregate Frequency', 'Pattern with guess', 'Possible English Words']);
    for (Element e in querySelectorAll('#columnchart')) document.body.nodes.remove(e);
    ColumnChart.load().then((_) {
    List<String> symbs = fScan.getPatternsOfLength(1);
    ColumnChart freqData = new ColumnChart.fromData(getChartDiv(), 
        createFreqData(symbs, getFrequencyListFromPatterns(symbs)), 
        {
          'title': 'Symbol Frequency',
          'vAxis': {'maxValue': '1'}
        });
          
    symbs = fScan.getPatternsOfLength(2);
    freqData = new ColumnChart.fromData(getChartDiv(), 
        createFreqData(symbs, getFrequencyListFromPatterns(symbs)), 
        {
          'title': 'Digraph Frequency',
          'vAxis': {'maxValue': '1'}
        });
          
    symbs = fScan.getPatternsOfLength(3);
    freqData = new ColumnChart.fromData(getChartDiv(), 
        createFreqData(symbs, getFrequencyListFromPatterns(symbs)), 
        {
          'title': 'Trigraph Frequency',
          'vAxis': {'maxValue': '1'},
          'isStacked' : true,
        });
    });
    updateIO();
    stopSpinner();
  });
}

lock() {
  inputCipher.contentEditable = 'false';
  outputMessage.contentEditable = 'false';
  inputCipher.style.backgroundColor = '#e0ffff';
  outputMessage.style.backgroundColor = '#e0ffff';
}