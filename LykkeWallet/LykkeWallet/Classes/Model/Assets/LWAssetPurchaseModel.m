//
//  LWAssetPurchaseModel.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 08.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAssetPurchaseModel.h"


@implementation LWAssetPurchaseModel


#pragma mark - LWJSONObject

- (instancetype)initWithJSON:(id)json {
    self = [super initWithJSON:json];
    if (self) {
        _identity          = [json objectForKey:@"Id"];
        _orderType         = [json objectForKey:@"OrderType"];
        _volume            = [json objectForKey:@"Volume"];
        _price             = [json objectForKey:@"Price"];
        _baseAsset         = [json objectForKey:@"BaseAsset"];
        _assetPair         = [json objectForKey:@"AssetPair"];
        _blockchainId      = [json objectForKey:@"BlockchainId"];
        _blockchainSettled = [[json objectForKey:@"BlockchainSetteled"] boolValue];
        _totalCost         = [json objectForKey:@"TotalCost"];
        _commission        = [json objectForKey:@"Comission"];
        _position          = [json objectForKey:@"Position"];
    }
    return self;
}

@end
