part of web_cipher_crack;

String strip(String html) {
  NodeValidatorBuilder v = new NodeValidatorBuilder.common();
  v.allowTextElements();
  v.allowElement('INT');
  v.allowTemplating();
  DivElement tmp = new DivElement();
  tmp.setInnerHtml(html);
  return tmp.text;
}

String stripToText(String cipher) => cipher.replaceAll(' ', '').replaceAll('\n', '');