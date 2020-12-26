class JsInjectorResponse {
  final String data;
  final String url;
  final String mime;
  final String charset;
  final bool isRedirect;

  JsInjectorResponse(
      this.data, this.url, this.mime, this.charset, this.isRedirect);
}
