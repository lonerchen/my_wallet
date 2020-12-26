package trust.web3;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.Log;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import org.jetbrains.annotations.Nullable;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;

import trust.core.entity.Address;
import trust.core.entity.Message;
import trust.core.entity.SignedMessage;
import trust.core.entity.Transaction;
import trust.core.entity.TypedData;




public class Web3View extends WebView {
    private static final String TAG = "Web3View";
    private static final String JS_PROTOCOL_CANCELLED = "cancelled";
    private static final String JS_PROTOCOL_ON_SUCCESSFUL = "onSignSuccessful(%1$s, \"%2$s\")";
    private static final String JS_PROTOCOL_ON_FAILURE = "onSignError(%1$s, \"%2$s\")";
    @Nullable
    private OnSignTransactionListener onSignTransactionListener;
    @Nullable
    private OnSignMessageListener onSignMessageListener;
    @Nullable
    private OnSignPersonalMessageListener onSignPersonalMessageListener;
    @Nullable
    private OnSignTypedMessageListener onSignTypedMessageListener;

    private OnGetAccountListener mOnGetAccountListener;
    private JsInjectorClient jsInjectorClient;
    private Web3ViewClient webViewClient;

    public Address getAddress() {
        return jsInjectorClient.getWalletAddress();
    }


    public Web3View(@NonNull Context context) {
        this(context, null);
    }

