part of web_cipher_crack;

var lastSpinner;

showSpinner(Element onMe) {
  lastSpinner = new JsObject(context['Spinner']);
  lastSpinner.callMethod('spin', [onMe]);
}

stopSpinner() => lastSpinner.callMethod('stop');