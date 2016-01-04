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
#import "LWAuthNavigationController.h"
#import "LWWalletFormPresenter.h"


#define emptyCellIdentifier @"LWWalletEmptyTableViewCellIdentifier"
#define equityCellIdentifier @"LWEquityTableViewCellIdentifier"


static NSInteger const kSectionLykkeWallets = 0;
static NSInteger const kSectionBankCards    = 1;

@interface LWWalletsPresenter ()<UITableViewDelegate, UITableViewDataSource, LWWalletTableViewCellDelegate> {
    
    NSMutableIndexSet *expandedSections;
    
}


#pragma mark - Properties

@property (readonly, nonatomic) LWLykkeWalletsData *data;

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
    @"LYKKE", @"VISA/MASTERCARD", @"PAYPAL", @"WEBMONEY", @"MONETAS", @"QIWI"
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[LWAuthManager instance] requestLykkeWallets];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([expandedSections containsIndex:section] && self.data)
    {
        int const rowCell = 1;
        if (section == kSectionLykkeWallets &&
            self.data.lykkeData && self.data.lykkeData.assets) {
            int const equityCell = 1;
            return MAX(1, self.data.lykkeData.assets.count + equityCell) + rowCell;
        }
        else if (section == kSectionBankCards && self.data.bankCards) {
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
        
        wallet.delegate = self;
        wallet.walletLabel.text = WalletNames[indexPath.section];
        wallet.walletImageView.image = [UIImage imageNamed:WalletIcons[indexPath.section]];
    }
    // Show wallets for category
    else {
        NSString *identifier = WalletIdentifiers[indexPath.section];
        // Lykke cells
        if (indexPath.section == kSectionLykkeWallets) {
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
        else if (indexPath.section == kSectionBankCards) {
            if (self.data && self.data.bankCards) {
                // Show Banks Wallets
                if (self.data.bankCards.count > 0) {
                    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    LWBanksTableViewCell *lykke = (LWBanksTableViewCell *)cell;
                    LWBankCardsData *card = (LWBankCardsData *)self.data.bankCards[indexPath.row - 1];
#warning TODO: show card type
                    lykke.cardNameLabel.text = @"Visa";
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


#pragma mark - LWBanksTableViewCellDelegate

- (void)addWalletClicked:(LWBanksTableViewCell *)cell {
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    if (path && path.section == kSectionBankCards) {
        LWWalletFormPresenter *form = [LWWalletFormPresenter new];
        form.bankCards = self.data.bankCards;
        [self.navigationController pushViewController:form animated:YES];
    }
}

@end
