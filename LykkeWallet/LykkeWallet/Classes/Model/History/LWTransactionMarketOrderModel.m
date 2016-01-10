//
//  LWTransactionMarketOrderModel.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 10.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWTransactionMarketOrderModel.h"
#import "NSString+Date.h"


@implementation LWTransactionMarketOrderModel


#pragma mark - LWJSONObject

- (instancetype)initWithJSON:(id)json {
    self = [super initWithJSON:json];
    if (self) {
        NSString *date = [json objectForKey:@"DateTime"];
        _dateTime = [date toDate];
    }
    return self;
}

@end
