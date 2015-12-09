//
//  TKPresenter.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 02.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWColorizer.h"
#import "TKContainer.h"
#import "NSObject+GDXObserver.h"


@interface TKPresenter : UIViewController {
    
}

#pragma mark - Setup

- (void)localize;
- (void)colorize;


#pragma mark - Animation

- (void)animateConstraintChanges;


#pragma mark - Keyboard

- (void)subscribeKeyboardNotifications;
- (void)addKeyboardCloseTapGestureRecognizer;
- (void)observeKeyboardWillShowNotification:(NSNotification *)notification;
- (void)observeKeyboardWillHideNotification:(NSNotification *)notification;

@end
