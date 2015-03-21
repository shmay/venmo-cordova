#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CDVClipboard : CDVPlugin {}

- (void)send:(CDVInvokedUrlCommand*)command;

@end
