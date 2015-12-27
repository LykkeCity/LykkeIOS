//
//  LWWalletsPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 08.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWWalletsPresenter.h"
#import "LWAuthManager.h"
#import "LWLykkeWalletsData.h"
#import "LWLykkeData.h"
#import "LWLykkeAssetsData.h"
#import "LWBankCardsData.h"
#import "LWWalletTableViewCell.h"


@interface LWWalletsPresenter ()<UITableViewDelegate, UITableViewDataSource,LWAuthManagerDelegate> {
    
}

@property (readonly, nonatomic) LWLykkeWalletsData *data;

@end


@implementation LWWalletsPresenter

static NSString *const WalletNames[] = { @"LYKKE WALLET", @"VISA/MASTERCARD", @"PAYPAL", @"WEBMONEY", @"MONETAS", @"QIWI" };

static NSString *const WalletIcons[] = { @"WalletLykke", @"WalletBanks", @"WalletPaypal", @"WalletWebmoney", @"WalletMonetas", @"WalletQiwi" };

static NSString *cellIdentifier = @"LWWalletTableViewCellIdentifier";


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"tab.wallets");
    
    UINib *nib = [UINib nibWithNibName:@"LWWalletTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //management
    [LWAuthManager instance].delegate = self;
    
    [[LWAuthManager instance] requestLykkeWallets];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // lykke
    // bank cards
    // paypal
    // webmoney
    // monetas
    // qiwi
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
/*
    if (self.data) {
// In the future
        if (section == 0) {
            return (self.data.lykkeData && self.data.lykkeData.assets
                    ? self.data.lykkeData.assets.count : 0);
        }
        else if (section == 1) {
            return (self.data.bankCards ? self.data.bankCards.count : 0);
        }

        return 1;
    }
*/
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LWWalletTableViewCell *cell = (LWWalletTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = (LWWalletTableViewCell *)[[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellIdentifier];
    }
    
    cell.walletLabel.text = WalletNames[indexPath.section];
    cell.walletImageView.image = [UIImage imageNamed:WalletIcons[indexPath.section]];
    cell.expandImageView.image = [UIImage imageNamed:@"ExpandIcon"];
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didReceiveLykkeData:(LWLykkeWalletsData *)data {
    _data = data;
    
    [self.tableView reloadData];
}

@end
