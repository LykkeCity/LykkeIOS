//
//  LWTransferHistoryItemType.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 12.04.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWBaseHistoryItemType.h"


@class LWTransactionTransferModel;


@interface LWTransferHistoryItemType : LWBaseHistoryItemType

@property (copy, nonatomic) NSNumber *volume;
@property (copy, nonatomic) NSString *iconId;

+ (LWTransferHistoryItemType *)convertFromNetworkModel:(LWTransactionTransferModel *)model;

@end
