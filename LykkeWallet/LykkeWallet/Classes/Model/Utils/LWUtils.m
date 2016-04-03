//
//  LWUtils.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 03.04.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWUtils.h"
#import "LWCache.h"
#import "LWMath.h"
#import "LWAssetModel.h"
#import "LWAssetPairModel.h"


@implementation LWUtils

+ (UIImage *)imageForIssuerId:(NSString *)issuerId {
    if (issuerId) {
        if ([issuerId isEqualToString:@"BTC"]) {
            return [UIImage imageNamed:@"WalletBitcoin"];
        }
        else if ([issuerId isEqualToString:@"LKE"]) {
            return [UIImage imageNamed:@"WalletLykke"];
        }
    }
    return nil;
}

+ (NSString *)baseAssetTitle:(LWAssetPairModel *)assetPair {
    NSString *baseAssetId = [LWCache instance].baseAssetId;
    NSString *assetTitleId = assetPair.baseAssetId;
    if ([baseAssetId isEqualToString:assetPair.baseAssetId]) {
        assetTitleId = assetPair.quotingAssetId;
    }
    NSString *assetTitle = [LWAssetModel
                            assetByIdentity:assetTitleId
                            fromList:[LWCache instance].baseAssets];
    return assetTitle;
}

+ (NSString *)quotedAssetTitle:(LWAssetPairModel *)assetPair {
    NSString *baseAssetId = [LWCache instance].baseAssetId;
    NSString *assetTitleId = assetPair.quotingAssetId;
    if (![baseAssetId isEqualToString:assetPair.quotingAssetId]) {
        assetTitleId = assetPair.baseAssetId;
    }
    
    NSString *assetTitle = [LWAssetModel
                            assetByIdentity:assetTitleId
                            fromList:[LWCache instance].baseAssets];
    return assetTitle;
}

+ (NSString *)priceForAsset:(LWAssetPairModel *)assetPair forValue:(NSNumber *)value {
    // operation rate
    NSString *baseAssetId = [LWCache instance].baseAssetId;
    NSDecimalNumber *rate = [NSDecimalNumber decimalNumberWithDecimal:value.decimalValue];
    if ([baseAssetId isEqualToString:assetPair.baseAssetId]) {
        if (![LWMath isDecimalEqualToZero:rate]) {
            NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:@"1"];
            rate = [one decimalNumberByDividingBy:rate];
        }
    }
    
    NSNumber *number = [NSNumber numberWithDouble:rate.doubleValue];
    NSString *result = [LWMath priceString:number
                                 precision:assetPair.accuracy
                                withPrefix:@""];
    return result;
}

+ (NSString *)priceForAsset:(LWAssetPairModel *)assetPair forValue:(NSNumber *)value withFormat:(NSString *)format {
    
    NSString *rateString = [LWUtils priceForAsset:assetPair forValue:value];
    NSString *result = [NSString stringWithFormat:format,
                        [LWUtils baseAssetTitle:assetPair],
                        rateString,
                        [LWUtils quotedAssetTitle:assetPair]];
    
    return result;
}

@end
