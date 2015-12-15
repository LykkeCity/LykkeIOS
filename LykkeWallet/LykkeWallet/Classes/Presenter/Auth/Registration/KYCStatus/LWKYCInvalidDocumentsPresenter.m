//
//  LWKYCInvalidDocumentsPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 15.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWKYCInvalidDocumentsPresenter.h"
#import "LWRegistrationData.h"


@interface LWKYCInvalidDocumentsPresenter () {
    
}

@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end


@implementation LWKYCInvalidDocumentsPresenter


#pragma mark - TKPresenter

- (void)localize {
    self.headerLabel.text = Localize(@"register.kyc.invalidDocuments.header");
}


#pragma mark - Properties

- (void)setRegistrationData:(LWRegistrationData *)registrationData {
    _registrationData = registrationData;
    
    self.textLabel.text = [NSString stringWithFormat:Localize(@"register.kyc.invalidDocuments"),
                           self.registrationData.firstName,
                           self.registrationData.lastName];
}

@end
