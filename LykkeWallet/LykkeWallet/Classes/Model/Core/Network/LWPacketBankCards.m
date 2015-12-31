//
//  LWPacketBankCards.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 31.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacketBankCards.h"


@implementation LWPacketBankCards


#pragma mark - LWPacket

- (void)parseResponse:(id)response error:(NSError *)error {
    [super parseResponse:response error:error];
    
    if (self.isRejected) {
        return;
    }
    
    //_data = [[LWLykkeWalletsData alloc] initWithJSON:result];
}

- (NSString *)urlRelative {
    return @"BankCards";
}

@end
