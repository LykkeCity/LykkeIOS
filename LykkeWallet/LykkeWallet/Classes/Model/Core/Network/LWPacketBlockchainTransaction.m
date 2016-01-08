//
//  LWPacketBlockchainTransaction.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 08.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWPacketBlockchainTransaction.h"
#import "LWAssetBlockchainModel.h"


@implementation LWPacketBlockchainTransaction


#pragma mark - LWPacket

- (void)parseResponse:(id)response error:(NSError *)error {
    [super parseResponse:response error:error];
    
    if (self.isRejected) {
        return;
    }
    _blockchain = [[LWAssetBlockchainModel alloc] initWithJSON:result[@"Transaction"]];
}

- (NSString *)urlRelative {
    return [NSString stringWithFormat:@"BlockchainTransaction?orderId=%@", self.orderId];
}

- (GDXRESTPacketType)type {
    return GDXRESTPacketTypeGET;
}

@end
