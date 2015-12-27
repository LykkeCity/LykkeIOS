//
//  LWBankCardsData.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 27.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWBankCardsData.h"


@implementation LWBankCardsData {
    
}


#pragma mark - LWJSONObject

- (instancetype)initWithJSON:(id)json {
    self = [super initWithJSON:json];
    if (self) {
        _identity   = [json objectForKey:@"Id"];
        _type       = [json objectForKey:@"Type"];
        _lastDigits = [json objectForKey:@"LastDigits"];
    }
    return self;
}

@end
