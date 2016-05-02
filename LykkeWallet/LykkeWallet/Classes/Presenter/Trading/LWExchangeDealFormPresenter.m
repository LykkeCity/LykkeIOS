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
#import "LWAssetPairModel.h"
#import "LWAssetModel.h"
#import "LWAssetPairRateModel.h"
#import "LWCache.h"
#import "LWUtils.h"
#import "LWMath.h"
#import "LWConstants.h"
#import "LWValidator.h"
#import "LWFingerprintHelper.h"
#import "UIColor+Generic.h"
#import "UIViewController+Navigation.h"
#import "UIViewController+Loading.h"
#import "UITextField+Validation.h"
#import "NSString+Utils.h"


@interface LWExchangeDealFormPresenter () <UITextFieldDelegate, LWExchangeConfirmationViewDelegate> {
    
    LWExchangeConfirmationView *confirmationView;
    UITextField                *sumTextField;
    
    BOOL      isVolumeValid;
    NSString *volumeString;
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UIButton           *buyButton;
@property (weak, nonatomic) IBOutlet UILabel            *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;


#pragma mark - Utils

- (void)updateTitle;
- (void)updateDescription;
- (void)updatePrice;
- (NSNumber *)volumeFromField;
- (void)validateUser;
- (void)showConfirmationView;
- (NSString *)totalString;

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
    
    NSAssert(self.assetDealType != LWAssetDealTypeUnknown, @"Incorrect deal type!");
    
    [self updateTitle];
    [self updateDescription];
    
    [self setHideKeyboardOnTap:NO]; // gesture recognizer deletion
    
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
        sumCell.assetLabel.text = [LWUtils baseAssetTitle:self.assetPair];

        sumTextField = sumCell.sumTextField;
        sumTextField.delegate = self;
        sumTextField.placeholder = Localize(@"exchange.assets.buy.placeholder");
        sumTextField.keyboardType = UIKeyboardTypeDecimalPad;

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
        totalCell.assetLabel.text = [LWUtils quotedAssetTitle:self.assetPair];
    }
    
    return cell;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [textField isNumberValidForRange:range replacementString:string];
}

- (void)textFieldDidChange:(UITextField *)sender {
    [self volumeChanged:sender.text withValidState:[sender isNumberValid]];
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
                                              rate:self.assetRate.bid];
    }
}

- (void)volumeChanged:(NSString *)volume withValidState:(BOOL)isValid {
    isVolumeValid = isValid;
    if (isVolumeValid) {
        volumeString = volume;
        [self updatePrice];
    }
    else {
        self.descriptionLabel.text = @"";
    }
    
    [LWValidator setButton:self.buyButton enabled:isValid];
}


#pragma mark - Utils

- (void)updateTitle {
    NSString *operation = (self.assetDealType == LWAssetDealTypeBuy)
    ? Localize(@"exchange.assets.buy.title")
    : Localize(@"exchange.assets.sell.title");
    
    self.title = [NSString stringWithFormat:@"%@%@",
                  operation,
                  [LWUtils baseAssetTitle:self.assetPair]];
}

- (void)updateDescription {
    
    if (!volumeString || [volumeString isEqualToString:@""]) {
        self.descriptionLabel.text = @"";
        return;
    }
    else if (!isVolumeValid) {
        self.descriptionLabel.text = @"";
        return;
    }
    
    // operation type
    NSString *operation = (self.assetDealType == LWAssetDealTypeBuy)
    ? Localize(@"exchange.assets.description.buy")
    : Localize(@"exchange.assets.description.sell");
    
    // build description
    NSString *description = [NSString stringWithFormat:operation,
                             volumeString,
                             [LWUtils baseAssetTitle:self.assetPair],
                             [self totalString],
                             [LWUtils quotedAssetTitle:self.assetPair]];
    
    self.descriptionLabel.text = description;
}

- (void)updatePrice {
    
    if (!self.assetRate) {
        return;
    }
    
    // update price cell
    LWAssetBuyPriceTableViewCell *priceCell = (LWAssetBuyPriceTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    NSString *priceText = nil;
    if (self.assetDealType == LWAssetDealTypeBuy) {
        priceText = [LWUtils priceForAsset:self.assetPair forValue:self.assetRate.ask];
    }
    else {
        priceText = [LWUtils priceForAsset:self.assetPair forValue:self.assetRate.bid];
    }
    priceCell.priceLabel.text = priceText;
    
    // update total cell
    LWAssetBuyTotalTableViewCell *totalCell = (LWAssetBuyTotalTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    
    NSString *totalStringValue = [self totalString];
    totalCell.totalLabel.text = totalStringValue;
    
    if (confirmationView) {
        confirmationView.rateString = priceText;
        confirmationView.volumeString = volumeString;
        confirmationView.totalString = totalStringValue;
    }
    
    [self updateDescription];
}

- (NSNumber *)volumeFromField {
    NSDecimalNumber *volume = [volumeString isEmpty] ? [NSDecimalNumber zero] : [LWMath numberWithString:volumeString];
    
    double const result = self.assetDealType == LWAssetDealTypeBuy ? volume.doubleValue : -volume.doubleValue;
    
    return [NSNumber numberWithDouble:result];
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

- (NSString *)totalString {
    NSString *baseAssetId = [LWCache instance].baseAssetId;
    NSDecimalNumber *decimalPrice = nil;
    if (self.assetDealType == LWAssetDealTypeBuy) {
        decimalPrice = [NSDecimalNumber decimalNumberWithDecimal:[self.assetRate.ask decimalValue]];
    }
    else {
        decimalPrice = [NSDecimalNumber decimalNumberWithDecimal:[self.assetRate.bid decimalValue]];
    }
    NSDecimalNumber *volume = [volumeString isEmpty] ? [NSDecimalNumber zero] : [LWMath numberWithString:volumeString];
    
    NSDecimalNumber *result = [NSDecimalNumber zero];
    if ([baseAssetId isEqualToString:self.assetPair.baseAssetId]) {
        if (![LWMath isDecimalEqualToZero:decimalPrice]) {
            result = [volume decimalNumberByDividingBy:decimalPrice];
        }
    }
    else {
        result = [volume decimalNumberByMultiplyingBy:decimalPrice];
    }
    
    NSInteger const accuracy = self.assetPair.accuracy.integerValue;
    NSNumber *number = [NSNumber numberWithDouble:result.doubleValue];
    NSString *totalText = [LWMath historyPriceString:number
                                           precision:accuracy
                                          withPrefix:@""];
    return totalText;
}

@end
