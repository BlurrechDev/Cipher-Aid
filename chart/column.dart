part of web_cipher_crack;

class ColumnChart {
  var jsOptions;
  var jsTable;
  var jsChart;
  
  ColumnChart.fromData(Element element, List data, Map options) {
    document.body.nodes.add(element);
    final vis = context["google"]["visualization"];
    jsTable = vis.callMethod('arrayToDataTable', [new JsObject.jsify(data)]);
    jsChart = new JsObject(vis["ColumnChart"], [element]);
    jsOptions = new JsObject.jsify(options);
    draw();
  }

  draw() {
    //jsTable.callMethod('setValue', [0, 1, value]);
    jsChart.callMethod('draw', [jsTable, jsOptions]);
  }
  
  static Future load() {
    Completer c = new Completer();
    context["google"].callMethod('load',
       ['visualization', '1', new JsObject.jsify({
         'packages': ['corechart'],
         'callback': new JsFunction.withThis(c.complete)
       })]);
    return c.future;
  }
}
