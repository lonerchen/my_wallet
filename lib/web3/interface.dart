

import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:youwallet/trust/entity/message.dart';
import 'package:youwallet/trust/entity/typed.dart';

abstract class UrlHandler {

  String getScheme();

  String handle(Uri uri);

}

abstract class OnGetAccountListener {
  void getAccount(int paramLong, String paramString);
}

abstract class OnSignMessageListener {
  void onSignMessage(Message<String> message);
}

abstract class OnSignPersonalMessageListener {
  void onSignPersonalMessage(Message<String> message);
}

abstract class OnSignTransactionListener {
  void onSignTransaction(Transaction transaction);
}

abstract class OnSignTypedMessageListener {
  void onSignTypedMessage(Message<List<TypedData>> message);
}

