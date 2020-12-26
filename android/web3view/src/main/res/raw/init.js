

(function() {
    var config = {
        address: "%s",
         rpcUrl: "%s",
        chainId: "%s"

    };
    const provider = new window.Trust(config);
    window.ethereum = provider;
    provider.setMaxListeners(1000);
    provider.postMessage = function(handler, id, data) {
      switch (handler) {
        case 'signTransaction':
          var gasLimit = data.gasLimit || data.gas || null;
          var gasPrice = data.gasPrice || null;
          var nonce = data.nonce || -1;
          return trust.signTransaction(id, data.to || null, data.value, nonce, gasLimit, gasPrice, data.data || null);
        case 'signMessage':
          return trust.signMessage(id, data.data);
        case 'signPersonalMessage':
          return trust.signPersonalMessage(id, data.data);
        case 'signTypedMessage':
        case 'eth_signTypedData_v3':
          return trust.signTypedMessage(id, JSON.stringify(data.data));
        case 'requestAccounts':
        case 'eth_requestAccounts':
          return trust.requestAccounts(id, "{}");
      }
    };
    window.web3 = new window.Web3(provider);
    window.web3.eth.defaultAccount = config.address;
    window.chrome = {webstore: {}};
})();



(function() {
    var promises = {}

    function generateUUID(){
        var time = new Date().getTime();
        var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g,
            function(c) {
                var r = (time + Math.random() * 16) %% 16 | 0;
                time = Math.floor(time / 16);
                return (c == 'x' ? r : (r&0x3|0x8)).toString(16);
            }
        );
        return uuid;
    }

    // Function called by the native code to resolve the promise
    window.resolvePromise = function(promiseId, data, error, parse) {
        if (error){
            promises[promiseId].reject(error);
        } else{
            promises[promiseId].resolve(parse ? JSON.parse(data) : data);
        }
        delete promises[promiseId];
    }

    // Create and return a new promise to be resolved by the native code
    window.createPromise = function(block) {
        return new Promise(function(resolve, reject) {
            var promiseId = generateUUID();
            promises[promiseId] = { resolve, reject };

            try {
                block(promiseId);
            }
            catch(error) {
                window.resolvePromise(promiseId, null, error);
            }
        });
    }
})();


(function() {
    window.trustProvider = window.trustProvider || {};

    window.trustProvider.signTransaction = function({ network, transaction }) {
        return window.createPromise(function(promiseId) {
            window.trust_provider.signTransaction(
                promiseId,
                network,
                JSON.stringify(transaction),
            );
        });
    };

    window.trustProvider.getAccounts = function() {
        return window.createPromise(function(promiseId) {
            window.trust_provider.getAccounts(promiseId);
        });
    };
})();
