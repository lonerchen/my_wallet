package com.example.you_wallet

import android.os.Bundle
import android.os.PersistableBundle
import android.text.TextUtils
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import trust.core.entity.Address
import trust.core.entity.Message
import trust.core.entity.Transaction
import trust.core.entity.TypedData
import trust.web3.Web3View
import java.util.*

class Web3ViewActivity : AppCompatActivity() {

    lateinit var web3View : Web3View;

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.web3view_page)
        web3View = findViewById(R.id.web3view)
        val chainId : Int = intent.getStringExtra("chainId").toInt()
        val rpcServerUrl = intent.getStringExtra("rpcServerUrl")
        val address =  Address(intent.getStringExtra("walletAddress"))
        val url :String = intent.getStringExtra("url")
        initWeb3View(chainId,rpcServerUrl,address,url);
    }


    private fun initWeb3View(chainId :Int, rpcServerUrl : String,walletAdress: Address,url: String) {
        //此处设置的区块链ID及节点RPC URL是根据用户在设置里面选择的不同网络来返回的
        web3View.chainId = chainId
        web3View.setRpcUrl(rpcServerUrl)
        web3View.setWalletAddress(walletAdress)
        //web3View.setOnSignTransactionListener { transaction: Transaction ->
        //    transaction = transaction
        //    val intent = Intent(this, ConfirmationActivity::class.java)
        //    intent.putExtra(C.EXTRA_TO_ADDRESS, transaction.recipient.toString())
        //    intent.putExtra(C.EXTRA_AMOUNT, transaction.value.toString())
        //    intent.putExtra(C.EXTRA_CONTRACT_ADDRESS, transaction.contract.toString())
        //    intent.putExtra(C.EXTRA_DECIMALS, 18)
        //    intent.putExtra(C.EXTRA_DAPP_DATA, transaction.payload)
        //    intent.putExtra(C.EXTRA_IS_DAPP, true)
        //    intent.putExtra(C.EXTRA_SYMBOL, ethereumNetworkRepository.getDefaultNetwork().symbol)
        //    intent.putExtra(C.EXTRA_SENDING_TOKENS, false)
        //    startActivityForResult(intent, com.wallet.crypto.trustapp.ui.DappBrowserActivity.DAPP_REQUEST_CODE)
        //}
        web3View.setOnSignMessageListener { message: Message<String> -> Log.d("flutter:" +  "onSignMessage: " , message.value) }
        web3View.setOnSignMessageListener { message: Message<String> -> Log.d("flutter:" +  "onSignMessage: " , message.value) }
        web3View.setOnSignTypedMessageListener { message: Message<Array<TypedData?>> -> Log.d("flutter:" + "onSignMessage: " , message.value.toString()) }
        web3View.setOnGetAccountListener { paramLong: Long, paramString: String? ->
            if (TextUtils.isEmpty(paramString)) {
                return@setOnGetAccountListener
            }
            var paramString = web3View.address.toString()
            val localObject = String.format("window.ethereum.setAddress('%1\$s')", *Arrays.copyOf(arrayOf<Any>(paramString), 1))
            paramString = String.format("window.ethereum.sendResponse(%1\$s, ['%2\$s'])", *Arrays.copyOf(arrayOf<Any>(java.lang.Long.valueOf(paramLong), paramString), 2))
            val finalParamString: String = paramString
            web3View.post {
                web3View.evaluateJavascript(localObject) { value: String? -> Log.d("WEB_VIEW", value) }
                web3View.evaluateJavascript(finalParamString) { value: String? -> Log.d("WEB_VIEW", value) }
            }
        }

        web3View.loadUrl(url)

    }


}