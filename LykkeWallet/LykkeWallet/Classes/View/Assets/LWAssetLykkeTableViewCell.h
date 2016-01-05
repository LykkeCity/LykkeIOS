//
//  LWAssetLykkeTableViewCell.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "TKTableViewCell.h"


@class LWAssetPairRateModel;


@interface LWAssetLykkeTableViewCell : TKTableViewCell {
    
}

#pragma mark - Properties

@property (strong, nonatomic) LWAssetPairRateModel *rate;


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UILabel *assetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *assetChangeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *assetPriceImageView;

@end
