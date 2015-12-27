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
#import "LWLykkeTableViewCell.h"
#import "LWBanksTableViewCell.h"
#import "LWEquityTableViewCell.h"

#define emptyCellIdentifier @"LWWalletEmptyTableViewCellIdentifier"
#define equityCellIdentifier @"LWEquityTableViewCellIdentifier"


@interface LWWalletsPresenter ()<UITableViewDelegate, UITableViewDataSource,LWAuthManagerDelegate> {
    
    NSMutableIndexSet *expandedSections;
    
}


#pragma mark - Properties

@property (readonly, nonatomic) LWLykkeWalletsData *data;


#pragma mark - Utils

- (void)registerCellWithIdentifier:(NSString *)identifier forName:(NSString *)name;

@end


@implementation LWWalletsPresenter

static NSInteger const kNumberOfSections = 6;
static NSString *cellIdentifier = @"LWWalletTableViewCellIdentifier";

static NSString *const WalletIdentifiers[kNumberOfSections] = {
    @"LWLykkeTableViewCellIdentifier", @"LWBanksTableViewCellIdentifier",
    
    emptyCellIdentifier,
    emptyCellIdentifier,
    emptyCellIdentifier,
    emptyCellIdentifier
};

static NSString *const WalletNames[kNumberOfSections] = {
    @"LYKKE WALLET", @"VISA/MASTERCARD", @"PAYPAL", @"WEBMONEY", @"MONETAS", @"QIWI"
};

static NSString *const WalletIcons[kNumberOfSections] = {
    @"WalletLykke", @"WalletBanks", @"WalletPaypal", @"WalletWebmoney", @"WalletMonetas", @"WalletQiwi"
};


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localize(@"tab.wallets");
    
    expandedSections = [[NSMutableIndexSet alloc] init];
    
    [self registerCellWithIdentifier:cellIdentifier
                             forName:@"LWWalletTableViewCell"];
    
    [self registerCellWithIdentifier:WalletIdentifiers[0]
                             forName:@"LWLykkeTableViewCell"];
    
    [self registerCellWithIdentifier:WalletIdentifiers[1]
                             forName:@"LWBanksTableViewCell"];
    
    [self registerCellWithIdentifier:emptyCellIdentifier
                             forName:@"LWWalletEmptyTableViewCell"];
    
    [self registerCellWithIdentifier:equityCellIdentifier
                             forName:@"LWEquityTableViewCell"];
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
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
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([expandedSections containsIndex:section] && self.data)
    {
        int const rowCell = 1;
        if (section == 0 && self.data.lykkeData && self.data.lykkeData.assets) {
            int const equityCell = 1;
            return MAX(1, self.data.lykkeData.assets.count + equityCell) + rowCell;
        }
        else if (section == 1 && self.data.bankCards) {
            return MAX(1, self.data.bankCards.count) + rowCell;
        }
        else {
            return 2;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    // Show category row
    if (!indexPath.row) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        LWWalletTableViewCell *wallet = (LWWalletTableViewCell *)cell;
        if (wallet == nil)
        {
            wallet = (LWWalletTableViewCell *)[[UITableViewCell alloc]
                                    initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:cellIdentifier];
        }
        
        wallet.walletLabel.text = WalletNames[indexPath.section];
        wallet.walletImageView.image = [UIImage imageNamed:WalletIcons[indexPath.section]];
        wallet.expandImageView.image = [UIImage imageNamed:@"ExpandIcon"];
    }
    // Show wallets for category
    else {
        NSString *identifier = WalletIdentifiers[indexPath.section];
        // Lykke cells
        if (indexPath.section == 0) {
            if (self.data && self.data.lykkeData && self.data.lykkeData.assets) {
                // Show Lykke Wallets
                if (self.data.lykkeData.assets.count > 0) {
                    // Show Equity cell
                    if (indexPath.row == self.data.lykkeData.assets.count + 1) {
                        cell = [tableView dequeueReusableCellWithIdentifier:equityCellIdentifier];
                        LWEquityTableViewCell *equity = (LWEquityTableViewCell *)cell;
                        equity.equityValueLabel.text = [NSString stringWithFormat:@"%@", self.data.lykkeData.equity];
                    } else {
                        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                        LWLykkeTableViewCell *lykke = (LWLykkeTableViewCell *)cell;
                        LWLykkeAssetsData *asset = (LWLykkeAssetsData *)self.data.lykkeData.assets[indexPath.row - 1];
                        lykke.walletNameLabel.text = asset.name;
                        lykke.walletBalanceLabel.text = [NSString stringWithFormat:@"%@ %@", asset.symbol, asset.balance];
                    }
                }
                // Show Empty
                else {
                    cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
                }
            }
        }
        // Banks cells
        else if (indexPath.section == 1) {
            if (self.data && self.data.bankCards) {
                // Show Banks Wallets
                if (self.data.bankCards.count > 0) {
                    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    LWBanksTableViewCell *lykke = (LWBanksTableViewCell *)cell;
                    LWBankCardsData *card = (LWBankCardsData *)self.data.bankCards[indexPath.row - 1];
                    lykke.cardNameLabel.text = card.type;
                    lykke.cardDigitsLabel.text = [NSString stringWithFormat:@".... %@", card.lastDigits];
                }
                // Show Empty
                else {
                    cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
                }
            }
        }
        // Show empty cells
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
        }
    }
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // only first row toggles exapand/collapse
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    BOOL currentlyExpanded = [expandedSections containsIndex:section];
    NSInteger rows = 0;
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    if (currentlyExpanded)
    {
        rows = [self tableView:tableView numberOfRowsInSection:section];
        [expandedSections removeIndex:section];
    }
    else
    {
        [expandedSections addIndex:section];
        rows = [self tableView:tableView numberOfRowsInSection:section];
    }
    
    for (int i = 1; i < rows; i++)
    {
        NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i
                                                       inSection:section];
        [tmpArray addObject:tmpIndexPath];
    }
    
    if (currentlyExpanded)
    {
        [tableView deleteRowsAtIndexPaths:tmpArray
                         withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        [tableView insertRowsAtIndexPaths:tmpArray
                         withRowAnimation:UITableViewRowAnimationTop];
    }
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didReceiveLykkeData:(LWLykkeWalletsData *)data {
    _data = data;
    
    [self.tableView reloadData];
}


#pragma mark - Utils

- (void)registerCellWithIdentifier:(NSString *)identifier forName:(NSString *)name {
    UINib *nib = [UINib nibWithNibName:name bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}

@end
