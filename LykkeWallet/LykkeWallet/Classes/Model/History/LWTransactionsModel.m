//
//  LWTransactionsModel.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 10.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWTransactionsModel.h"
#import "LWTransactionMarketOrderModel.h"
#import "LWTransactionCashInOutModel.h"
#import "LWTransactionTradeModel.h"


@implementation LWTransactionsModel


#pragma mark - LWJSONObject

- (instancetype)initWithJSON:(id)json {
    self = [super initWithJSON:json];
    if (self) {
#warning TODO: remove after review IPHONELW-91
        // market orders
        //NSMutableArray *market = [NSMutableArray new];
        //for (NSDictionary *item in json[@"MarketOrders"]) {
        //    [market addObject:[[LWTransactionMarketOrderModel alloc] initWithJSON:item]];
        //}
        //_marketOrders = market;
        
        
        // trades
        NSMutableArray *trades = [NSMutableArray new];
        for (NSDictionary *item in json[@"Trades"]) {
            [trades addObject:[[LWTransactionTradeModel alloc] initWithJSON:item]];
        }
        _trades = trades;
        
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
