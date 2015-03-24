#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface CDVenmo : CDVPlugin {}

- (void)send:(CDVInvokedUrlCommand*)command;
- (void)pluginInitialize;
- (void)handleOpenURL:(NSNotification*)notification;

@end
