//
//  LWPacketAuthentication.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacketAuthentication.h"
#import "LWKeychainManager.h"


@implementation LWPacketAuthentication


#pragma mark - LWPacket

- (void)parseResponse:(id)response error:(NSError *)error {
    [super parseResponse:response error:error];
    
    if (self.isRejected) {
        return;
    }
    _token = result[@"Token"];
    _status = result[@"KycStatus"];
    _isPinEntered = [result[@"PinIsEntered"] boolValue];
    
    [[LWKeychainManager instance] saveLogin:self.authenticationData.email token:_token];
}

- (NSString *)urlRelative {
    return @"Auth";
}

- (NSDictionary *)params {
    return @{@"Email" : self.authenticationData.email,
             @"Password" : self.authenticationData.password};
}

@end
