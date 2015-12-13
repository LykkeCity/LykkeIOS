//
//  LWPacketKYCStatusSet.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 13.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacketKYCStatusSet.h"


@implementation LWPacketKYCStatusSet


#pragma mark - LWPacket

- (NSString *)urlRelative {
    return @"KycStatus";
}

- (NSDictionary *)headers {
    if (self.authCookie) {
        return @{@"Cookie" : self.authCookie};
    }
    return [super headers];
}

@end
