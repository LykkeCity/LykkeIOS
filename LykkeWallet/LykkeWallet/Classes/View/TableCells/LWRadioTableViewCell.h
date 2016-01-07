//
//  LWRadioTableViewCell.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 07.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "TKTableViewCell.h"


#define kRadioTableViewCell           @"LWRadioTableViewCell"
#define kRadioTableViewCellIdentifier @"LWRadioTableViewCellIdentifier"


@interface LWRadioTableViewCell : TKTableViewCell {
    
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UILabel  *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *radioSwitch;

@end
