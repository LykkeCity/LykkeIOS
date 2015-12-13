//
//  LWPacketRegistration.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 11.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacketRegistration.h"


@implementation LWPacketRegistration


#pragma mark - LWPacket

- (NSString *)urlRelative {
    return @"Registration";
}

- (NSDictionary *)headers {
    if (self.authCookie) {
        return @{@"Cookie" : self.authCookie};
    }
    return [super headers];
}

- (NSDictionary *)params {
    return @{@"email" : self.registrationData.email,
             @"firstname" : self.registrationData.firstName,
             @"lastname" : self.registrationData.lastName,
             @"contactphone" : self.registrationData.phone,
             @"password" : self.registrationData.password};
}

@end
