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
    if (self.orderId && ![self.orderId isEqualToString:@""]) {
        return [NSString stringWithFormat:@"BlockchainTransaction?orderId=%@", self.orderId];
    }
    else if (self.cashOperationId && ![self.cashOperationId isEqualToString:@""]) {
        return [NSString stringWithFormat:@"BlockchainTransaction?cashOperationId=%@", self.cashOperationId];
    }
    else if (self.exchangeOperationId && ![self.exchangeOperationId isEqualToString:@""]) {
        return [NSString stringWithFormat:@"BlockchainTransaction?exchangeOperationId=%@", self.exchangeOperationId];
    }
    return @"BlockchainTransaction";
}

- (GDXRESTPacketType)type {
    return GDXRESTPacketTypeGET;
}

@end
