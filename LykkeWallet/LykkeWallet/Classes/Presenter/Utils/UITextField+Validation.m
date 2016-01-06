//
//  UITextField+Validation.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 06.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "UITextField+Validation.h"


@implementation UITextField (Validation)

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string forMaxLength:(NSInteger)maxLength {
    
    NSUInteger oldLength = [self.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
        
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    NSUInteger maxLengthResult = (maxLength > 0) ? maxLength : INT_MAX;
        
    BOOL isReturnKey = [string rangeOfString: @"\n"].location != NSNotFound;
        
    return (newLength <= maxLengthResult) || isReturnKey;
}

@end
