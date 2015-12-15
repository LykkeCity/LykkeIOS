//
//  LWKYCPendingPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 15.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWKYCPendingPresenter.h"
#import "LWRegistrationData.h"


@interface LWKYCPendingPresenter () {
    
}

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end


@implementation LWKYCPendingPresenter


#pragma mark - Properties

- (void)setRegistrationData:(LWRegistrationData *)registrationData {
    _registrationData = registrationData;
    
    self.textLabel.text = [NSString stringWithFormat:Localize(@"register.kyc.pending"),
                           self.registrationData.firstName,
                           self.registrationData.lastName];
}

@end
