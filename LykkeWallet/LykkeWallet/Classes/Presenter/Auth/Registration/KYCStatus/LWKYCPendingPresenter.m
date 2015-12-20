//
//  LWKYCPendingPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 15.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWKYCPendingPresenter.h"
#import "LWRegistrationData.h"
#import "LWAuthManager.h"
#import "LWPacketKYCStatusSet.h"
#import "LWPacketKYCStatusGet.h"
#import "LWAuthNavigationController.h"
#import "TKPresenter+Loading.h"


@interface LWKYCPendingPresenter () {
    
}

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end


@implementation LWKYCPendingPresenter


#pragma mark - LWAuthStepPresenter

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // if status already received (authentication for example) - we shouldn't make request
    if (self.status && ![self.status isEqualToString:@""]) {
        [self authManager:[LWAuthManager instance] didGetKYCStatus:self.status];
    } else {
        [[LWAuthManager instance] requestKYCStatusSet];
    }
}

- (void)localize {
    self.textLabel.text = [NSString stringWithFormat:Localize(@"register.kyc.pending"),
                           [LWAuthManager instance].registrationData.fullName];
}

- (LWAuthStep)stepId {
    return LWAuthStepRegisterKYCPending;
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    GDXNetPacket *pack = context.packet;
    
    if (reject) {
        [self showReject:reject];
    }
    else {
        // some server error? Then just repeat request after some delay
        const NSInteger repeatSeconds = 5;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(repeatSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (pack.class == LWPacketKYCStatusSet.class) {
                [[LWAuthManager instance] requestKYCStatusSet];
            }
            else if (pack.class == LWPacketKYCStatusGet.class) {
                [[LWAuthManager instance] requestKYCStatusGet];
            }
        });
    }
}

- (void)authManagerDidSetKYCStatus:(LWAuthManager *)manager {
    NSLog(@"Requesting KYC status...");
    [[LWAuthManager instance] requestKYCStatusGet];
}

- (void)authManager:(LWAuthManager *)manager didGetKYCStatus:(NSString *)status {
    LWAuthNavigationController *navController = (LWAuthNavigationController *)self.navigationController;
    NSLog(@"KYC GetStatus: %@", status);
    if ([status isEqualToString:@"NeedToFillData"]) {
        [navController navigateToStep:LWAuthStepRegisterKYCInvalidDocuments preparationBlock:nil];
    }
    else if ([status isEqualToString:@"RestrictedArea"]) {
        [navController navigateToStep:LWAuthStepRegisterKYCRestricted preparationBlock:nil];
    }
    else if ([status isEqualToString:@"Ok"]) {
#warning TODO: validate PIN here (for authentication)
        [navController navigateToStep:LWAuthStepRegisterKYCSuccess preparationBlock:nil];
    }
    else if ([status isEqualToString:@"Rejected"] || [status isEqualToString:@"Pending"]) {
        const NSInteger repeatSeconds = 5;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(repeatSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self authManagerDidSetKYCStatus:nil];
        });
    }
    else {
        NSAssert(0, @"Unknown KYC status.");
    }
}

@end
