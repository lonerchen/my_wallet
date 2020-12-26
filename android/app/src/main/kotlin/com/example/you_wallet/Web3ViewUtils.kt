package com.flutter.common.channel

import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat.startActivity
import com.example.you_wallet.Web3ViewActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class Web3ViewUtils {

    /**
     * Flutter端的MethodChannel
     */
    companion object {
        private const val CHANNEL = "com.flutter.common/face"
        private const val METHOD_FACE_INIT = "faceInit"
        private const val METHOD_FACE_START = "web3ViewStart"
    }


    init {

    }

    /**
     * 初始化SDK
     */
    private fun initLib(context:Context) {
    }

    /**
     * 设置人脸识别
     */
    private fun setFaceConfig() {
    }


    private lateinit var channel: MethodChannel
    //Flutter端回调
    private lateinit var methodCall : MethodCall
    private lateinit var result : MethodChannel.Result

    //注册方法
    fun web3Init(@NonNull flutterEngine: FlutterEngine, context: Context){
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
            this.methodCall = methodCall
            this.result = result
            if (methodCall.method == METHOD_FACE_INIT) {
                initLib(context)
            } else if (methodCall.method == METHOD_FACE_START){
                var intent = Intent(context,Web3ViewActivity::class.java)
                intent.putExtra("chainId",methodCall.argument<String>("chainId"))
                intent.putExtra("rpcServerUrl",methodCall.argument<String>("rpcServerUrl"))
                intent.putExtra("walletAddress",methodCall.argument<String>("walletAddress"))
                intent.putExtra("url",methodCall.argument<String>("url"))
                context.startActivity(intent)
            } else {
                result.notImplemented()
            }
        }
    }


}