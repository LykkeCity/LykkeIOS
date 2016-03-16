//
//  LWBitcoinTableViewCell.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 15.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "TKTableViewCell.h"


#define kBitcoinTableViewCell           @"LWBitcoinTableViewCell"
#define kBitcoinTableViewCellIdentifier @"LWBitcoinTableViewCellIdentifier"


@class LWBitcoinTableViewCell;

@protocol LWBitcoinTableViewCellDelegate<NSObject>

@required
- (void)addBitcoinClicked:(LWBitcoinTableViewCell *)cell;

@end


@interface LWBitcoinTableViewCell : TKTableViewCell {
    
}

#pragma mark - Properties

@property (weak, nonatomic) id<LWBitcoinTableViewCellDelegate> delegate;

#pragma mark - Outlets

@property (nonatomic, weak) IBOutlet UILabel *bitcoinLabel;
@property (nonatomic, weak) IBOutlet UILabel *bitcoinBalance;
@property (nonatomic, weak) IBOutlet UIButton *bitcoinAddButton;

@end
