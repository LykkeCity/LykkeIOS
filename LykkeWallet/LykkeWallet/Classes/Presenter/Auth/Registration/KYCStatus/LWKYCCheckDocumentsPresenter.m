//
//  LWKYCCheckDocumentsPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 29.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWKYCCheckDocumentsPresenter.h"
#import "LWRegisterCameraPresenter.h"


@interface LWKYCCheckDocumentsPresenter () {
    
}

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end


@implementation LWKYCCheckDocumentsPresenter


#pragma mark - LWAuthStepPresenter

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[LWAuthManager instance] requestDocumentsToUpload];
}

- (LWAuthStep)stepId {
    return LWAuthStepCheckDocuments;
}

- (void)localize {
    self.textLabel.text = [NSString stringWithFormat:Localize(@"register.check.documents.label")];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didCheckDocumentsStatus:(LWDocumentsStatus *)status {
    LWAuthStep nextStep = [LWAuthSteps getNextDocumentByStatus:status];

    [((LWAuthNavigationController *)self.navigationController)
     navigateToStep:nextStep
     preparationBlock:^(LWAuthStepPresenter *presenter) {
         LWRegisterCameraPresenter *camera = (LWRegisterCameraPresenter *)presenter;
         camera.shouldHideBackButton = YES;
         camera.showCameraImmediately = YES;
         camera.currentStep = nextStep;
     }];
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    
    [((LWAuthNavigationController *)self.navigationController) logout];
}

@end
