//
//  LWPacketGraphRates.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 08.05.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWPacketGraphRates.h"


@implementation LWPacketGraphRates


#pragma mark - LWPacket

- (void)parseResponse:(id)response error:(NSError *)error {
    [super parseResponse:response error:error];
    
    if (self.isRejected) {
        return;
    }
}

- (NSString *)urlRelative {
    NSString *url = [NSString stringWithFormat:@"GraphPeriods"];
    return url;
}

- (GDXRESTPacketType)type {
    return GDXRESTPacketTypeGET;
}

@end
