//
//  UIViewController+Navigation.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 05.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "UIViewController+Navigation.h"


@implementation UIViewController (Navigation)

- (void)setBackButton {
    if (self.navigationController && self.navigationItem) {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackIcon"] style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
        self.navigationItem.leftBarButtonItem = button;
    }
}

@end
