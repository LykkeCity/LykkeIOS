//
//  LWTradingWalletPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 27.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWTradingWalletPresenter.h"
#import "LWBitcoinDepositPresenter.h"
#import "LWWithdrawFundsPresenter.h"
#import "LWHistoryTableViewCell.h"
#import "LWBaseHistoryItemType.h"
#import "LWTradeHistoryItemType.h"
#import "LWCashInOutHistoryItemType.h"
#import "LWAssetsDictionaryItem.h"
#import "LWHistoryManager.h"
#import "LWAuthManager.h"
#import "LWAssetModel.h"
#import "LWConstants.h"
#import "LWCache.h"
#import "LWUtils.h"
#import "LWMath.h"
#import "TKButton.h"
#import "UIViewController+Loading.h"
#import "UIViewController+Navigation.h"
#import "NSDate+String.h"


@interface LWTradingWalletPresenter () {
    
}


#pragma mark - Properties

@property (readonly, nonatomic) NSDictionary *operations;
@property (readonly, nonatomic) NSArray      *sortedKeys;


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet TKButton *withdrawButton;
@property (weak, nonatomic) IBOutlet TKButton *depositButton;


#pragma mark - Utils

- (void)updateCell:(LWHistoryTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (LWBaseHistoryItemType *)getHistoryItemByIndexPath:(NSIndexPath *)indexPath;
- (void)setImageType:(NSString *)imageType forImageView:(UIImageView *)imageView;

@end


@implementation LWTradingWalletPresenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCellWithIdentifier:kHistoryTableViewCellIdentifier
                                name:kHistoryTableViewCell];
    
    self.navigationItem.title = Localize(@"wallets.trading.title");
    [self.withdrawButton setTitle:Localize(@"wallets.trading.withdraw") forState:UIControlStateNormal];
    [self.depositButton setTitle:Localize(@"wallets.trading.deposit") forState:UIControlStateNormal];
    
#ifdef PROJECT_IATA
#else
    [self.withdrawButton setGrayPalette];
#endif
    
    [self setHideKeyboardOnTap:NO]; // gesture recognizer deletion
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setBackButton];
    
    [self setLoading:YES];
    [[LWAuthManager instance] requestTransactions:self.assetId];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sortedKeys ? self.sortedKeys.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [self.sortedKeys objectAtIndex:section];
    NSInteger const result = [self.operations[key] count];
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LWHistoryTableViewCell *cell = (LWHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kHistoryTableViewCellIdentifier];
    [self updateCell:cell indexPath:indexPath];
    
    return cell;
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didReceiveTransactions:(LWTransactionsModel *)transactions {
    _operations = [LWHistoryManager convertNetworkModel:transactions];
    _sortedKeys = [LWHistoryManager sortKeys:_operations];
    
    [self setLoading:NO];
    [self.tableView reloadData];
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self showReject:reject response:context.task.response code:context.error.code willNotify:YES];
}


#pragma mark - Utils

- (LWBaseHistoryItemType *)getHistoryItemByIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.sortedKeys objectAtIndex:indexPath.section];
    if (key) {
        NSArray *items = self.operations[key];
        if (items) {
            LWBaseHistoryItemType *item = (LWBaseHistoryItemType *)([items objectAtIndex:indexPath.row]);
            return item;
        }
    }
    return nil;
}

- (void)updateCell:(LWHistoryTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    LWBaseHistoryItemType *item = [self getHistoryItemByIndexPath:indexPath];
    if (!item) {
        return;
    }
    
    NSNumber *volume = [NSNumber numberWithInt:0];
    NSString *operation = @"";
    if (item.historyType == LWHistoryItemTypeTrade) {
        LWTradeHistoryItemType *trade = (LWTradeHistoryItemType *)item;
        [self setImageType:trade.iconId forImageView:cell.operationImageView];
        
        volume = trade.volume;
        
        NSString *base = [LWAssetModel
                          assetByIdentity:trade.asset
                          fromList:[LWCache instance].baseAssets];
        
        NSString *type = (volume.doubleValue >= 0
                          ? Localize(@"history.market.buy")
                          : Localize(@"history.market.sell"));
        
        operation = [NSString stringWithFormat:@"%@ %@", base, type];
    }
    else {
        LWCashInOutHistoryItemType *cash = (LWCashInOutHistoryItemType *)item;
        [self setImageType:cash.iconId forImageView:cell.operationImageView];
        volume = cash.amount;
        
        NSString *base = [LWAssetModel
                          assetByIdentity:cash.asset
                          fromList:[LWCache instance].baseAssets];
        
        NSString *type = (volume.doubleValue >= 0
                          ? Localize(@"history.cash.in")
                          : Localize(@"history.cash.out"));
        
        operation = [NSString stringWithFormat:@"%@ %@", base, type];
    }
    
    // prepare value label
    NSString *sign = (volume.doubleValue >= 0.0) ? @"+" : @"";
    NSInteger const precision = [LWAssetsDictionaryItem assetAccuracyById:item.asset];
    NSString *changeString = [LWMath historyPriceString:volume precision:precision withPrefix:sign];
    
    UIColor *changeColor = (volume.doubleValue >= 0.0)
    ? [UIColor colorWithHexString:kAssetChangePlusColor]
    : [UIColor colorWithHexString:kAssetChangeMinusColor];
    cell.valueLabel.textColor = changeColor;
    cell.valueLabel.text = changeString;
    
    cell.typeLabel.text = operation;
    cell.dateLabel.text = [item.dateTime toShortFormat];
}

- (void)setImageType:(NSString *)imageType forImageView:(UIImageView *)imageView {
    imageView.image = [LWUtils imageForIssuerId:imageType];
}


#pragma mark - Actions

- (IBAction)withdrawClicked:(id)sender {
    LWWithdrawFundsPresenter *presenter = [LWWithdrawFundsPresenter new];
    presenter.assetId = self.assetId;
    
    [self.navigationController pushViewController:presenter animated:YES];
}

- (IBAction)depositClicked:(id)sender {
    LWBitcoinDepositPresenter *presenter = [LWBitcoinDepositPresenter new];
    
    presenter.assetName = self.assetName;
    presenter.issuerId = self.issuerId;
    
    [self.navigationController pushViewController:presenter animated:YES];
}

@end
