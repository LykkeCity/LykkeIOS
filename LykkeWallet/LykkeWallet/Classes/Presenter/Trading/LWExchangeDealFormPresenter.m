//
//  LWExchangeDealFormPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 06.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeDealFormPresenter.h"
#import "LWAuthNavigationController.h"
#import "LWExchangeResultPresenter.h"
#import "LWAssetBuySumTableViewCell.h"
#import "LWAssetBuyPriceTableViewCell.h"
#import "LWAssetBuyTotalTableViewCell.h"
#import "LWExchangeConfirmationView.h"
#import "LWPacketPinSecurityGet.h"
#import "LWMathKeyboardView.h"
#import "LWAssetPairModel.h"
#import "LWAssetPairRateModel.h"
#import "LWCache.h"
#import "LWMath.h"
#import "LWConstants.h"
#import "LWValidator.h"
#import "LWFingerprintHelper.h"
#import "UIColor+Generic.h"
#import "UIViewController+Navigation.h"
#import "UIViewController+Loading.h"
#import "UITextField+Validation.h"
#import "NSString+Utils.h"


@interface LWExchangeDealFormPresenter () <UITextFieldDelegate, UITextFieldDelegate, LWExchangeConfirmationViewDelegate, LWMathKeyboardViewDelegate> {
    LWMathKeyboardView *mathKeyboardView;
    
    LWExchangeConfirmationView *confirmationView;
    UITextField                *sumTextField;
    
    NSString *volumeString;
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UIButton           *buyButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;


#pragma mark - Utils

- (void)updatePrice;
- (NSNumber *)volumeFromField;
- (void)updateKeyboardFrame;
- (void)validateUser;
- (void)showConfirmationView;

@end


@implementation LWExchangeDealFormPresenter


static NSInteger const kFormRows = 3;

static NSString *const FormIdentifiers[kFormRows] = {
    @"LWAssetBuySumTableViewCellIdentifier",
    @"LWAssetBuyPriceTableViewCellIdentifier",
    @"LWAssetBuyTotalTableViewCellIdentifier"
};

CGFloat const iPhone4Height      = 480;
CGFloat const iPhone5Height      = 568;
float const kSmallHeightKeyboard = 239.0;
float const kBigHeightKeyboard   = 290.0;
#ifdef PROJECT_IATA
float const kBottomSmallHeight   = 45.0;
float const kBottomBigHeight     = 45.0;
#else
float const kBottomSmallHeight   = 65.0;
float const kBottomBigHeight     = 105.0;
#endif


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(self.assetDealType != LWAssetDealTypeUnknown, @"Incorrect deal type!");
    
    NSString *title = (self.assetDealType == LWAssetDealTypeBuy)
                       ? Localize(@"exchange.assets.buy.title")
                       : Localize(@"exchange.assets.sell.title");
    self.title = [NSString stringWithFormat:@"%@%@", title, self.assetPair.name];
    
    [self setHideKeyboardOnTap:NO]; // gesture recognizer deletion
    
    mathKeyboardView = [LWMathKeyboardView new]; // init math numpad
    mathKeyboardView.delegate = self;
    [mathKeyboardView updateView];
    [self updateKeyboardFrame];
    
    volumeString = @"";
    [self volumeChanged:volumeString withValidState:NO];
    
    [self registerCellWithIdentifier:@"LWAssetBuySumTableViewCellIdentifier"
                                name:@"LWAssetBuySumTableViewCell"];
    
    [self registerCellWithIdentifier:@"LWAssetBuyPriceTableViewCellIdentifier"
                                name:@"LWAssetBuyPriceTableViewCell"];
    
    [self registerCellWithIdentifier:@"LWAssetBuyTotalTableViewCellIdentifier"
                                name:@"LWAssetBuyTotalTableViewCell"];
    
    [self.buyButton setTitle:Localize(@"exchange.assets.buy.checkout")
                    forState:UIControlStateNormal];
    
    [self setBackButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.observeKeyboardEvents = YES;
    
    [[LWAuthManager instance] requestAssetPairRate:self.assetPair.identity];

    [self updatePrice];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (sumTextField) {
        [sumTextField becomeFirstResponder];
    }
}


#pragma mark - TKPresenter

- (void)observeKeyboardWillShowNotification:(NSNotification *)notification {
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.bottomConstraint setConstant:frame.size.height];
    [self animateConstraintChanges];
}

- (void)observeKeyboardWillHideNotification:(NSNotification *)notification {
    [self.bottomConstraint setConstant:0];
    [self animateConstraintChanges];
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
    else if (indexPath.row == 1) {
        LWAssetBuyPriceTableViewCell *priceCell = (LWAssetBuyPriceTableViewCell *)cell;
        priceCell.titleLabel.text = Localize(@"exchange.assets.buy.price");
    }
    else if (indexPath.row == 2) {
        LWAssetBuyTotalTableViewCell *totalCell = (LWAssetBuyTotalTableViewCell *)cell;
        totalCell.titleLabel.text = Localize(@"exchange.assets.buy.total");
    }
    
    return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSInteger const maxLength = 12;
    return [textField shouldChangeCharactersInRange:range replacementString:string forMaxLength:maxLength];
}

- (void)textFieldDidChange:(id)sender {
    [self updatePrice];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didGetAssetPairRate:(LWAssetPairRateModel *)assetPairRate {
    
    self.assetRate = assetPairRate;
    
    [self updatePrice];
    
    const NSInteger repeatSeconds = [LWCache instance].refreshTimer.integerValue / 1000;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(repeatSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isVisible) {
            [[LWAuthManager instance] requestAssetPairRate:self.assetPair.identity];
        }
    });
}

