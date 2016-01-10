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
#import "UIViewController+Loading.h"
#import "UIViewController+Navigation.h"


@interface LWHistoryPresenter () {
    
}


#pragma mark - Properties

@property (readonly, nonatomic) LWTransactionsModel *data;

@end


@implementation LWHistoryPresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"history.title");
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    return cell;
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didReceiveTransactions:(LWTransactionsModel *)transactions {
    _data = transactions;
    
    [self setLoading:NO];
    [self.tableView reloadData];
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self showReject:reject];
}

@end
