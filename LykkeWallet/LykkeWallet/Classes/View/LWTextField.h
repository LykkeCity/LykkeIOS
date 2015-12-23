//
//  LWTextField.h
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "TKView.h"

@class LWTextField;
@class TKContainer;

@protocol LWTextFieldDelegate
@required
- (void)textFieldDidChangeValue:(LWTextField *)textField;

@end

@interface LWTextField : TKView {
    
}

@property (weak, nonatomic) id<LWTextFieldDelegate> delegate;

@property (assign, nonatomic) NSString   *text;
@property (assign, nonatomic) NSString   *placeholder;
@property (assign, nonatomic) NSUInteger maxLength;
@property (assign, nonatomic) UIKeyboardType keyboardType;
@property (assign, nonatomic) UITextAutocapitalizationType autocapitalizationType;

@property (assign, nonatomic, getter=isSecure)  BOOL secure;
@property (assign, nonatomic, getter=isEnabled) BOOL enabled;
@property (assign, nonatomic, getter=isValid)   BOOL valid;

+ (LWTextField *)createTextFieldForContainer:(TKContainer *)container withPlaceholder:(NSString *)placeholder;

@end
