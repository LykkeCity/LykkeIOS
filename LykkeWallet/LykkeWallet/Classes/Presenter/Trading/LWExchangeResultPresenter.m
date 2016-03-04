//
//  LWExchangeResultPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 07.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeResultPresenter.h"
#import "LWExchangeBlockchainPresenter.h"
#import "LWLeftDetailTableViewCell.h"
#import "LWAssetPairModel.h"
#import "LWAssetDealModel.h"
#import "LWConstants.h"
#import "LWMath.h"
#import "LWAuthManager.h"
#import "TKButton.h"


@interface LWExchangeResultPresenter () {
    
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TKButton *closeButton;
@property (weak, nonatomic) IBOutlet TKButton *shareButton;


#pragma mark - Utils

- (void)updateTitleCell:(LWLeftDetailTableViewCell *)cell row:(NSInteger)row;
- (void)updateValueCell:(LWLeftDetailTableViewCell *)cell row:(NSInteger)row;
- (void)updateStatus;

@end


@implementation LWExchangeResultPresenter


static int const kNumberOfRows = 7;
static int const kBlockchainRow = 5;


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCellWithIdentifier:kLeftDetailTableViewCellIdentifier
                                name:kLeftDetailTableViewCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@",
                            self.purchase.assetPair,
                            Localize(@"exchange.assets.result.title")];
    
    [self.closeButton setTitle:Localize(@"exchange.assets.result.close")
                      forState:UIControlStateNormal];
    
    [self.shareButton setTitle:Localize(@"exchange.assets.result.share")
                      forState:UIControlStateNormal];
    
    [self.closeButton setGrayPalette];
    
    [self setHideKeyboardOnTap:NO]; // gesture recognizer deletion

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self updateStatus];
}

#ifdef PROJECT_IATA
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
#endif


#pragma mark - Actions

- (IBAction)closeClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kNumberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LWLeftDetailTableViewCell *cell = (LWLeftDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kLeftDetailTableViewCellIdentifier];

    [self updateTitleCell:cell row:indexPath.row];
    [self updateValueCell:cell row:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)viewDidLayoutSubviews
{
}


#pragma mark - Utils

- (void)updateTitleCell:(LWLeftDetailTableViewCell *)cell row:(NSInteger)row {
    NSString *const titles[kNumberOfRows] = {
        Localize(@"exchange.assets.result.assetname"),
        Localize(@"exchange.assets.result.units"),
        Localize(@"exchange.assets.result.price"),
        Localize(@"exchange.assets.result.commission"),
        Localize(@"exchange.assets.result.cost"),
        Localize(@"exchange.assets.result.blockchain"),
        Localize(@"exchange.assets.result.position")
    };
    cell.titleLabel.text = titles[row];
}

- (void)updateValueCell:(LWLeftDetailTableViewCell *)cell row:(NSInteger)row {
    
    NSString *rate = [LWMath makeStringByNumber:self.purchase.price
                                  withPrecision:self.assetPair.accuracy.integerValue];
    
    NSString *volume = [LWMath makeStringByNumber:self.purchase.volume
                                    withPrecision:0];
    
    NSString *commission = [LWMath makeStringByNumber:self.purchase.commission withPrecision:2];
    
    NSString *total = [LWMath makeStringByNumber:self.purchase.totalCost withPrecision:2];
    
    NSString *position = [LWMath makeStringByNumber:self.purchase.position withPrecision:0];
    
    NSString *blockchain = self.purchase.blockchainSettled
        ? self.purchase.blockchainId
        : Localize(@"exchange.assets.result.blockchain.progress");
    
    NSString *const values[kNumberOfRows] = {
        self.purchase.assetPair,
        volume,
        rate,
        commission,
        total,
        blockchain,
        position
    };
    
    cell.detailLabel.text = values[row];
    if (kBlockchainRow == row) {
        UIColor *blockchainColor = self.purchase.blockchainSettled
        ? [UIColor colorWithHexString:kMainElementsColor]
        : [UIColor colorWithHexString:kMainDarkElementsColor];
        [cell.detailLabel setTextColor:blockchainColor];
    }
}

- (void)updateStatus {
    // if blockchain is already received - finish requesting
    if (!self.purchase.blockchainSettled) {
        const NSInteger repeatSeconds = 5;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(repeatSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[LWAuthManager instance] requestMarketOrder:self.purchase.identity];
        });
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == kBlockchainRow && self.purchase
        && self.assetPair && self.purchase.blockchainSettled) {
        LWExchangeBlockchainPresenter *controller = [LWExchangeBlockchainPresenter new];
        controller.orderId = self.purchase.identity;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self updateStatus];
}

- (void)authManager:(LWAuthManager *)manager didReceiveMarketOrder:(LWAssetDealModel *)purchase {
    self.purchase = purchase;
    
    [self updateStatus];
}

@end
