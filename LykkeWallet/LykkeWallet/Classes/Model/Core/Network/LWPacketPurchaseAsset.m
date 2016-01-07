//
//  LWPacketPurchaseAsset.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 07.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWPacketPurchaseAsset.h"


@implementation LWPacketPurchaseAsset


#pragma mark - LWPacket

- (void)parseResponse:(id)response error:(NSError *)error {
    [super parseResponse:response error:error];
    
    if (self.isRejected) {
        return;
    }
    _orderId = result[@"OrderId"];
}

- (NSString *)urlRelative {
    return @"PurchaseAsset";
}

- (NSDictionary *)params {
    return @{@"BaseAsset" : self.baseAsset,
             @"AssetPair" : self.assetPair,
             @"Volume"    : self.volume,
             @"Rate"      : self.rate};
}

@end
