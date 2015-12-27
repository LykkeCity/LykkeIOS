//
//  LWEquityTableViewCell.h
//  LykkeWallet
//
//  Created by Alexander Pukhov on 28.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKTableViewCell.h"


@interface LWEquityTableViewCell : TKTableViewCell {
    
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UILabel *equityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *equityValueLabel;

@end
