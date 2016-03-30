//
//  LWWithdrawInputPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 31.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWWithdrawInputPresenter.h"
#import "LWAuthNavigationController.h"
#import "LWMathKeyboardView.h"
#import "LWAssetBuySumTableViewCell.h"
#import "LWConstants.h"
#import "LWCache.h"
#import "TKButton.h"
#import "UIViewController+Loading.h"
#import "UIViewController+Navigation.h"


@interface LWWithdrawInputPresenter () <UITextFieldDelegate, LWMathKeyboardViewDelegate> {
    
    LWMathKeyboardView *mathKeyboardView;
    
    //LWExchangeConfirmationView *confirmationView;
    UITextField *sumTextField;
}

@property (weak, nonatomic) IBOutlet TKButton *operationButton;

@end


@implementation LWWithdrawInputPresenter


static NSInteger const kFormRows = 1;

static NSString *const FormIdentifiers[kFormRows] = {
    @"LWAssetBuySumTableViewCellIdentifier"
};

- (void)viewDidLoad {
    [super viewDidLoad];

    //[self updateTitle];
    //[self updateDescription];
    
    [self setHideKeyboardOnTap:NO]; // gesture recognizer deletion
    
    mathKeyboardView = [LWMathKeyboardView new]; // init math numpad
    mathKeyboardView.delegate = self;
    [mathKeyboardView updateView];
    //[self updateKeyboardFrame];
    
    //volumeString = @"";
    //[self volumeChanged:volumeString withValidState:NO];
    
    [self registerCellWithIdentifier:@"LWAssetBuySumTableViewCellIdentifier"
                                name:@"LWAssetBuySumTableViewCell"];

    [self.operationButton setTitle:Localize(@"withdraw.funds.proceed")
                          forState:UIControlStateNormal];
    
    [self setBackButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.observeKeyboardEvents = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (sumTextField) {
        [sumTextField becomeFirstResponder];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kFormRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = FormIdentifiers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.row == 0) {
        LWAssetBuySumTableViewCell *sumCell = (LWAssetBuySumTableViewCell *)cell;
        sumCell.titleLabel.text = Localize(@"exchange.assets.buy.sum");
        
        sumTextField = sumCell.sumTextField;
        sumTextField.delegate = self;
        sumTextField.placeholder = Localize(@"exchange.assets.buy.placeholder");
        sumTextField.inputView = mathKeyboardView;
        //sumTextField.inputView.autoresizingMask = UIViewAutoresizingNone;
        
        mathKeyboardView.targetTextField = sumTextField;
        
        //[sumTextField becomeFirstResponder];
        [sumTextField setTintColor:[UIColor colorWithHexString:kDefaultTextFieldPlaceholder]];
        [sumTextField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    }
    
    return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger const maxLength = 12;
//    return [textField shouldChangeCharactersInRange:range replacementString:string forMaxLength:maxLength];
    return YES;
}

- (void)textFieldDidChange:(id)sender {
//    [self updatePrice];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    
    [self setLoading:NO];
    
//    if (confirmationView) {
//        [confirmationView setLoading:NO withReason:@""];
        [self showReject:reject response:context.task.response code:context.error.code willNotify:YES];
        
//        [confirmationView removeFromSuperview];
//    }
}


#pragma mark - Actions

- (IBAction)purchaseClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    // if fingerprint available - show confirmation view
    BOOL const shouldSignOrder = [LWCache instance].shouldSignOrder;
    if (shouldSignOrder) {
//        [self validateUser];
    }
    else {
//        [self showConfirmationView];
    }
}


#pragma mark - LWExchangeConfirmationViewDelegate

- (void)checkPin:(NSString *)pin {
    //if (confirmationView) {
    //    [confirmationView setLoading:YES withReason:Localize(@"exchange.assets.modal.validatepin")];
    //    [[LWAuthManager instance] requestPinSecurityGet:pin];
    //}
}

- (void)noAttemptsForPin {
    [(LWAuthNavigationController *)self.navigationController logout];
}

- (void)cancelClicked {
    if (sumTextField) {
        [sumTextField becomeFirstResponder];
    }
    //confirmationView = nil;
}

- (void)requestOperationWithHud:(BOOL)isHudActivated {
    [self.view endEditing:YES];
    
    if (isHudActivated) {
        [self setLoading:YES];
    }
}


#pragma mark - LWMathKeyboardViewDelegate

- (void)mathKeyboardViewDidRaiseMathException:(LWMathKeyboardView *)view {
    UIAlertController *ctrl = [UIAlertController alertControllerWithTitle:Localize(@"exchange.assets.modal.error") message:Localize(@"exchange.assets.modal.error.volume") preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:Localize(@"exchange.assets.modal.error.ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [ctrl dismissViewControllerAnimated:YES completion:nil];
    }];
    [ctrl addAction:actionOK];
    
    [self presentViewController:ctrl animated:YES completion:nil];
}

- (void)volumeChanged:(NSString *)volume withValidState:(BOOL)isValid {
    if (isValid) {
        //volumeString = volume;
        //[self updatePrice];
    }
    
    //[LWValidator setButton:self.buyButton enabled:isValid];
}


@end
