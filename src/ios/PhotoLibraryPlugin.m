#import "PhotoLibraryPlugin.h"

@implementation PhotoLibraryPlugin

- (void)isAuthorized:(CDVInvokedUrlCommand*)command {
    PHAuthorizationStatus status;
    if (@available(iOS 14, *)) {
        status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    } else {
        status = [PHPhotoLibrary authorizationStatus];
    }

    BOOL authorized = (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited);
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:authorized];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)requestAuthorization:(CDVInvokedUrlCommand*)command {
    void (^handler)(PHAuthorizationStatus) = ^(PHAuthorizationStatus status) {
        BOOL authorized = (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited);
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:authorized];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    };

    if (@available(iOS 14, *)) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite handler:handler];
    } else {
        [PHPhotoLibrary requestAuthorization:handler];
    }
}

- (void)saveImage:(CDVInvokedUrlCommand*)command {
    NSString* filePath = [command.arguments objectAtIndex:0];
    NSString* albumName = [command.arguments objectAtIndex:1];

    NSURL* fileURL = [NSURL URLWithString:filePath];
    if (!fileURL.isFileURL) {
        fileURL = [NSURL fileURLWithPath:filePath];
    }

    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCreationRequest* creationRequest = [PHAssetCreationRequest creationRequestForAssetFromImageAtFileURL:fileURL];
        PHObjectPlaceholder* placeholder = [creationRequest placeholderForCreatedAsset];

        if (albumName && placeholder) {
            PHAssetCollection* album = [self fetchAssetCollectionWithTitle:albumName];
            PHAssetCollectionChangeRequest* albumChangeRequest;
            if (album) {
                albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
            } else {
                albumChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
            }
            [albumChangeRequest addAssets:@[placeholder]];
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        CDVPluginResult* result;
        if (success) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)saveVideo:(CDVInvokedUrlCommand*)command {
    NSString* filePath = [command.arguments objectAtIndex:0];
    NSString* albumName = [command.arguments objectAtIndex:1];

    NSURL* fileURL = [NSURL URLWithString:filePath];
    if (!fileURL.isFileURL) {
        fileURL = [NSURL fileURLWithPath:filePath];
    }

    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest* creationRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileURL];
        PHObjectPlaceholder* placeholder = [creationRequest placeholderForCreatedAsset];

        if (albumName && placeholder) {
            PHAssetCollection* album = [self fetchAssetCollectionWithTitle:albumName];
            PHAssetCollectionChangeRequest* albumChangeRequest;
            if (album) {
                albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
            } else {
                albumChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
            }
            [albumChangeRequest addAssets:@[placeholder]];
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        CDVPluginResult* result;
        if (success) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
        }
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (PHAssetCollection*)fetchAssetCollectionWithTitle:(NSString*)title {
    PHFetchOptions* fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    PHFetchResult* collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:fetchOptions];
    return [collections firstObject];
}

@end
