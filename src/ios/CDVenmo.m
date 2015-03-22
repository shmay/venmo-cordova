#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import "Venmo.h"
#import "CDVenmo.h"

@implementation CDVenmo

- (void)send:(CDVInvokedUrlCommand*)command {
    [Venmo startWithAppId:@"2456" secret:@"qzXgnaB4XbJQx3y8vQtB76PTGSKqbPUp" name:@"HSliceDemo"];
}

@end
