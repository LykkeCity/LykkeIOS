//
//  LWExchangeDealFormPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 06.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeDealFormPresenter.h"
#import "LWExchangeResultPresenter.h"
#import "LWAssetBuySumTableViewCell.h"
#import "LWAssetBuyPriceTableViewCell.h"
#import "LWAssetBuyTotalTableViewCell.h"
#import "LWExchangeConfirmationView.h"
#import "LWExchangePinConfirmation.h"
#import "LWAssetPairModel.h"
#import "LWAssetPairRateModel.h"
#import "LWCache.h"
#import "LWMath.h"
#import "LWConstants.h"
#import "UIColor+Generic.h"
#import "UIViewController+Navigation.h"
#import "UIViewController+Loading.h"
#import "UITextField+Validation.h"
#import "NSString+Utils.h"


@interface LWExchangeDealFormPresenter () <UITextFieldDelegate, UITextFieldDelegate, LWExchangeConfirmationViewDelegate, LWExchangePinConfirmationDelegate> {

    LWExchangeConfirmationView *confirmationView;
    UITextField                *sumTextField;
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UIButton           *buyButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


#pragma mark - Utils

- (void)updatePrice;
- (NSNumber *)volumeFromField;

@end


@implementation LWExchangeDealFormPresenter


static NSInteger const kFormRows = 3;

static NSString *const FormIdentifiers[kFormRows] = {
    @"LWAssetBuySumTableViewCellIdentifier",
    @"LWAssetBuyPriceTableViewCellIdentifier",
    @"LWAssetBuyTotalTableViewCellIdentifier"
};


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@%@", Localize(@"exchange.assets.buy.title"), self.assetPair.name];
    
    [self setHideKeyboardOnTap:NO]; // gesture recognizer deletion
    
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
        //[sumTextField becomeFirstResponder];
        [sumTextField setTintColor:[UIColor colorWithHexString:kMainElementsColor]];
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
    if (confirmationView) {
        [confirmationView setLoading:NO];
        [confirmationView removeFromSuperview];
        LWExchangeResultPresenter *controller = [LWExchangeResultPresenter new];
        controller.purchase = purchase;
        controller.assetPair = self.assetPair;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    if (confirmationView) {
        [confirmationView setLoading:NO];
        [self showReject:reject];
        [confirmationView removeFromSuperview];
    }
}


#pragma mark - Actions

- (IBAction)purchaseClicked:(id)sender {
    
    [self.view endEditing:YES];
    
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


#pragma mark - LWExchangeConfirmationViewDelegate

- (void)cancelClicked {
    if (sumTextField) {
        [sumTextField becomeFirstResponder];
    }
    confirmationView = nil;
}

- (void)requestOperation {
    [self.view endEditing:YES];
    
    [[LWAuthManager instance] requestPurchaseAsset:[LWCache instance].baseAssetId
                                         assetPair:self.assetPair.identity
                                            volume:[self volumeFromField]
                                              rate:self.assetRate.ask];
}

- (void)validatePin {
    LWExchangePinConfirmation *validator = [LWExchangePinConfirmation new];
    validator.delegate = self;
    [self.navigationController pushViewController:validator animated:YES];
}


#pragma mark - LWExchangePinConfirmationDelegate

- (void)pinConfirmed {
    if (confirmationView) {
        [confirmationView requestOperation];
    }
}

- (void)pinRejected {
    // do nothing - pin incorrect
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
    NSDecimalNumber *volume = [sumTextField.text isEmpty] ? [NSDecimalNumber zero] : [LWMath numberWithString:sumTextField.text];
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
    NSDecimalNumber *volume = [sumTextField.text isEmpty] ? [NSDecimalNumber zero] : [LWMath numberWithString:sumTextField.text];
    return [NSNumber numberWithInt:volume.intValue];
}

@end
