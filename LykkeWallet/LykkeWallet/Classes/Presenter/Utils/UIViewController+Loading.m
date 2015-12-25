//
//  UIViewController+Loading.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 16.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "UIViewController+Loading.h"
#import "Macro.h"


@implementation UIViewController (Loading)


- (void)setLoading:(BOOL)loading {
    if (loading) {
        [self.view endEditing:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeIndeterminate;
    }
    else {
        [[self hud] hide:YES];
    }
}

- (MBProgressHUD *)hud {
    return [MBProgressHUD HUDForView:self.navigationController.view];
}

- (void)showReject:(NSDictionary *)reject {
    [self setLoading:NO];
    
    NSString *message = [reject objectForKey:@"Message"];
    
    UIAlertController *ctrl = [UIAlertController
                               alertControllerWithTitle:Localize(@"utils.error")
                               message:message
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

@end
