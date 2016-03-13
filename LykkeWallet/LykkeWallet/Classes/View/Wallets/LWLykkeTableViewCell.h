//
//  LWLykkeTableViewCell.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 28.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "SWTableViewCell.h"


@interface LWLykkeTableViewCell : SWTableViewCell {
    
}

#pragma mark - Identity

+ (NSString *)reuseIdentifier;
+ (UINib *)nib;


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletBalanceLabel;

@end
