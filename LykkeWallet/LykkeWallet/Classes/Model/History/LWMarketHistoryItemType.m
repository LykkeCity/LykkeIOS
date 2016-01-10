//
//  LWMarketHistoryItemType.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 10.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWMarketHistoryItemType.h"
#import "LWTransactionMarketOrderModel.h"


@implementation LWMarketHistoryItemType


+ (LWMarketHistoryItemType *)convertFromNetworkModel:(LWTransactionMarketOrderModel *)model {
    LWMarketHistoryItemType *result = [LWMarketHistoryItemType new];
    result.dateTime     = model.dateTime;
    result.identity     = model.identity;
    result.orderType    = model.orderType;
    result.volume       = model.volume;
    result.price        = model.price;
    result.baseAsset    = model.baseAsset;
    result.assetPair    = model.assetPair;
    result.blockchainId = model.blockchainId;
    result.blockchainSettled = model.blockchainSettled;
    result.totalCost    = model.totalCost;
    result.commission   = model.commission;
    result.position     = model.position;
    result.historyType  = LWHistoryItemTypeMarket;
    
    return result;
}

@end
