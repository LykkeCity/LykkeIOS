//
//  UIViewController+Loading.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 16.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "UIViewController+Loading.h"
#import "UIView+Toast.h"
#import "Macro.h"

#warning TODO: temporary
#import "LWKeychainManager.h"

@implementation UIViewController (Loading)


- (void)setLoading:(BOOL)loading {
    if (loading) {
        [self.view endEditing:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    else {
        MBProgressHUD *hud = [self hud];
        if (hud) {
            [hud hide:YES];
        }
    }
}

- (MBProgressHUD *)hud {
    return [MBProgressHUD HUDForView:self.navigationController.view];
}

- (void)showReject:(NSDictionary *)reject {
    [self setLoading:NO];
    
    NSString *message = [reject objectForKey:@"Message"];
#warning TODO: as request by customer (temporarly)
    NSNumber *code = [reject objectForKey:@"Code"];
#warning TODO: temporary keychain email
    NSString *email = [[LWKeychainManager instance] login];
    NSString *time = [self currentUTC];
    
    NSString *error = [NSString stringWithFormat:@"Error: %@. Code: %@. Login: %@. DateTime: %@", message, code, email, time];
    
    UIAlertController *ctrl = [UIAlertController
                               alertControllerWithTitle:Localize(@"utils.error")
                               message:error
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:Localize(@"utils.ok")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [ctrl dismissViewControllerAnimated:YES
                                                                                  completion:nil];
                                                     }];
    [ctrl addAction:actionOK];
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)showReject:(NSDictionary *)reject code:(NSInteger)code willNotify:(BOOL)willNotify {
    if (code == NSURLErrorNotConnectedToInternet) {
        [self setLoading:NO];
        
        if (willNotify) {
            [self.navigationController.view makeToast:Localize(@"errors.network.connection")];
        }
    }
    else {
        [self showReject:reject];
    }
}


#pragma mark - Utils

- (NSString *)currentUTC {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    // Add this part to your code
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    
    NSDate *now = [NSDate date];
    NSString *result = [formatter stringFromDate:now];
    return result;
}

@end
