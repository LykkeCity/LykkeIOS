//
//  LWAuthValidationPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 21.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWAuthValidationPresenter.h"
#import "LWRegisterCameraPresenter.h"
#import "LWAuthNavigationController.h"
#import "LWAuthManager.h"
#import "UIViewController+Loading.h"


@interface LWAuthValidationPresenter () {
    
}

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end


@implementation LWAuthValidationPresenter


#pragma mark - LWAuthStepPresenter

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[LWAuthManager instance] requestRegistrationGet];
}

- (LWAuthStep)stepId {
    return LWAuthStepValidation;
}

#ifdef PROJECT_IATA
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
#endif

- (void)localize {
    self.textLabel.text = [NSString stringWithFormat:Localize(@"register.validation.label")];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManagerDidRegisterGet:(LWAuthManager *)manager KYCStatus:(NSString *)status isPinEntered:(BOOL)isPinEntered {

    LWAuthNavigationController *navController = (LWAuthNavigationController *)self.navigationController;
    
    if ([status isEqualToString:@"NeedToFillData"]) {
        // request documents to upload
        self.textLabel.text = [NSString stringWithFormat:Localize(@"register.check.documents.label")];
        [[LWAuthManager instance] requestDocumentsToUpload];
    }
    else {
        [navController navigateKYCStatus:status
                            isPinEntered:isPinEntered
                        isAuthentication:YES];
    }
}

- (void)authManager:(LWAuthManager *)manager didCheckDocumentsStatus:(LWDocumentsStatus *)status {
    [((LWAuthNavigationController *)self.navigationController) navigateWithDocumentStatus:status hideBackButton:YES];
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    
    [((LWAuthNavigationController *)self.navigationController) logout];
}

@end
