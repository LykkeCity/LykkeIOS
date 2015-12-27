//
//  LWWalletTableViewCell.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 27.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKTableViewCell.h"


@interface LWWalletTableViewCell : TKTableViewCell {
    
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UILabel *walletLabel;
@property (weak, nonatomic) IBOutlet UIImageView *walletImageView;
@property (weak, nonatomic) IBOutlet UIImageView *expandImageView;

@end
