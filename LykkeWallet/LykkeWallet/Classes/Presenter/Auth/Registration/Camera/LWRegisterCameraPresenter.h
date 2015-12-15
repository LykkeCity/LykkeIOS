//
//  LWRegisterCameraPresenter.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthStepPresenter.h"


@interface LWRegisterCameraPresenter : LWAuthStepPresenter<
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
> {
    UIImage *photo;
}

@property (weak, nonatomic) IBOutlet UILabel     *promptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stepImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton    *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton    *okButton;


#pragma mark - Actions

- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)okButtonClick:(id)sender;

@end
