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
