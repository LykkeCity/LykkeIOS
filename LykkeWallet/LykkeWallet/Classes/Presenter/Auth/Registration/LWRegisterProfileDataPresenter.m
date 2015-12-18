//
//  LWRegisterProfileDataPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 09.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWRegisterProfileDataPresenter.h"
#import "LWTextField.h"
#import "LWValidator.h"
#import "LWAuthManager.h"
#import "LWAuthNavigationController.h"
#import "TKPresenter+Loading.h"


@interface LWRegisterProfileDataPresenter ()<LWAuthManagerDelegate> {
    LWTextField *emailField;
    LWTextField *firstNameField;
    LWTextField *lastNameField;
    LWTextField *phoneField;
    LWTextField *passwordField;
    LWTextField *passwordConfirmField;
}

@property (weak, nonatomic) IBOutlet UILabel      *promptLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet TKContainer  *emailContainer;
@property (weak, nonatomic) IBOutlet TKContainer  *firstNameContainer;
@property (weak, nonatomic) IBOutlet TKContainer  *lastNameContainer;
@property (weak, nonatomic) IBOutlet TKContainer  *phoneContainer;
@property (weak, nonatomic) IBOutlet TKContainer  *passwordContainer;
@property (weak, nonatomic) IBOutlet TKContainer  *passwordConfirmContainer;
@property (weak, nonatomic) IBOutlet UIButton     *submitButton;


#pragma mark - Private

- (BOOL)canProceed;


#pragma mark - Actions

- (IBAction)submitButtonClick:(id)sender;

@end


@implementation LWRegisterProfileDataPresenter


#pragma mark - TKPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"title.register");
    // init fields
    LWTextField *(^createField)(TKContainer *, NSString *) = ^LWTextField *(TKContainer *container, NSString *placeholder) {
        LWTextField *f = [LWTextField new];
//        f.delegate = self;
        f.keyboardType = UIKeyboardTypeASCIICapable;
        f.placeholder = placeholder;
        [container attach:f];
        
        return f;
    };
    emailField = createField(self.emailContainer, Localize(@"register.email"));
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.enabled = NO;
    
    firstNameField = createField(self.firstNameContainer, Localize(@"register.firstName"));
    firstNameField.keyboardType = UIKeyboardTypeDefault;
    lastNameField = createField(self.lastNameContainer, Localize(@"register.lastName"));
    lastNameField.keyboardType = UIKeyboardTypeDefault;
    
    phoneField = createField(self.phoneContainer, Localize(@"register.phone"));
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    
    passwordField = createField(self.passwordContainer, Localize(@"register.password"));
    passwordField.secure = YES;
    passwordConfirmField = createField(self.passwordConfirmContainer, Localize(@"register.passwordConfirm"));
    passwordConfirmField.secure = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.observeKeyboardEvents = YES;
    // load email
    emailField.text = self.email;
    // focus first name
    [firstNameField becomeFirstResponder];
}

- (void)localize {
    self.promptLabel.text = Localize(@"register.step1.prompt");
    [self.submitButton setTitle:[Localize(@"register.submit") uppercaseString]
     forState:UIControlStateNormal];
}

- (void)observeKeyboardWillShowNotification:(NSNotification *)notification {
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, rect.size.height, 0);
}

- (void)observeKeyboardWillHideNotification:(NSNotification *)notification {
    self.scrollView.contentInset = UIEdgeInsetsZero;
}


#pragma mark - Private

- (BOOL)canProceed {
//    BOOL isValidEmail = [LWValidator validateEmail:emailField.text];
//    BOOL isValidPhone = [LWValidator validatePhone:phoneField.text];
//    BOOL isValidPassword = ((passwordField.text.length > 0)
//                            && [passwordField.text isEqualToString:passwordConfirmField.text]);
    
    return YES;//(isValidEmail && isValidPassword);
}


#pragma mark - Actions

- (IBAction)submitButtonClick:(id)sender {
    if ([self canProceed]) {
        [self setLoading:YES];
        
        LWRegistrationData *data = [LWRegistrationData new];
        data.email = emailField.text;
        data.firstName = firstNameField.text;
        data.lastName = lastNameField.text;
        data.phone = phoneField.text;
        data.password = passwordField.text;
        
        [[LWAuthManager instance] requestRegistration:data];
    }
}


#pragma mark - LWAuthManagerDelegate

- (void)authManagerDidRegister:(LWAuthManager *)manager {
    [[LWAuthManager instance] requestDocumentsToUpload];
}

- (void)authManager:(LWAuthManager *)manager didCheckDocumentsStatus:(LWDocumentsStatus *)status {
    [self setLoading:NO];
    
    if (status.documentTypeRequired != nil) {
        // navigate to selfie camera presenter
        [((LWAuthNavigationController *)self.navigationController)
         navigateToStep:LWAuthStepRegisterSelfie
         preparationBlock:nil];
    }
    else {
        // navigate to verification
        // ...
    }
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self showReject:reject];
}

@end
