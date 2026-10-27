# Cordova Plugin Photo Library Saver (iOS Only)

A lightweight, modern Cordova plugin for iOS designed to replace legacy plugins relying on the deprecated and removed `ALAssetsLibrary` framework. This plugin uses the native Apple **Photos** framework (`PHPhotoLibrary`) to handle permissions and save JPEG images and MP4 videos directly into a custom photo album (e.g., `'Tourlider'`).

## Features

* **iOS Only:** Focused strictly on modern iOS architecture.
* **Modern API:** Fully leverages `PHPhotoLibrary`, `PHAssetCreationRequest`, and `PHAssetChangeRequest`.
* **Automatic Album Creation:** Automatically checks for or creates the specified target album (e.g., `'Tourlider'`) in the user's photo library.
* **Minimal Footprint:** Includes only essential methods for checking authorization, requesting access, saving images, and saving videos.

---

## Supported Methods

1. `cordova.plugins.photoLibrary.isAuthorized(successCallback, errorCallback)`
2. `cordova.plugins.photoLibrary.requestAuthorization(successCallback, errorCallback)`
3. `cordova.plugins.photoLibrary.saveImage(filePath, albumName, successCallback, errorCallback)`
4. `cordova.plugins.photoLibrary.saveVideo(filePath, albumName, successCallback, errorCallback)`

---

## Installation

To install the plugin locally into your Cordova project:

```bash
cordova plugin add https://github.com/steosoft/cordova-plugin-photo-library-saver
```

## Usage Example

### 1. Check and Request Authorization
Before attempting to save media, ensure you have permission from the user:

```
cordova.plugins.photoLibrary.isAuthorized(
    function(authorized) {
        if (authorized) {
            console.log("Permission granted!");
        } else {
            requestAuth();
        }
    },
    function(err) {
        console.error("Error checking authorization: ", err);
    }
);

function requestAuth() {
    cordova.plugins.photoLibrary.requestAuthorization(
        function(authorized) {
            if (authorized) {
                console.log("Authorization granted by user.");
            } else {
                console.log("Authorization denied.");
            }
        },
        function(err) {
            console.error("Error requesting authorization: ", err);
        }
    );
}
```

### 2. Save an Image (JPG)

```
var imagePath = media.nativePath; // e.g. file:///... or local file path
var albumName = 'Tourlider';

cordova.plugins.photoLibrary.saveImage(
    imagePath,
    albumName,
    function() {
        console.log("Image saved successfully to album!");
    },
    function(err) {
        console.error("Failed to save image: ", err);
    }
);
```

### 3. Save a Video (MP4)

```
var videoPath = media.nativePath; // e.g. file:///... or local file path
var albumName = 'Tourlider';

cordova.plugins.photoLibrary.saveVideo(
    videoPath,
    albumName,
    function() {
        console.log("Video saved successfully to album!");
    },
    function(err) {
        console.error("Failed to save video: ", err);
    }
);
```

## iOS Permissions (Info.plist)

The plugin automatically injects the required privacy descriptions into your app's Info.plist:

NSPhotoLibraryUsageDescription — Used to request access to the photo library.

NSPhotoLibraryAddUsageDescription — Used to request permission to add assets to the photo library.

## License

MIT