//
//  LWTradeHistoryItemType.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 26.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWTradeHistoryItemType.h"
#import "LWTransactionTradeModel.h"


@implementation LWTradeHistoryItemType

+ (LWTradeHistoryItemType *)convertFromNetworkModel:(LWTransactionTradeModel *)model {
    LWTradeHistoryItemType *result = [LWTradeHistoryItemType new];
    result.dateTime    = model.dateTime;
    result.identity    = model.identity;
    result.volume      = model.volume;
    result.asset       = model.asset;
    result.historyType = LWHistoryItemTypeTrade;
    
    return result;
}

@end
