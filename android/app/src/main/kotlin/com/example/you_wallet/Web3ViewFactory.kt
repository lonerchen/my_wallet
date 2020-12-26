package com.example.you_wallet

import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.*

class Web3ViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE){
    
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return Web3ViewPage(context!!,viewId,args as Map<String, Objects>)
    }


}