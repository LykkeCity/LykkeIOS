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
#import "UIViewController+Loading.h"
#import "UIViewController+Navigation.h"


@interface LWHistoryPresenter () {
    
}


#pragma mark - Properties

@property (readonly, nonatomic) NSDictionary *operations;


#pragma mark - Utils

- (void)updateCell:(LWHistoryTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

@end


@implementation LWHistoryPresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"tab.history");
    
    [self registerCellWithIdentifier:kHistoryTableViewCellIdentifier
                             forName:kHistoryTableViewCell];
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
    return self.operations ? self.operations.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [[self.operations allKeys] objectAtIndex:section];
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
    
    [self setLoading:NO];
    [self.tableView reloadData];
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self showReject:reject];
}


#pragma mark - Utils

- (void)updateCell:(LWHistoryTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSString *key = [[self.operations allKeys] objectAtIndex:indexPath.section];
    if (cell && key) {
        NSSet *items = self.operations[key];
        LWBaseHistoryItemType *item = (LWBaseHistoryItemType *)([[items allObjects] objectAtIndex:indexPath.row]);
        if (item) {
#warning TODO: get image from server
            if (item.historyType == LWHistoryItemTypeMarket) {
                LWMarketHistoryItemType *market = (LWMarketHistoryItemType *)item;
                cell.operationImageView.image = [UIImage imageNamed:@"WalletLykke"];
                cell.typeLabel.text = market.orderType;
            }
            else {
                LWCashInOutHistoryItemType *cash = (LWCashInOutHistoryItemType *)item;
                cell.operationImageView.image = [UIImage imageNamed:@"WalletBanks"];
                cell.typeLabel.text = @"Cash";
            }
            
            cell.dateLabel.text = item.dateTime;
            cell.valueLabel.text = @"2";
        }
    }
}

@end
