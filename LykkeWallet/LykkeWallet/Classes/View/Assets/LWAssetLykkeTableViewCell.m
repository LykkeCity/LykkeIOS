//
//  LWAssetLykkeTableViewCell.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWAssetLykkeTableViewCell.h"
#import "LWAssetPairRateModel.h"
#import "LWMath.h"


@implementation LWAssetLykkeTableViewCell

- (void)setRate:(LWAssetPairRateModel *)rate {
    _rate = rate;
    
    if (self.rate) {
        NSDecimalNumber *rateValue = [NSDecimalNumber decimalNumberWithDecimal:[rate.ask decimalValue]];
        self.assetPriceLabel.text = [LWMath makeStringByDecimal:rateValue withPrecision:rate.pchng.integerValue];
        self.assetChangeLabel.text = @". . .";
        self.assetPriceImageView.image = [UIImage imageNamed:@"AssetPriceArea"];
    }
    else {
        self.assetPriceLabel.text = @". . .";
        self.assetChangeLabel.text = @". . .";
        self.assetPriceImageView.image = [UIImage imageNamed:@"AssetPriceDisabledArea"];
    }
}

@end
