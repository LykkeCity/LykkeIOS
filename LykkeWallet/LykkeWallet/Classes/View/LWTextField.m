//
//  LWTextField.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWTextField.h"


@interface LWTextField ()<UITextFieldDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *validImageView;

@end


@implementation LWTextField


#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.validImageView.hidden = YES;
}


#pragma mark - Validation

- (BOOL)validateWithRegex:(NSString *)regex {
    NSRegularExpression *expr = [NSRegularExpression
                                 regularExpressionWithPattern:regex
                                 options:NSRegularExpressionCaseInsensitive
                                 error:nil];
    BOOL valid = [expr numberOfMatchesInString:self.text
                                       options:0
                                         range:NSMakeRange(0, self.text.length)];
    self.validImageView.hidden = !valid;
    
    return valid;
}


#pragma mark - Properties

- (NSString *)text {
    return [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)setText:(NSString *)text {
    self.textField.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)placeholder {
    return self.textField.placeholder;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.textField.placeholder = placeholder;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    NSUInteger maxLength = (self.maxLength > 0) ? self.maxLength : INT_MAX;
    
    BOOL isReturnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return (newLength <= maxLength) || isReturnKey;
}

@end
