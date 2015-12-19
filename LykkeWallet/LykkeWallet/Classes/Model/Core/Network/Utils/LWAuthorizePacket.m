//
//  LWAuthorizePacket.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 14.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthorizePacket.h"
#import "LWKeychainManager.h"


@implementation LWAuthorizePacket


#pragma mark - LWPacket

- (NSDictionary *)headers {
    NSString *token = [LWKeychainManager readToken];
    if (token && ![token isEqualToString:@""]) {
        return @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", token]};
    }
    return [super headers];
}

@end
