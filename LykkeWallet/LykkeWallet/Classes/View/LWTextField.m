//
//  LWTextField.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWTextField.h"
#import "TKContainer.h"
#import "NSObject+GDXObserver.h"


@interface LWTextField ()<UITextFieldDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
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
    
    UIImage *background = [[UIImage imageNamed:@"TextField"]
                           resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    self.backgroundImageView.image = background;
}

- (void)dealloc {
    [self unsubscribeAll];
}

- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}

+ (LWTextField *)createTextFieldForContainer:(TKContainer *)container withPlaceholder:(NSString *)placeholder {
    LWTextField *(^createField)(TKContainer *, NSString *) = ^LWTextField *(TKContainer *container, NSString *placeholder) {
        
        LWTextField *f = [LWTextField new];
        f.keyboardType = UIKeyboardTypeASCIICapable;
        f.placeholder = placeholder;
        [container attach:f];
        
        return f;
    };
    
    LWTextField *result = createField(container, placeholder);
    return result;
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

- (void)setSecure:(BOOL)secure {
    _secure = secure;
    
    self.textField.secureTextEntry = self.secure;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    
    self.textField.enabled = self.isEnabled;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    
    self.textField.keyboardType = self.keyboardType;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType {
    _autocapitalizationType = autocapitalizationType;
    
    self.textField.autocapitalizationType = self.autocapitalizationType;
}

- (void)setViewMode:(UITextFieldViewMode)viewMode {
    _viewMode = viewMode;
    
    [self.textField setClearButtonMode:self.viewMode];
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