- (void)authManager:(LWAuthManager *)manager didReceiveDealResponse:(LWAssetDealModel *)purchase {
    
    [self setLoading:NO];
    
    if (confirmationView) {
        [confirmationView setLoading:NO withReason:@""];
        [confirmationView removeFromSuperview];
    }

    LWExchangeResultPresenter *controller = [LWExchangeResultPresenter new];
    controller.purchase = purchase;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)authManager:(LWAuthManager *)manager didValidatePin:(BOOL)isValid {
    if (confirmationView) {
        if (isValid) {
            [confirmationView requestOperation];
        }
        else {
            [confirmationView pinRejected];
        }
    }
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    
    [self setLoading:NO];
    
    if (confirmationView) {
        [confirmationView setLoading:NO withReason:@""];
        [self showReject:reject response:context.task.response code:context.error.code willNotify:YES];
        
        [confirmationView removeFromSuperview];
    }
}


#pragma mark - Actions

- (IBAction)purchaseClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    // if fingerprint available - show confirmation view
    BOOL const shouldSignOrder = [LWCache instance].shouldSignOrder;
    if (shouldSignOrder) {
        [self validateUser];
    }
    else {
        [self showConfirmationView];
    }
}


#pragma mark - LWExchangeConfirmationViewDelegate

- (void)checkPin:(NSString *)pin {
    if (confirmationView) {
        [confirmationView setLoading:YES withReason:Localize(@"exchange.assets.modal.validatepin")];
        [[LWAuthManager instance] requestPinSecurityGet:pin];
    }
}

- (void)noAttemptsForPin {
    [(LWAuthNavigationController *)self.navigationController logout];
}

- (void)cancelClicked {
    if (sumTextField) {
        [sumTextField becomeFirstResponder];
    }
    confirmationView = nil;
}

- (void)requestOperationWithHud:(BOOL)isHudActivated {
    [self.view endEditing:YES];
    
    if (isHudActivated) {
        [self setLoading:YES];
    }
    
    if (self.assetDealType == LWAssetDealTypeBuy) {
        [[LWAuthManager instance] requestPurchaseAsset:[LWCache instance].baseAssetId
                                             assetPair:self.assetPair.identity
                                                volume:[self volumeFromField]
                                                  rate:self.assetRate.ask];
    }
    else {
        [[LWAuthManager instance] requestSellAsset:[LWCache instance].baseAssetId
                                         assetPair:self.assetPair.identity
                                            volume:[self volumeFromField]
                                              rate:self.assetRate.ask];
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
        volumeString = volume;
        [self updatePrice];
    }
    
    [LWValidator setButton:self.buyButton enabled:isValid];
}


#pragma mark - Utils

- (void)updatePrice {
    
    if (!self.assetRate) {
        return;
    }
    
    // update price cell
    LWAssetBuyPriceTableViewCell *priceCell = (LWAssetBuyPriceTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *priceText = [LWMath priceString:self.assetRate.ask precision:self.assetPair.accuracy withPrefix:@""];
    priceCell.priceLabel.text = priceText;
    
    // update total cell
    LWAssetBuyTotalTableViewCell *totalCell = (LWAssetBuyTotalTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NSDecimalNumber *decimalPrice = [NSDecimalNumber decimalNumberWithDecimal:[self.assetRate.ask decimalValue]];
    NSDecimalNumber *volume = [volumeString isEmpty] ? [NSDecimalNumber zero] : [LWMath numberWithString:volumeString];
    NSString *volumeText = [LWMath makeStringByDecimal:volume withPrecision:0];
    
    NSDecimalNumber *result = [decimalPrice decimalNumberByMultiplyingBy:volume];
    NSString *totalText = [LWMath makeStringByDecimal:result withPrecision:2];
    totalCell.totalLabel.text = totalText;
    
    if (confirmationView) {
        confirmationView.rateString = priceText;
        confirmationView.volumeString = volumeText;
        confirmationView.totalString = totalText;
    }
}

- (NSNumber *)volumeFromField {
    NSDecimalNumber *volume = [volumeString isEmpty] ? [NSDecimalNumber zero] : [LWMath numberWithString:volumeString];
    
    int const result = self.assetDealType == LWAssetDealTypeBuy ? volume.intValue : -volume.intValue;
    
    return [NSNumber numberWithInt:result];
}

- (void)updateKeyboardFrame {
    CGFloat const height = [[UIScreen mainScreen] bounds].size.height;
    CGRect rect = mathKeyboardView.frame;
    rect.size.height = (height > iPhone4Height) ? kBigHeightKeyboard : kSmallHeightKeyboard;
    mathKeyboardView.frame = rect;
    mathKeyboardView.autoresizingMask = UIViewAutoresizingNone;
    
    self.bottomHeightConstraint.constant = (height > iPhone5Height) ? kBottomBigHeight : kBottomSmallHeight;
}

- (void)validateUser {
    
    [LWFingerprintHelper
     validateFingerprintTitle:Localize(@"exchange.assets.modal.fingerpring")
     ok:^(void) {
         [self requestOperationWithHud:YES];
     }
     bad:^(void) {
         [self showConfirmationView];
     }
     unavailable:^(void) {
         [self showConfirmationView];
     }];
}

- (void)showConfirmationView {
    // preparing modal view
    confirmationView = [LWExchangeConfirmationView modalViewWithDelegate:self];
    confirmationView.assetPair = self.assetPair;
    [confirmationView setFrame:self.navigationController.view.bounds];
    
    // animation
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [confirmationView.layer addAnimation:transition forKey:nil];
    
    // showing modal view
    [self.navigationController.view addSubview:confirmationView];
    [self updatePrice];
}

@end
