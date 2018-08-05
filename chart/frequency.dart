part of web_cipher_crack;

void createSymbolFrequencyChart(List<String> symbols, List<int> frequencies) {
  for (int x = 0; x < symbols.length; x++) {
    String symbol = symbols[x];
    int freq = frequencies[x];
  }
}

List createFreqData(List<String> symbs, List<num> freqs) {
  List<List> data = [];
  data.add(['Symbol', 'Frequency']);
  for (int x = 0; x < symbs.length; x++) {
    String symbol = symbs[x];
    num freq = freqs[x];
    data.add([symbol, freq]);
  }
  return data;
}

DivElement getChartDiv() {
  return new DivElement()
      ..style.width = '100%'
      ..style.height = '600px'
      ..id = 'columnchart';
}

  // Setup the chart
  /*ColumnChart.load().then((_) {
    List data = createFreqData(symbs, freqs);
    ColumnChart freqData = new ColumnChart.fromData(visualization, data, 
        {
      'title': 'Symbol Frequency',
      'vAxis': {'maxValue': '1'}
        });
    int sliderValue() => int.parse(slider.value);
    slider.onChange.listen((_) => freqData.value = sliderValue() / 100);
  });*/
