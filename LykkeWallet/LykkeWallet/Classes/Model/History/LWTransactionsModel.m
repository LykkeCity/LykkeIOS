//
//  LWTransactionsModel.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 10.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWTransactionsModel.h"
#import "LWAssetPurchaseModel.h"
#import "LWTransactionCashInOutModel.h"


@implementation LWTransactionsModel


#pragma mark - LWJSONObject

- (instancetype)initWithJSON:(id)json {
    self = [super initWithJSON:json];
    if (self) {
        // market orders
        NSMutableArray *market = [NSMutableArray new];
        for (NSDictionary *item in json[@"MarketOrders"]) {
            [market addObject:[[LWAssetPurchaseModel alloc] initWithJSON:item]];
        }
        _marketOrders = market;
        
        // cash in / out
        NSMutableArray *cash = [NSMutableArray new];
        for (NSDictionary *item in json[@"CashInOut"]) {
            [cash addObject:[[LWTransactionCashInOutModel alloc] initWithJSON:item]];
        }
        _cashInOut = cash;
    }
    return self;
}

@end
