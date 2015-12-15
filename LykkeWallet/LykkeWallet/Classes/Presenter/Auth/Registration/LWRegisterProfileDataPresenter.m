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
#import "MBProgressHUD.h"
#import "LWAuthNavigationController.h"


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
    // assign delegate
    [LWAuthManager instance].delegate = self;
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
        [self.view endEditing:YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.dimBackground = YES;
        hud.mode = MBProgressHUDModeIndeterminate;
        
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
    [[MBProgressHUD HUDForView:self.navigationController.view] hide:YES];
    
    if (status.isDocumentRequired) {
        // navigate to camera presenter
        LWAuthStep step = ((status.selfie)
                           ? LWAuthStepRegisterSelfie
                           : ((status.idCard)
                              ? LWAuthStepRegisterIdentity
                              : LWAuthStepRegisterUtilityBill));
        [((LWAuthNavigationController *)self.navigationController)
         navigateToStep:step
         preparationBlock:nil];
    }
    else {
        // navigate to verification
        // ...
    }
}

- (void)authManager:(LWAuthManager *)manager didFail:(NSDictionary *)reject {
    [[MBProgressHUD HUDForView:self.navigationController.view] hide:YES];
    
    NSString *message = [reject objectForKey:@"Message"];
    
    UIAlertController *ctrl = [UIAlertController
                               alertControllerWithTitle:Localize(@"utils.error")
                               message:message
                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:Localize(@"utils.ok")
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         [ctrl dismissViewControllerAnimated:YES
                                                                                  completion:nil];
                                                     }];
    [ctrl addAction:actionOK];
    [self presentViewController:ctrl animated:YES completion:nil];
}

@end
