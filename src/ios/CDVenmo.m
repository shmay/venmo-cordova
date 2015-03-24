#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import "Venmo.h"
#import "CDVenmo.h"

@implementation CDVenmo

- (void)pluginInitialize {
  NSLog(@"pluginInitialize");
  [Venmo startWithAppId:@"2456" secret:@"qzXgnaB4XbJQx3y8vQtB76PTGSKqbPUp" name:@"HSliceDemo"];

}

- (void)send:(CDVInvokedUrlCommand*)command {
  NSLog(@"OMG");

  [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
  
  [[Venmo sharedInstance] sendPaymentTo:@"Drew"
                                 amount:1 // this is in cents!
                                   note:@"note mfer"
                      completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                          if (success) {
                              NSLog(@"Transaction succeeded!");
                              NSLog([NSString stringWithFormat:@"%@", [transaction description]]);
                          }
                          else {
                              NSLog(@"Transaction failed with error: %@", [error localizedDescription]);

                          }
                      }];
}

- (void)handleOpenURL:(NSNotification*)notification
{
    // override to handle urls sent to your app
    // register your url schemes in your App-Info.plist
    
    NSLog(@"handleOpenURL");
    NSURL* url = [notification object];
    
    [[Venmo sharedInstance] handleOpenURL:url];

}

@end
