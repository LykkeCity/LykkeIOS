//
//  LWTransactionMarketOrderModel.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 10.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAssetPurchaseModel.h"


@interface LWTransactionMarketOrderModel : LWAssetPurchaseModel {
    
}

@property (readonly, nonatomic) NSString *dateTime;

@end
