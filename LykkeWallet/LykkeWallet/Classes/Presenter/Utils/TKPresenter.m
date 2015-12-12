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

#pragma mark - Private

- (void)closeKeyboard;

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


#pragma mark - Utils

- (void)animateConstraintChanges {
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - Keyboard

- (void)subscribeKeyboardNotifications {
    [self subscribe:UIKeyboardWillShowNotification selector:@selector(observeKeyboardWillShowNotification:)];
    [self subscribe:UIKeyboardWillHideNotification selector:@selector(observeKeyboardWillHideNotification:)];
}

- (void)addKeyboardCloseTapGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)observeKeyboardWillShowNotification:(NSNotification *)notification {
    // ...
}

- (void)observeKeyboardWillHideNotification:(NSNotification *)notification {
    // ...
}


#pragma mark - Private

- (void)closeKeyboard {
    [self.view endEditing:YES];
}


#pragma mark - Properties

- (BOOL)isVisible {
    return (self.isViewLoaded && self.view.window);
}


#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    // ...
}

@end
