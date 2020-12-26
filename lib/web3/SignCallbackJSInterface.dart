
import 'package:web3dart/web3dart.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'interface.dart';

class SignCallbackJSInterface {

  final WebView webView;
  final OnSignTransactionListener onSignTransactionListener;
  final OnSignMessageListener onSignMessageListener;
  final OnSignPersonalMessageListener onSignPersonalMessageListener;
  final OnSignTypedMessageListener onSignTypedMessageListener;
  final OnGetAccountListener onGetAccountListener;

  SignCallbackJSInterface(
      this.webView,
      this.onSignTransactionListener,
      this.onSignMessageListener,
      this.onSignPersonalMessageListener,
      this.onSignTypedMessageListener,this.onGetAccountListener);

  requestAccounts(int paramLong, String paramString)
  {
  print("####################requestAccounts: $paramString $paramLong");
  onGetAccountListener.getAccount(paramLong,paramString);
  }


//  void signTransaction(
//      int callbackId,
//      String recipient,
//      String value,
//      String nonce,
//      String gasLimit,
//      String gasPrice,
//      String payload) {
//    Transaction transaction = new Transaction(
//        recipient == null ? EthereumAddress.fromHex("0000000000000000000000000000000000000000") : new EthereumAddress.fromHex(recipient),
//        recipient == null ? EthereumAddress.fromHex("0000000000000000000000000000000000000000") : new EthereumAddress.fromHex(recipient),
//        Hex.hexToBigInteger(value),
//        Hex.hexToBigInteger(gasPrice, BigInteger.ZERO),
//        Hex.hexToLong(gasLimit, 300000),
//        Hex.hexToLong(nonce, -1),
//        payload,
//        callbackId);
//    onSignTransactionListener.onSignTransaction(transaction);
//
//  }
//
//  @JavascriptInterface
//  void signMessage(int callbackId, String data) {
//    print("#################### signMessage: ");
//    webView.post(() => onSignMessageListener.onSignMessage(new Message<>(data, getUrl(), callbackId)));
//  }
//
//  public void signPersonalMessage(int callbackId, String data) {
//    Log.d("####################", "signPersonalMessage: ");
//    webView.post(() -> onSignPersonalMessageListener.onSignPersonalMessage(new Message<>(data, getUrl(), callbackId)));
//  }
//
//  public void signTypedMessage(int callbackId, String data) {
//    Log.d("####################", "signTypedMessage: ");
//    webView.post(() -> {
//    TrustProviderTypedData[] rawData = new Gson().fromJson(data, TrustProviderTypedData[].class);
//    int len = rawData.length;
//    TypedData[] typedData = new TypedData[len];
//    for (int i = 0; i < len; i++) {
//    typedData[i] = new TypedData(rawData[i].name, rawData[i].type, rawData[i].value);
//    }
//    onSignTypedMessageListener.onSignTypedMessage(new Message<>(typedData, getUrl(), callbackId));
//    });
//  }
//
//  String getUrl() {
//    return webView == null ? "" : webView.getUrl();
//  }


}

class TrustProviderTypedData {
  String name;
  String type;
  dynamic value;
}
