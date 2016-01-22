//
//  LWHistoryPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 19.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWHistoryPresenter.h"
#import "LWHistoryTableViewCell.h"
#import "LWAuthManager.h"
#import "LWTransactionsModel.h"
#import "LWHistoryManager.h"
#import "LWBaseHistoryItemType.h"
#import "LWMarketHistoryItemType.h"
#import "LWCashInOutHistoryItemType.h"
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

@property (readonly, nonatomic) NSDictionary *operations;
@property (readonly, nonatomic) NSArray      *sortedKeys;

#pragma mark - Utils

- (void)updateCell:(LWHistoryTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)setRefreshControl;
- (void)reloadHistory;

@end


@implementation LWHistoryPresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"tab.history");
    
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

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [refreshControl endRefreshing];
    
    [self showReject:reject];
}


#pragma mark - Utils

- (void)updateCell:(LWHistoryTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.sortedKeys objectAtIndex:indexPath.section];
    if (cell && key) {
        NSArray *items = self.operations[key];
        LWBaseHistoryItemType *item = (LWBaseHistoryItemType *)([items objectAtIndex:indexPath.row]);
        if (item) {
            NSNumber *volume = [NSNumber numberWithInt:0];
            NSString *operation = @"";
#warning TODO: get image from server
            if (item.historyType == LWHistoryItemTypeMarket) {
                LWMarketHistoryItemType *market = (LWMarketHistoryItemType *)item;
                cell.operationImageView.image = [UIImage imageNamed:@"WalletLykke"];
                volume = market.volume;
                operation = (volume.intValue >= 0
                             ? Localize(@"history.market.sell")
                             : Localize(@"history.market.buy"));
            }
            else {
                LWCashInOutHistoryItemType *cash = (LWCashInOutHistoryItemType *)item;
                cell.operationImageView.image = [UIImage imageNamed:@"WalletBanks"];
                volume = cash.amount;
                operation = (volume.intValue >= 0
                             ? Localize(@"history.cash.in")
                             : Localize(@"history.cash.out"));
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
    }
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


@end
