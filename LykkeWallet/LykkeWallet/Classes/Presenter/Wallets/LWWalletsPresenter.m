//
//  LWWalletsPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 08.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWWalletsPresenter.h"
#import "LWAuthManager.h"


@interface LWWalletsPresenter ()<UITableViewDelegate, UITableViewDataSource,LWAuthManagerDelegate> {
    
}

@property (strong, nonatomic) NSArray *wallets;

@end


@implementation LWWalletsPresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"tab.wallets");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //management
    [LWAuthManager instance].delegate = self;
    
    [[LWAuthManager instance] requestLykkeWallets];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.wallets ? self.wallets.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }

#warning TODO: make class for wallet item
    id wallet = [self.wallets objectAtIndex:indexPath.row];
    [cell.textLabel setText:[wallet objectForKey:@"Name"]];
    
    return cell;
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didReceiveLykkeWallets:(NSArray *)wallets {
    _wallets = wallets;
    
    [self.tableView reloadData];
}

@end
