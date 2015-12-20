//
//  LWValidator.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 10.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIButton.h>


@interface LWValidator : NSObject {
    
}

#pragma mark - Texts

+ (BOOL)validateEmail:(NSString *)input;
+ (BOOL)validateFullName:(NSString *)input;
+ (BOOL)validatePhone:(NSString *)input;
+ (BOOL)validatePassword:(NSString *)input;
+ (BOOL)validateConfirmPassword:(NSString *)input;
+ (void)setButton:(UIButton *)button enabled:(BOOL)isValid;

@end
