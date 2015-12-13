//
//  LWCookiePacket.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 14.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWCookiePacket.h"


@implementation LWCookiePacket


#pragma mark - LWPacket

- (NSDictionary *)headers {
    if (self.authCookie) {
        return @{@"Cookie" : self.authCookie};
    }
    return [super headers];
}

@end
