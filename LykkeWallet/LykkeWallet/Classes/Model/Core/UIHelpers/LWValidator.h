//
//  LWValidator.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 10.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LWValidator : NSObject {
    
}

#pragma mark - Texts

+ (BOOL)validateEmail:(NSString *)input;
+ (BOOL)validateFullName:(NSString *)input;
+ (BOOL)validatePhone:(NSString *)input;
+ (BOOL)validatePassword:(NSString *)input;
+ (BOOL)validateConfirmPassword:(NSString *)input;

@end
