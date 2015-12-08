//
//  TKPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 02.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKPresenter.h"


@interface TKPresenter () {
    
}

@end


@implementation TKPresenter


#pragma mark - Lifecycle

- (instancetype)init {
    return [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle mainBundle]];
}

- (void)dealloc {
    [self unsubscribeAll];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    [self localize];
    [self colorize];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unsubscribeAll];
}


#pragma mark - Setup

- (void)localize {
    // override if necessary
}

- (void)colorize {
    // override if necessary
}


#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

@end
