var exec = require('cordova/exec');

var photoLibrary = {
    isAuthorized: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "PhotoLibraryPlugin", "isAuthorized", []);
    },
    
    requestAuthorization: function(successCallback, errorCallback) {
        exec(successCallback, errorCallback, "PhotoLibraryPlugin", "requestAuthorization", []);
    },
    
    saveImage: function(url, album, successCallback, errorCallback) {
        exec(successCallback, errorCallback, "PhotoLibraryPlugin", "saveImage", [url, album]);
    },
    
    saveVideo: function(url, album, successCallback, errorCallback) {
        exec(successCallback, errorCallback, "PhotoLibraryPlugin", "saveVideo", [url, album]);
    }
};

module.exports = photoLibrary;
