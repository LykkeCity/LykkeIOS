//
//  LWAppSettingsModel.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAppSettingsModel.h"
#import "LWAssetModel.h"
#import "LWCache.h"


@implementation LWAppSettingsModel


#pragma mark - LWJSONObject

- (instancetype)initWithJSON:(id)json {
    self = [super initWithJSON:json];
    if (self) {
        _rateRefreshPeriod = [json objectForKey:@"RateRefreshPeriod"];
        _baseAsset         = [[LWAssetModel alloc] initWithJSON:json[@"BaseAsset"]];
        _shouldSignOrders  = [[json objectForKey:@"SignOrder"] boolValue];
        
        [LWCache instance].shouldSignOrder = _shouldSignOrders;
    }
    return self;
}

@end
