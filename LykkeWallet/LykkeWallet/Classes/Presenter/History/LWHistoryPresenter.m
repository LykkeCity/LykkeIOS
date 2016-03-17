//
//  LWHistoryPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 19.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWHistoryPresenter.h"
#import "LWCashEmptyBlockchainPresenter.h"
#import "LWExchangeEmptyBlockchainPresenter.h"
#import "LWHistoryTableViewCell.h"
#import "LWAuthManager.h"
#import "LWTransactionsModel.h"
#import "LWAssetBlockchainModel.h"
#import "LWExchangeInfoModel.h"
#import "LWAssetModel.h"
#import "LWHistoryManager.h"
#import "LWBaseHistoryItemType.h"
#import "LWCashInOutHistoryItemType.h"
#import "LWTradeHistoryItemType.h"
#import "LWConstants.h"
#import "LWMath.h"
#import "LWCache.h"
#import "UIViewController+Loading.h"
#import "UIViewController+Navigation.h"
#import "NSDate+String.h"


@interface LWHistoryPresenter () {
    UIRefreshControl *refreshControl;
}


#pragma mark - Properties

@property (strong,   nonatomic) NSIndexPath  *loadedElement;
@property (readonly, nonatomic) NSDictionary *operations;
@property (readonly, nonatomic) NSArray      *sortedKeys;

#pragma mark - Utils

- (void)updateCell:(LWHistoryTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)setRefreshControl;
- (void)reloadHistory;
- (LWBaseHistoryItemType *)getHistoryItemByIndexPath:(NSIndexPath *)indexPath;

@end


@implementation LWHistoryPresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadedElement = nil;
    self.navigationItem.title = Localize(@"tab.history");
    
    [self registerCellWithIdentifier:kHistoryTableViewCellIdentifier
                             forName:kHistoryTableViewCell];
    
    [self setRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.shouldGoBack) {
        [self setBackButton];
    }
    
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
    
    [refreshControl endRefreshing];

    [self setLoading:NO];
    [self.tableView reloadData];
}

- (void)authManager:(LWAuthManager *)manager didGetBlockchainCashTransaction:(LWAssetBlockchainModel *)blockchain {
    [self setLoading:NO];
    
    if (blockchain) {
#warning TODO:
    }
    else {
        // need extra data - request
        LWBaseHistoryItemType *item = [self getHistoryItemByIndexPath:self.loadedElement];
        if (item) {
            LWCashEmptyBlockchainPresenter *emptyPresenter = [LWCashEmptyBlockchainPresenter new];
            LWCashInOutHistoryItemType *model = (LWCashInOutHistoryItemType *)item;
            emptyPresenter.model = [model copy];
            [self.navigationController pushViewController:emptyPresenter animated:YES];
        }
    }
}

- (void)authManager:(LWAuthManager *)manager didGetBlockchainExchangeTransaction:(LWAssetBlockchainModel *)blockchain {
    if (blockchain) {
        [self setLoading:NO];
#warning TODO:
    }
    else {
        // need extra data - request
        LWBaseHistoryItemType *item = [self getHistoryItemByIndexPath:self.loadedElement];
        if (!item) {
            [self setLoading:NO];
        }
        else {
            [[LWAuthManager instance] requestExchangeInfo:item.identity];
        }
    }
}

- (void)authManager:(LWAuthManager *)manager didReceiveExchangeInfo:(LWExchangeInfoModel *)exchangeInfo {
    [self setLoading:NO];

    // need extra data - request
    LWBaseHistoryItemType *item = [self getHistoryItemByIndexPath:self.loadedElement];
    if (item) {
        LWTradeHistoryItemType *trade = (LWTradeHistoryItemType *)item;
        LWExchangeEmptyBlockchainPresenter *presenter = [LWExchangeEmptyBlockchainPresenter new];
        presenter.model = [exchangeInfo copy];
        presenter.asset = trade.asset;
        [self.navigationController pushViewController:presenter animated:YES];
    }
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [refreshControl endRefreshing];
    
    [self showReject:reject response:context.task.response code:context.error.code willNotify:YES];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LWBaseHistoryItemType *item = [self getHistoryItemByIndexPath:indexPath];
    if (!item) {
        return;
    }
    
    if (item && item.historyType == LWHistoryItemTypeTrade) {
        [self setLoading:YES];
        self.loadedElement = indexPath;
        [[LWAuthManager instance] requestBlockchainExchangeTransaction:item.identity];
    }
    else if (item && item.historyType == LWHistoryItemTypeCashInOut) {
        [self setLoading:YES];
        self.loadedElement = indexPath;
        [[LWAuthManager instance] requestBlockchainCashTransaction:item.identity];
    }
}


#pragma mark - Utils

- (void)updateCell:(LWHistoryTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    LWBaseHistoryItemType *item = [self getHistoryItemByIndexPath:indexPath];
    if (!item) {
        return;
    }
    
    NSNumber *volume = [NSNumber numberWithInt:0];
    NSString *operation = @"";
    if (item.historyType == LWHistoryItemTypeTrade) {
        LWTradeHistoryItemType *trade = (LWTradeHistoryItemType *)item;
        cell.operationImageView.image = [UIImage imageNamed:@"WalletBitcoin"];
        
        volume = trade.volume;
        
        NSString *base = [LWAssetModel
                          assetByIdentity:trade.asset
                          fromList:[LWCache instance].baseAssets];
        
        NSString *type = (volume.intValue >= 0
                          ? Localize(@"history.market.buy")
                          : Localize(@"history.market.sell"));
        
        operation = [NSString stringWithFormat:@"%@ %@", base, type];
    }
    else {
        LWCashInOutHistoryItemType *cash = (LWCashInOutHistoryItemType *)item;
        cell.operationImageView.image = [UIImage imageNamed:@"WalletBitcoin"];
        volume = cash.amount;
        
        NSString *base = [LWAssetModel
                          assetByIdentity:cash.asset
                          fromList:[LWCache instance].baseAssets];
        
        NSString *type = (volume.intValue >= 0
                          ? Localize(@"history.cash.out")
                          : Localize(@"history.cash.in"));
        
        operation = [NSString stringWithFormat:@"%@ %@", base, type];
    }
    
    // prepare value label
    NSString *sign = (volume.doubleValue >= 0.0) ? @"+" : @"";
    NSString *changeString = [LWMath priceString:volume precision:[NSNumber numberWithInt:0] withPrefix:sign];
    
    UIColor *changeColor = (volume.doubleValue >= 0.0)
    ? [UIColor colorWithHexString:kAssetChangePlusColor]
    : [UIColor colorWithHexString:kAssetChangeMinusColor];
    cell.valueLabel.textColor = changeColor;
    cell.valueLabel.text = changeString;
    
    cell.typeLabel.text = operation;
    cell.dateLabel.text = [item.dateTime toShortFormat];
}

- (void)setRefreshControl {
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(reloadHistory)
             forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
}

- (void)reloadHistory {
    [[LWAuthManager instance] requestTransactions:self.assetId];
}

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

@end
