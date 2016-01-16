//
//  LWMathKeyboardView.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 14.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWMathKeyboardView.h"
#import "GCMathParser.h"

typedef NS_ENUM(NSInteger, LWMathKeyboardViewNumpad) {
    LWMathKeyboardViewNumpad1 = 1,
    LWMathKeyboardViewNumpad2,
    LWMathKeyboardViewNumpad3,
    LWMathKeyboardViewNumpad4,
    LWMathKeyboardViewNumpad5,
    LWMathKeyboardViewNumpad6,
    LWMathKeyboardViewNumpad7,
    LWMathKeyboardViewNumpad8,
    LWMathKeyboardViewNumpad9,
    LWMathKeyboardViewNumpad0,
    LWMathKeyboardViewNumpadDot,
    LWMathKeyboardViewNumpadBackspace
};

typedef NS_ENUM(NSInteger, LWMathKeyboardViewSign) {
    LWMathKeyboardViewSignDivide,
    LWMathKeyboardViewSignMultiply,
    LWMathKeyboardViewSignSubtract,
    LWMathKeyboardViewSignAdd,
    LWMathKeyboardViewSignEquals
};


@interface LWMathKeyboardView () {
    
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *snippetButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numpadButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *signButtons;


#pragma mark - Actions

- (IBAction)snippetButtonClick:(UIButton *)sender;
- (IBAction)numpadButtonClick:(UIButton *)sender;
- (IBAction)signButtonClick:(UIButton *)sender;

@end


@implementation LWMathKeyboardView


#pragma mark - Root

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat whLine = 1; // 1px between elements
    
    CGFloat wTotal = self.frame.size.width;
    CGFloat wSign = [self.signButtons.firstObject frame].size.width;
    CGFloat wNumpadArea = wTotal - wSign - whLine;
    CGFloat wNumpad = (wNumpadArea - whLine * 2) / 3;
    CGFloat wSnippet = (wTotal - whLine * 2) / 3;
    
    CGFloat hTotal = self.frame.size.height;
    CGFloat hSnippet = [self.snippetButtons.firstObject frame].size.height;
    CGFloat hNumpadArea = hTotal - hSnippet - whLine;
    CGFloat hNumpad = (hNumpadArea - whLine * 3) / 4;
    CGFloat hSign = hNumpadArea / 5;
    
    for (NSInteger i = 0; i < self.snippetButtons.count; i++) {
        UIButton *button = self.snippetButtons[i];
        button.frame = CGRectMake(i * (wSnippet + whLine), 0, wSnippet, hSnippet);
    }
    for (NSInteger i = 0; i < self.signButtons.count; i++) {
        UIButton *button = self.signButtons[i];
        button.frame = CGRectMake(wNumpadArea + whLine, hSnippet + whLine + i * hSign, wSign, hSign);
    }
    NSInteger col = 0;
    NSInteger row = -1;
    for (NSInteger i = 0; i < self.numpadButtons.count; i++, col++) {
        if (i % 3 == 0) {
            col = 0;
            ++row;
        }
        UIButton *button = self.numpadButtons[i];
        button.frame = CGRectMake(col * (wNumpad + whLine),
                                  (hSnippet + whLine) + row * (hNumpad + whLine),
                                  wNumpad,
                                  hNumpad);
    }
}


#pragma mark - Actions

- (IBAction)snippetButtonClick:(UIButton *)sender {
    NSString *str = [sender.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.targetTextField.text = [self.targetTextField.text stringByAppendingString:str];
}

- (IBAction)numpadButtonClick:(UIButton *)sender {
    switch (sender.tag) {
        case LWMathKeyboardViewNumpadBackspace: {
            if (self.targetTextField.text.length > 0) {
                NSRange range = NSMakeRange(self.targetTextField.text.length - 1, 1);
                self.targetTextField.text = [self.targetTextField.text
                                             stringByReplacingCharactersInRange:range
                                             withString:@""];
            }
            break;
        }
        default: {
            self.targetTextField.text = [self.targetTextField.text
                                         stringByAppendingString:sender.titleLabel.text];
        }
    }
}

- (IBAction)signButtonClick:(UIButton *)sender {
    BOOL equals = NO;
    NSString *str = nil;
    switch (sender.tag) {
        case LWMathKeyboardViewSignDivide: {
            str = @"/";
            break;
        }
        case LWMathKeyboardViewSignMultiply: {
            str = @"*";
            break;
        }
        case LWMathKeyboardViewSignSubtract: {
            str = @"-";
            break;
        }
        case LWMathKeyboardViewSignAdd: {
            str = @"+";
            break;
        }
        case LWMathKeyboardViewSignEquals: {
            equals = YES;
            break;
        }
    }
    if (!equals) {
        self.targetTextField.text = [self.targetTextField.text stringByAppendingString:str];
    }
    else {
        // calculate
        @try {
            self.targetTextField.text = [NSString stringWithFormat:@"%f",
                                         [self.targetTextField.text evaluateMath]];
        }
        @catch (NSException *exception) {
            [self.delegate mathKeyboardViewDidRaiseMathException:self];
        }
    }
}

@end
