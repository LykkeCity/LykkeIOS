//
//  LWLykkeTableViewCell.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 28.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKTableViewCell.h"


@interface LWLykkeTableViewCell : TKTableViewCell {
    
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletBalanceLabel;

@end
