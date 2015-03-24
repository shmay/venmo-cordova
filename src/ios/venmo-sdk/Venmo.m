#import "Venmo.h"

#import "NSBundle+VenmoSDK.h"
#import <CMDQueryStringSerialization/CMDQueryStringSerialization.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
#import "UIDevice+IdentifierAddition.h"
#endif

static Venmo *sharedInstance = nil;

@interface Venmo ()

@property (copy, nonatomic, readwrite) NSString *appId;
@property (copy, nonatomic, readwrite) NSString *appSecret;
@property (copy, nonatomic, readwrite) NSString *appName;

@property (copy, nonatomic, readwrite) VENTransactionCompletionHandler transactionCompletionHandler;
@property (copy, nonatomic, readwrite) VENOAuthCompletionHandler OAuthCompletionHandler;

@end

@implementation Venmo

#pragma mark - Initializers

+ (BOOL)startWithAppId:(NSString *)appId
                secret:(NSString *)appSecret
                  name:(NSString *)appName {
    if (!sharedInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[self alloc] initWithAppId:appId secret:appSecret name:appName];
        });
    }
    VENSession *cachedSession = [VENSession cachedSessionWithAppId:appId];

    // If we find a cached session that hasn't expired, set the current session.
    NSDate *now = [NSDate date];
    if (cachedSession &&
        [[cachedSession.expirationDate earlierDate:now] isEqualToDate:now]) {
        sharedInstance.session = cachedSession;
        return YES;
    }
    return NO;
}


- (instancetype)initWithAppId:(NSString *)appId
                       secret:(NSString *)appSecret
                         name:(NSString *)appName {
    self = [super init];
    if (self) {
        self.appId = appId;
        self.appSecret = appSecret;
        self.appName = appName ?: [[NSBundle mainBundle] name];
        self.session = [[VENSession alloc] init];
        self.defaultTransactionMethod = VENTransactionMethodAppSwitch;
    }
    return self;
}


+ (instancetype)sharedInstance {
    return sharedInstance;
}


+ (BOOL)isVenmoAppInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"venmo://"]];
}


#pragma mark - Sending a Transaction

- (void)sendAppSwitchTransactionTo:(NSString *)recipientHandle
                   transactionType:(VENTransactionType)type
                            amount:(NSUInteger)amount
                              note:(NSString *)note
                 completionHandler:(VENTransactionCompletionHandler)completionHandler {
    self.transactionCompletionHandler = completionHandler;
    NSString *URLPath = [self URLPathWithType:type amount:amount note:note recipient:recipientHandle];
    NSURL *transactionURL = [NSURL venmoAppURLWithPath:URLPath];
    DLog(@"transactionURL: %@", transactionURL);

    if ([Venmo isVenmoAppInstalled]) {
        [[UIApplication sharedApplication] openURL:transactionURL];
    } else if (completionHandler) {
        NSError *error = [NSError errorWithDomain:VenmoSDKDomain
                                             code:VENSDKErrorTransactionFailed
                                      description:@"Could not find Venmo app."
                               recoverySuggestion:@"Please install Venmo."];
        completionHandler(nil, NO, error);
    }   
}


- (NSString *)currentDeviceIdentifier {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        return [[UIDevice currentDevice] uniqueDeviceIdentifier];
    }
#else
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
#endif
}

@end
