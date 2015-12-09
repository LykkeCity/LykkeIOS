//
//  LWTextField.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKView.h"


@interface LWTextField : TKView {
    
}

@property (assign, nonatomic) NSString   *text;
@property (assign, nonatomic) NSString   *placeholder;
@property (assign, nonatomic) NSUInteger maxLength;


#pragma mark - Validation

- (BOOL)validateWithRegex:(NSString *)regex;

@end
