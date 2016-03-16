//
//  LWExchangeEmptyBlockchainPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 16.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeEmptyBlockchainPresenter.h"
#import "LWLeftDetailTableViewCell.h"
#import "LWExchangeInfoModel.h"
#import "LWAssetModel.h"
#import "LWConstants.h"
#import "LWCache.h"
#import "LWMath.h"
#import "UIViewController+Navigation.h"

@interface LWExchangeEmptyBlockchainPresenter () {
    UIRefreshControl *refreshControl;
}

#pragma mark - Utils

- (void)updateTitleCell:(LWLeftDetailTableViewCell *)cell row:(NSInteger)row;
- (void)updateValueCell:(LWLeftDetailTableViewCell *)cell row:(NSInteger)row;

@end


@implementation LWExchangeEmptyBlockchainPresenter

static int const kNumberOfRows = 7;
static int const kBlockchainRow = 5;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *base = [LWAssetModel
                      assetByIdentity:self.asset
                      fromList:[LWCache instance].baseAssets];
    
    NSString *type = (self.model.volume.intValue >= 0
                      ? Localize(@"history.market.buy")
                      : Localize(@"history.market.sell"));
    self.title = [NSString stringWithFormat:@"%@ %@", base, type];
    

    [self registerCellWithIdentifier:kLeftDetailTableViewCellIdentifier
                                name:kLeftDetailTableViewCell];
    
    [self setBackButton];
    [self setRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setHideKeyboardOnTap:NO]; // gesture recognizer deletion
}

- (void)setRefreshControl
{
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(updateStatus)
             forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
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
    NSString *rate = [LWMath makeStringByNumber:self.model.price
                                  withPrecision:self.model.accuracy.integerValue];
    
    NSString *volume = [LWMath makeStringByNumber:self.model.volume
                                    withPrecision:0];
    
    NSString *commission = [LWMath makeStringByNumber:self.model.commission withPrecision:2];
    
    NSString *total = [LWMath makeStringByNumber:self.model.totalCost withPrecision:2];
    
    NSString *position = [LWMath makeStringByNumber:self.model.position withPrecision:0];
    
    NSString *blockchain = self.model.blockchainSettled
    ? self.model.blockchainId
    : Localize(@"exchange.assets.result.blockchain.progress");
    
    NSString *const values[kNumberOfRows] = {
        self.model.assetPair,
        volume,
        rate,
        commission,
        total,
        blockchain,
        position
    };
    
    cell.detailLabel.text = values[row];
    if (kBlockchainRow == row) {
        UIColor *blockchainColor = self.model.blockchainSettled
        ? [UIColor colorWithHexString:kMainElementsColor]
        : [UIColor colorWithHexString:kMainDarkElementsColor];
        [cell.detailLabel setTextColor:blockchainColor];
    }
}

- (void)updateStatus {
#warning TODO:
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [refreshControl endRefreshing];
    
    //[self showReject:reject response:context.task.response code:context.error.code willNotify:YES];
}

@end
