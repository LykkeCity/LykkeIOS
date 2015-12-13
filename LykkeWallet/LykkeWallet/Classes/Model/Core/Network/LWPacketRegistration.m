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

- (NSDictionary *)params {
    return @{@"Email" : self.registrationData.email,
             @"FirstName" : self.registrationData.firstName,
             @"LastName" : self.registrationData.lastName,
             @"ContactPhone" : self.registrationData.phone,
             @"Password" : self.registrationData.password};
}

@end
