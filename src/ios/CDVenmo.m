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
  NSLog(@"send");

  NSString *recipients = [command.arguments objectAtIndex:2];
  unsigned long amnt = [command.arguments objectAtIndex:3];
  NSString *noteToSend = [command.arguments objectAtIndex:4];

  [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAppSwitch];
  
  [[Venmo sharedInstance] sendPaymentTo:recipients
                                 amount:amnt // this is in cents!
                                 note:noteToSend
      completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
          if (success) {
            NSLog(@"Transaction succeeded!");
            NSLog([NSString stringWithFormat:@"amount: %lu", (unsigned long)[[transaction target] amount]] );
              
            unsigned long amount = [[transaction target] amount];
            NSString *note = [transaction note];
            NSString *code = [transaction transactionID];
            NSString *json = [NSString stringWithFormat:@"{amount:%lu,note:%@,code:%@}",amount,note,code];

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:json];

            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
          } else {
            NSLog(@"Transaction failed with error: %@", [error localizedDescription]);

            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"{msg: erroraya}"];

            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
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
