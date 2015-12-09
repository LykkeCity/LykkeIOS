//
//  LWAuthEntryPointPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthEntryPointPresenter.h"
#import "LWTextField.h"


@interface LWAuthEntryPointPresenter () {
    LWTextField *emailTextField;
}

@property (weak, nonatomic) IBOutlet TKContainer *emailTextFieldContainer;

@end


@implementation LWAuthEntryPointPresenter


#pragma mark - TKPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    // init email field
    emailTextField = [LWTextField new];
    [self.emailTextFieldContainer attach:emailTextField];
}


#pragma mark - LWAuthStepPresenter

- (LWAuthStep)stepId {
    return LWAuthStepEntryPoint;
}

@end
