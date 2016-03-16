//
//  LWBitcoinTableViewCell.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 15.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWBitcoinTableViewCell.h"


@implementation LWBitcoinTableViewCell


#pragma mark - Actions

- (IBAction)onPlusClicked:(id)sender {
    [self.delegate addBitcoinClicked:self];
}

@end
