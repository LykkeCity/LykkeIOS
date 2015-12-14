//
//  LWRegisterCameraPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterCameraPresenter.h"


@interface LWRegisterCameraPresenter () {
    UIImage *photo;
}

@property (weak, nonatomic) IBOutlet UILabel     *promptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stepImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton    *okButton;


#pragma mark - Actions

- (IBAction)okButtonClick:(id)sender;

@end


@implementation LWRegisterCameraPresenter


#pragma mark - TKPresenter

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSInteger imgNumber;
    switch (self.stepId) {
        case LWAuthStepRegisterSelfie: {
            imgNumber = 2;
            break;
        }
        case LWAuthStepRegisterIdentity: {
            imgNumber = 3;
            break;
        }
        case LWAuthStepRegisterUtilityBill: {
            imgNumber = 4;
            break;
        }
        default: {
            NSAssert(0, @"Invalid step");
            break;
        }
    }
    NSString *imgName = [NSString stringWithFormat:@"RegisterStep%ld", imgNumber];
    self.stepImageView.image = [UIImage imageNamed:imgName];
}


#pragma mark - Actions

- (IBAction)okButtonClick:(id)sender {
    if (photo) {
        // move next
        // ...
    }
    else {
        // display image picker
        // ...
    }
}

@end
