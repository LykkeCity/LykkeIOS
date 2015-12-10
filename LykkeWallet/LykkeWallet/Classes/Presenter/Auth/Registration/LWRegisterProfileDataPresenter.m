//
//  LWRegisterProfileDataPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterProfileDataPresenter.h"


@interface LWRegisterProfileDataPresenter () {
    
}

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@end


@implementation LWRegisterProfileDataPresenter


#pragma mark - TKPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"title.register");
}

- (void)localize {
    self.promptLabel.text = Localize(@"register.step1.prompt");
}

@end
