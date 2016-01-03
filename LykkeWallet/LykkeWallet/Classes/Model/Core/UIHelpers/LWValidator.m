//
//  LWValidator.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 10.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWValidator.h"
#import <UIKit/UIImage.h>


@implementation LWValidator

static int const MinTextLength = 1;
static int const PasswordLength = 6;

#pragma mark - Texts

+ (BOOL)validateEmail:(NSString *)input {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:input];
}

+ (BOOL)validateFullName:(NSString *)input {
    return (input && input.length >= MinTextLength);
}

+ (BOOL)validatePhone:(NSString *)input {
    return (input && input.length >= MinTextLength);
}

+ (BOOL)validatePassword:(NSString *)input {
    return (input && input.length >= PasswordLength);
}

+ (BOOL)validateConfirmPassword:(NSString *)input {
    return (input && input.length >= PasswordLength);
}

+ (BOOL)validateCardNumber:(NSString *)input {
#warning TODO:
    return input.length > 0;
}

+ (BOOL)validateCardExpiration:(NSString *)input {
#warning TODO:
    return input.length > 0;
}

+ (BOOL)validateCardOwner:(NSString *)input {
#warning TODO:
    return input.length > 0;
}

+ (BOOL)validateCardCode:(NSString *)input {
#warning TODO:
    return input.length > 0;
}

+ (void)setButton:(UIButton *)button enabled:(BOOL)enabled {
    NSString *proceedImage = (enabled) ? @"ButtonOK" : @"ButtonOKInactive";
    UIColor *proceedColor = (enabled) ? [UIColor whiteColor] : [UIColor lightGrayColor];
    
    [button setBackgroundImage:[UIImage imageNamed:proceedImage] forState:UIControlStateNormal];
    [button setTitleColor:proceedColor forState:UIControlStateNormal];
    button.enabled = enabled;
}

@end
