(function() {
    var promises = {}

    function generateUUID(){
        var time = new Date().getTime();
        var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g,
            function(c) {
                var r = (time + Math.random() * 16) % 16 | 0;
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
