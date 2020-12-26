
import 'package:flutter/material.dart';

import 'JsInjectorResponse.dart';

class JsInjectorClient {

  static final String DEFAULT_CHARSET = "utf-8";
  static final String DEFAULT_MIME_TYPE = "text/html";
  static String JS_TAG_TEMPLATE (s1,s2) => "<script type=\"text/javascript\">$s1$s2</script>";

  String jsLibrary;

  int chainId = 1;
  String walletAddress;
  String rpcUrl = "https://ropsten.infura.io/v3/8533ef82c9744d38801f512fdd004133";

  JsInjectorClient(BuildContext context) {
//    this.context = context;
//    this.httpClient = createHttpClient();
  }

//  JsInjectorResponse loadUrl(final String url, final Map<String, String> headers) {
//    Request request = buildRequest(url, headers);
//    JsInjectorResponse result = null;
//    try {
//      Response response = httpClient.newCall(request).execute();
//      result = buildResponse(response);
//    } catch (Exception ex) {
//    Log.d("REQUEST_ERROR", "", ex);
//    }
//    return result;
//  }

}