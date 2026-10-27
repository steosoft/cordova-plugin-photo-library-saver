#import <Cordova/CDV.h>
#import <Photos/Photos.h>

@interface PhotoLibraryPlugin : CDVPlugin

- (void)isAuthorized:(CDVInvokedUrlCommand*)command;
- (void)requestAuthorization:(CDVInvokedUrlCommand*)command;
- (void)saveImage:(CDVInvokedUrlCommand*)command;
- (void)saveVideo:(CDVInvokedUrlCommand*)command;

@end
