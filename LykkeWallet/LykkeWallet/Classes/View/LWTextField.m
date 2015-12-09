//
//  LWTextField.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWTextField.h"
#import "NSObject+GDXObserver.h"


@interface LWTextField ()<UITextFieldDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *validImageView;


#pragma mark - Observing

- (void)observeTextFieldDidChangeNotification:(NSNotification *)notification;

@end


@implementation LWTextField


#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.validImageView.hidden = YES;
    // observe text changes
    [self subscribe:UITextFieldTextDidChangeNotification
           selector:@selector(observeTextFieldDidChangeNotification:)];
}

- (void)dealloc {
    [self unsubscribeAll];
}


#pragma mark - Observing

- (void)observeTextFieldDidChangeNotification:(NSNotification *)notification {
    [self.delegate textFieldDidChangeValue:self];
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

- (void)setValid:(BOOL)valid {
    _valid = valid;
    
    self.validImageView.hidden = !self.isValid;
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
