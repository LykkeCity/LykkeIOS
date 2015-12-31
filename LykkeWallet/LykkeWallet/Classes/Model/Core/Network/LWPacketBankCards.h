//
//  LWPacketBankCards.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 31.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWPacketAuthentication.h"


@class LWBankCardsAdd;


@interface LWPacketBankCards : LWPacketAuthentication {
    
}
// in
@property (copy, nonatomic) LWBankCardsAdd *addCardData;

@end