    public Web3View(@NonNull Context context, @Nullable AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public Web3View(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        init();
    }

    @Override
    public void setWebChromeClient(WebChromeClient client) {
        super.setWebChromeClient(client);
    }

    @Override
    public void setWebViewClient(WebViewClient client) {
        super.setWebViewClient(new WrapWebViewClient(webViewClient, client, jsInjectorClient));
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void init() {
        jsInjectorClient = new JsInjectorClient(getContext());
        webViewClient = new Web3ViewClient(jsInjectorClient, new UrlHandlerManager());
        WebSettings webSettings = super.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setCacheMode(WebSettings.LOAD_DEFAULT);
        webSettings.setBuiltInZoomControls(true);
        webSettings.setDisplayZoomControls(false);
        webSettings.setUseWideViewPort(true);
        webSettings.setLoadWithOverviewMode(true);
        webSettings.setDomStorageEnabled(true);
        addJavascriptInterface(new SignCallbackJSInterface(
                this,
                innerOnSignTransactionListener,
                innerOnSignMessageListener,
                innerOnSignPersonalMessageListener,
                innerOnSignTypedMessageListener, innerOnGetAccountListener), "trust");

        super.setWebViewClient(webViewClient);

    }

    @Override
    public WebSettings getSettings() {
        return new WrapWebSettings(super.getSettings());
    }


    public void setWalletAddress(@NonNull Address address) {
        jsInjectorClient.setWalletAddress(address);
    }

    @Nullable
    public Address getWalletAddress() {
        return jsInjectorClient.getWalletAddress();
    }

    public void setChainId(int chainId) {
        jsInjectorClient.setChainId(chainId);
    }

    public int getChainId() {
        return jsInjectorClient.getChainId();
    }

    public void setRpcUrl(@NonNull String rpcUrl) {
        jsInjectorClient.setRpcUrl(rpcUrl);
    }

    @Nullable
    public String getRpcUrl() {
        return jsInjectorClient.getRpcUrl();
    }

    public void addUrlHandler(@NonNull UrlHandler urlHandler) {
        webViewClient.addUrlHandler(urlHandler);
    }

    public void removeUrlHandler(@NonNull UrlHandler urlHandler) {
        webViewClient.removeUrlHandler(urlHandler);
    }

    public void setOnSignTransactionListener(@Nullable OnSignTransactionListener onSignTransactionListener) {
        this.onSignTransactionListener = onSignTransactionListener;
    }

    public void setOnSignMessageListener(@Nullable OnSignMessageListener onSignMessageListener) {
        this.onSignMessageListener = onSignMessageListener;
    }

    public void setOnSignPersonalMessageListener(@Nullable OnSignPersonalMessageListener onSignPersonalMessageListener) {
        this.onSignPersonalMessageListener = onSignPersonalMessageListener;
    }

    public void setOnSignTypedMessageListener(@Nullable OnSignTypedMessageListener onSignTypedMessageListener) {
        this.onSignTypedMessageListener = onSignTypedMessageListener;
    }

    public void setOnGetAccountListener(OnGetAccountListener onGetAccountListener) {
        mOnGetAccountListener = onGetAccountListener;
    }
//    public void onSignTransactionSuccessful(Transaction transaction, String signHex) {
//        long callbackId = transaction.leafPosition;
//        callbackToJS(callbackId, JS_PROTOCOL_ON_SUCCESSFUL, signHex);
//    }
//
//    public void onSignMessageSuccessful(Message message, String signHex) {
//        long callbackId = message.leafPosition;
//        callbackToJS(callbackId, JS_PROTOCOL_ON_SUCCESSFUL, signHex);
//    }
//
//    public void onSignPersonalMessageSuccessful(Message message, String signHex) {
//        long callbackId = message.leafPosition;
//        callbackToJS(callbackId, JS_PROTOCOL_ON_SUCCESSFUL, signHex);
//    }
//
//    public void onSignError(Transaction transaction, String error) {
//        long callbackId = transaction.leafPosition;
//        callbackToJS(callbackId, JS_PROTOCOL_ON_FAILURE, error);
//    }
//
//    public void onSignError(Message message, String error) {
//        long callbackId = message.leafPosition;
//        callbackToJS(callbackId, JS_PROTOCOL_ON_FAILURE, error);
//    }
//
//    public void onSignCancel(Transaction transaction) {
//        long callbackId = transaction.leafPosition;
//        callbackToJS(callbackId, JS_PROTOCOL_ON_FAILURE, JS_PROTOCOL_CANCELLED);
//    }
//
//    public void onSignCancel(Message message) {
//        long callbackId = message.leafPosition;
//        callbackToJS(callbackId, JS_PROTOCOL_ON_FAILURE, JS_PROTOCOL_CANCELLED);
//    }
//
//    private void callbackToJS(long callbackId, String function, String param) {
//        String callback = String.format(function, callbackId, param);
////        post(() -> evaluateJavascript(callback, value -> Log.d("WEB_VIEW", value)));
//        post(new Runnable() {
//            @Override
//            public void run() {
//                evaluateJavascript(callback, value -> Log.d("WEB_VIEW", value));
//            }
//        });
//    }

    public final void onSignCancel(final Message<?> message) {
        if (message == null) {
            return;
        }
        this.onSignError(message, "cancelled");
    }

    public final void onSignError(@Nullable final String s) {

        this.callbackToJS(-1L, s, null);
    }

    public final void onSignError(final Message<?> message, @Nullable final String s) {
        if (message == null) {
            return;
        }
        this.callbackToJS(message.leafPosition, s, null);
    }

    public final void onSignMessageSuccessful(final SignedMessage<String> signedMessage) {
        if (signedMessage == null) {
            return;
        }
        this.callbackToJS(((Message) signedMessage).leafPosition, null, signedMessage.signHex);
    }

    public final void onSignPersonalMessageSuccessful(final SignedMessage<String> signedMessage) {
        if (signedMessage == null) {
            return;
        }
        this.callbackToJS(((Message) signedMessage).leafPosition, null, signedMessage.signHex);
    }

    public final void onSignSuccessful(final String s) {
        if (TextUtils.isEmpty(s)) {
            return;
        }
        this.callbackToJS(-1L, null, s);
    }

    public void callbackToJS(long paramLong, @Nullable  String function, @Nullable String param) {
        long l = paramLong;
        if (paramLong == -1L) {
            l = -1L;
        }
        int i;
        if ((function != null) && (function.length() != 0)) {
            i = 0;
        } else {
            i = 1;
        }
        if (i != 0) {
            function = String.format("window.ethereum.sendResponse(%1$s, '%2$s')", Arrays.copyOf(new Object[]{Long.valueOf(l), param}, 2));
        } else {
            function = String.format("window.ethereum.sendError(%1$s, '%2$s')", Arrays.copyOf(new Object[]{Long.valueOf(l), function}, 2));
        }
        String finalFunction = function;
        post(new Runnable() {
                @Override
                public final void run() {
                        evaluateJavascript(finalFunction, new ValueCallback<String>(){

                            @Override
                            public void onReceiveValue(String value) {
                                Log.d(TAG, "onReceiveValue: "+value);
                            }
                        });
                    }
                });
    }

    private final OnSignTransactionListener innerOnSignTransactionListener = new OnSignTransactionListener() {
        @Override
        public void onSignTransaction(Transaction transaction) {
            if (onSignTransactionListener != null) {
                onSignTransactionListener.onSignTransaction(transaction);
            }
        }
    };

    private final OnSignMessageListener innerOnSignMessageListener = new OnSignMessageListener() {
        @Override
        public void onSignMessage(Message message) {
            if (onSignMessageListener != null) {
                onSignMessageListener.onSignMessage(message);
            }
        }
    };

    private final OnSignPersonalMessageListener innerOnSignPersonalMessageListener = new OnSignPersonalMessageListener() {
        @Override
        public void onSignPersonalMessage(Message message) {
            onSignPersonalMessageListener.onSignPersonalMessage(message);
        }
    };

    private final OnSignTypedMessageListener innerOnSignTypedMessageListener = new OnSignTypedMessageListener() {
        @Override
        public void onSignTypedMessage(Message<TypedData[]> message) {
            onSignTypedMessageListener.onSignTypedMessage(message);
        }
    };


    private final OnGetAccountListener innerOnGetAccountListener = new OnGetAccountListener() {
        @Override
        public void getAccount(long paramLong, @Nullable String paramString) {
            mOnGetAccountListener.getAccount(paramLong, paramString);
        }
    };

    private class WrapWebViewClient extends WebViewClient {
        private final Web3ViewClient internalClient;
        private final WebViewClient externalClient;
        private final JsInjectorClient jsInjectorClient;

        public WrapWebViewClient(Web3ViewClient internalClient, WebViewClient externalClient, JsInjectorClient jsInjectorClient) {
            this.internalClient = internalClient;
            this.externalClient = externalClient;
            this.jsInjectorClient = jsInjectorClient;
        }

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            return externalClient.shouldOverrideUrlLoading(view, url)
                    || internalClient.shouldOverrideUrlLoading(view, url);
        }

        @RequiresApi(api = Build.VERSION_CODES.N)
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
            return externalClient.shouldOverrideUrlLoading(view, request)
                    || internalClient.shouldOverrideUrlLoading(view, request);
        }

        @Override
        public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
            WebResourceResponse response = externalClient.shouldInterceptRequest(view, request);
            if (response != null) {
                try {
                    InputStream in = response.getData();
                    int len = in.available();
                    byte[] data = new byte[len];
                    int readLen = in.read(data);
                    if (readLen == 0) {
                        throw new IOException("Nothing is read.");
                    }
                    String injectedHtml = jsInjectorClient.injectJS(new String(data));
                    response.setData(new ByteArrayInputStream(injectedHtml.getBytes()));
                } catch (IOException ex) {
                    Log.d("INJECT AFTER_EXTRNAL", "", ex);
                }
            } else {
                response = internalClient.shouldInterceptRequest(view, request);
            }
            return response;
        }
    }
}
