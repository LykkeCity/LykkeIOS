//
//  LWAppSettingsModel.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAppSettingsModel.h"
#import "LWAssetModel.h"


@implementation LWAppSettingsModel


#pragma mark - LWJSONObject

- (instancetype)initWithJSON:(id)json {
    self = [super initWithJSON:json];
    if (self) {
        _rateRefreshPeriod = [json objectForKey:@"RateRefreshPeriod"];
        _baseAsset = [[LWAssetModel alloc] initWithJSON:json[@"BaseAsset"]];
    }
    return self;
}

@end
