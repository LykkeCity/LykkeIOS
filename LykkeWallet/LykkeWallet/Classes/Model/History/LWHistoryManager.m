//
//  LWHistoryManager.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 10.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWHistoryManager.h"
#import "LWTransactionsModel.h"
#import "LWTransactionMarketOrderModel.h"
#import "LWTransactionCashInOutModel.h"
#import "LWMarketHistoryItemType.h"
#import "LWCashInOutHistoryItemType.h"

@implementation LWHistoryManager

// nsdictionary:
// key - date time of operation(s)
// value - set of operations for the selected date time
+ (NSDictionary *)convertNetworkModel:(LWTransactionsModel *)model {
    NSMutableDictionary *result = [NSMutableDictionary new];
    
    // mapping market operations
    if (model && model.marketOrders) {
        for (LWTransactionMarketOrderModel *marketOperation in model.marketOrders) {
            if (![result objectForKey:marketOperation.dateTime]) {
                result[marketOperation.dateTime] = [NSMutableSet new];
            }
            LWMarketHistoryItemType *item = [LWMarketHistoryItemType convertFromNetworkModel:marketOperation];
            [result[marketOperation.dateTime] addObject:item];
        }
    }
    
    // mapping cash in/out operations
    if (model && model.cashInOut) {
        for (LWTransactionCashInOutModel *cashInOutOperations in model.cashInOut) {
            if (![result objectForKey:cashInOutOperations.dateTime]) {
                result[cashInOutOperations.dateTime] = [NSMutableSet new];
            }
            LWCashInOutHistoryItemType *item = [LWCashInOutHistoryItemType convertFromNetworkModel:cashInOutOperations];
            [result[cashInOutOperations.dateTime] addObject:item];
        }
    }
    
    // sorting
#warning TODO: sorting
    
    return result;
}

@end
