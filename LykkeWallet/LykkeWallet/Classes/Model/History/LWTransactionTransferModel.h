//
//  LWTransactionTransferModel.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 12.04.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWJSONObject.h"


@interface LWTransactionTransferModel : LWJSONObject {
    
}

@property (readonly, nonatomic) NSString *identity;
@property (readonly, nonatomic) NSNumber *volume;
@property (readonly, nonatomic) NSDate   *dateTime;
@property (readonly, nonatomic) NSString *asset;
@property (readonly, nonatomic) NSString *iconId;
@property (readonly, nonatomic) NSString *blockchainHash;

@end
