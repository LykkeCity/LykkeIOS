//
//  LWBankCardsData.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 27.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWJSONObject.h"


@interface LWBankCardsData : LWJSONObject {
    
}

@property (readonly, nonatomic) NSString *identity;
@property (readonly, nonatomic) NSString *type;
@property (readonly, nonatomic) NSString *lastDigits;

@end
