//
//  LWAssetLykkeTableViewCell.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAssetLykkeTableViewCell.h"
#import "LWAssetPairModel.h"
#import "LWAssetPairRateModel.h"
#import "LWConstants.h"
#import "LWColorizer.h"
#import "LWMath.h"


@implementation LWAssetLykkeTableViewCell

- (void)setRate:(LWAssetPairRateModel *)rate {
    _rate = rate;
    
    if (self.rate && self.pair) {
        NSDecimalNumber *rateValue = [NSDecimalNumber decimalNumberWithDecimal:[rate.ask decimalValue]];

        // price section
        NSString *priceString = [LWMath makeStringByDecimal:rateValue withPrecision:self.pair.accuracy.integerValue];
        self.assetPriceLabel.text = [NSString stringWithFormat:@"$ %@", priceString];
        self.assetPriceLabel.textColor = [UIColor colorWithHexString:kMainElementsColor];

        // change section
        NSDecimalNumber *changeValue = [NSDecimalNumber decimalNumberWithDecimal:[rate.pchng decimalValue]];
        NSString *changeString = [LWMath makeStringByDecimal:changeValue withPrecision:1];
        NSString *sign = (rate.pchng.doubleValue >= 0.0) ? @"+" : @"";
        UIColor *changeColor = (rate.pchng.doubleValue >= 0.0)
                                ? [UIColor colorWithHexString:kAssetChangePlusColor]
                                : [UIColor colorWithHexString:kAssetChangeMinusColor];
        self.assetChangeLabel.textColor = changeColor;
        self.assetChangeLabel.text = [NSString stringWithFormat:@"%@%@%%", sign, changeString];
        
        self.assetPriceImageView.image = [UIImage imageNamed:@"AssetPriceArea"];
    }
    else {
        self.assetPriceLabel.text = @". . .";
        self.assetPriceLabel.textColor = [UIColor colorWithHexString:kMainDarkElementsColor];
        self.assetChangeLabel.text = @". . .";
        self.assetChangeLabel.textColor = [UIColor colorWithHexString:kMainDarkElementsColor];
        self.assetPriceImageView.image = [UIImage imageNamed:@"AssetPriceDisabledArea"];
    }
}

- (void)setPair:(LWAssetPairModel *)pair {
    _pair = pair;
    
    self.assetNameLabel.text = pair.name;
}

@end
