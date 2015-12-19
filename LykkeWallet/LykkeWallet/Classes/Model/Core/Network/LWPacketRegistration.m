//
//  LWPacketRegistration.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 11.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacketRegistration.h"
#import "LWKeychainManager.h"


@implementation LWPacketRegistration


#pragma mark - LWPacket

- (void)parseResponse:(id)response error:(NSError *)error {
    [super parseResponse:response error:error];
    
    if (self.isRejected) {
        return;
    }
    _token = result[@"Token"];
    
    [LWKeychainManager saveLogin:self.registrationData.email andToken:_token];
}

- (NSString *)urlRelative {
    return @"Registration";
}

- (NSDictionary *)params {
    return @{@"Email" : self.registrationData.email,
             @"FirstName" : self.registrationData.firstName,
             @"LastName" : self.registrationData.lastName,
             @"ContactPhone" : self.registrationData.phone,
             @"Password" : self.registrationData.password};
}

@end
