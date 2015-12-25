//
//  TKButton.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 25.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKButton.h"
#import "LWConstants.h"
#import "UIColor+Generic.h"


@implementation TKButton {
    
}


#pragma mark - Properties

- (void)setTitleFont:(UIFont *)titleFont {
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        [self.titleLabel setFont:_titleFont];
    }
}

@end
