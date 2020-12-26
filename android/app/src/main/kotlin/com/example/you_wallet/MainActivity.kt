package com.example.you_wallet

import androidx.annotation.NonNull;
import com.flutter.common.channel.Web3ViewUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        flutterEngine.platformViewsController.registry.registerViewFactory("web3view",Web3ViewFactory())
        Web3ViewUtils().web3Init(flutterEngine,this)
    }
}
