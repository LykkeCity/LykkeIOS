//
//  LWWalletsPresenter.m
//  LykkeWallet
//
//  Created by Георгий Малюков on 08.12.15.
//  Copyright © 2015 Lykkex. All rights reserved.
//

#import "LWWalletsPresenter.h"
#import "LWHistoryPresenter.h"
#import "LWWalletFormPresenter.h"
#import "LWExchangeDealFormPresenter.h"
#import "LWWalletDepositPresenter.h"
#import "LWAuthManager.h"
#import "LWLykkeWalletsData.h"
#import "LWLykkeData.h"
#import "LWLykkeAssetsData.h"
#import "LWBankCardsData.h"
#import "LWWalletTableViewCell.h"
#import "LWLykkeTableViewCell.h"
#import "LWBanksTableViewCell.h"
#import "LWWalletsLoadingTableViewCell.h"
#import "LWAuthNavigationController.h"
#import "LWKeychainManager.h"
#import "LWConstants.h"
#import "LWCache.h"
#import "UIViewController+Loading.h"


#define emptyCellIdentifier @"LWWalletEmptyTableViewCellIdentifier"


static NSInteger const kSectionLykkeWallets = 0;
static NSInteger const kSectionBankCards    = 1;

@interface LWWalletsPresenter ()<UITableViewDelegate, UITableViewDataSource, LWWalletTableViewCellDelegate> {
    
    NSMutableIndexSet *expandedSections;
    UIRefreshControl  *refreshControl;
    
    BOOL               shouldShowError;
}


#pragma mark - Properties

@property (readonly, nonatomic) LWLykkeWalletsData *data;


#pragma mark - Utils

- (void)expandTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
- (NSString *)assetIdentifyForIndexPath:(NSIndexPath *)indexPath;
- (LWLykkeAssetsData *)assetDataForIndexPath:(NSIndexPath *)indexPath;
- (void)showDealFormForIndexPath:(NSIndexPath *)indexPath;
- (void)setRefreshControl;
- (void)reloadWallets;
- (void)showDepositPage:(NSIndexPath *)indexPath;

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
    
    self.navigationItem.title = Localize(@"tab.wallets");
    
    expandedSections = [[NSMutableIndexSet alloc] init];
    
    [self registerCellWithIdentifier:cellIdentifier
                             forName:@"LWWalletTableViewCell"];
    
    [self registerCellWithIdentifier:WalletIdentifiers[0]
                             forName:@"LWLykkeTableViewCell"];
    
    [self registerCellWithIdentifier:WalletIdentifiers[1]
                             forName:@"LWBanksTableViewCell"];
    
    [self registerCellWithIdentifier:emptyCellIdentifier
                             forName:@"LWWalletEmptyTableViewCell"];
    
    [self registerCellWithIdentifier:kLoadingTableViewCellIdentifier
                             forName:kLoadingTableViewCell];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    
    shouldShowError = NO;
    
    [self setRefreshControl];
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
    
    if ([expandedSections containsIndex:section])
    {
        if (self.data) {
            int const rowCell = 1;
            if (section == kSectionLykkeWallets &&
                self.data.lykkeData && self.data.lykkeData.assets) {
                return MAX(1, self.data.lykkeData.assets.count) + rowCell;
            }
            else if (section == kSectionBankCards && self.data.bankCards) {
                return MAX(1, self.data.bankCards.count) + rowCell;
            }
            else {
                return 2; // general + empty
            }
        }
        else {
            // loading indicator cell
            if (section == kSectionLykkeWallets || section == kSectionBankCards) {
                return 2;
            }
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
                    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    LWLykkeTableViewCell *lykke = (LWLykkeTableViewCell *)cell;
                    LWLykkeAssetsData *asset = [self assetDataForIndexPath:indexPath];
                    lykke.walletNameLabel.text = asset.name;
                    lykke.walletBalanceLabel.text = [NSString stringWithFormat:@"%@ %@", asset.symbol, asset.balance];
                }
                // Show Empty
                else {
                    cell = [tableView dequeueReusableCellWithIdentifier:emptyCellIdentifier];
                }
            }
            else {
                // loading indicator cell
                cell = [tableView dequeueReusableCellWithIdentifier:kLoadingTableViewCellIdentifier];
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
            else {
                // loading indicator cell
                cell = [tableView dequeueReusableCellWithIdentifier:kLoadingTableViewCellIdentifier];
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

    // show history for selected asset
    if (indexPath.row != 0) {
        if (indexPath.section == kSectionBankCards) {
            if (self.data && self.data.bankCards) {
                if (self.data.bankCards.count > 0) {
                    [self showDepositPage:indexPath];
                }
            }
        }
        else if (indexPath.section == kSectionLykkeWallets) {
            if (self.data && self.data.lykkeData && self.data.lykkeData.assets) {
                if (self.data.lykkeData.assets.count > 0) {
                    [self showDepositPage:indexPath];
                }
            }
        }
    }
    // expand / close wallet
    else {
        [self expandTable:tableView indexPath:indexPath];
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *sell = [UITableViewRowAction
                                  rowActionWithStyle:UITableViewRowActionStyleDefault
                                  title:Localize(@"wallets.general.sell")
                                  handler:^(UITableViewRowAction *action,
                                            NSIndexPath *indexPath) {
                                      return [self showDealFormForIndexPath:indexPath];
                                  }];
    sell.backgroundColor = [UIColor colorWithHexString:kSellAssetButtonColor];
    return @[sell];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // validate for assets
    if (indexPath.section == kSectionLykkeWallets) {
        LWLykkeAssetsData *data = [self assetDataForIndexPath:indexPath];
        if (data) {
            // validate for base asset and balance
            if (![data.identity isEqualToString:[LWCache instance].baseAssetId] &&
                data.balance.doubleValue > 0.0) {
                return YES;
            }
        }
    }
    return NO;
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didReceiveLykkeData:(LWLykkeWalletsData *)data {
    [refreshControl endRefreshing];

    shouldShowError = NO;
    _data = data;
    [self.tableView reloadData];
}

- (void)authManager:(LWAuthManager *)manager didGetAssetPair:(LWAssetPairModel *)assetPair {
    [self setLoading:NO];
    shouldShowError = NO;
    
    LWExchangeDealFormPresenter *controller = [LWExchangeDealFormPresenter new];
    controller.assetPair = assetPair;
    controller.assetDealType = LWAssetDealTypeSell;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [refreshControl endRefreshing];
    shouldShowError = NO;
    
    [self showReject:reject code:context.error.code willNotify:shouldShowError];
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


#pragma mark - Utils

- (void)expandTable:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
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

- (NSString *)assetIdentifyForIndexPath:(NSIndexPath *)indexPath {
    // Lykke cells
    if (indexPath.section == kSectionLykkeWallets) {
        LWLykkeAssetsData *data = [self assetDataForIndexPath:indexPath];
        return (data ? data.identity : nil);
    }
    // Banks cells
    else if (indexPath.section == kSectionBankCards) {
        if (self.data && self.data.bankCards) {
            // Show Banks Wallets
            if (self.data.bankCards.count > 0) {
                LWBankCardsData *card = (LWBankCardsData *)self.data.bankCards[indexPath.row - 1];
                return card.identity;
            }
            else {
                return nil;
            }
        }
    }
    return nil;
}

- (LWLykkeAssetsData *)assetDataForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kSectionLykkeWallets) {
        if (self.data && self.data.lykkeData && self.data.lykkeData.assets) {
            if (self.data.lykkeData.assets.count > 0 && indexPath.row > 0) {
                LWLykkeAssetsData *asset = (LWLykkeAssetsData *)self.data.lykkeData.assets[indexPath.row - 1];
                return asset;
            }
        }
    }
    return nil;
}

- (void)showDealFormForIndexPath:(NSIndexPath *)indexPath {
    [self setLoading:YES];
    LWLykkeAssetsData *data = [self assetDataForIndexPath:indexPath];
    [[LWAuthManager instance] requestAssetPair:data.assetPairId];
}

- (void)setRefreshControl
{
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 0, 0)];
    [self.tableView insertSubview:refreshView atIndex:0];
    
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blackColor];
    [refreshControl addTarget:self action:@selector(reloadWallets)
             forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
}

- (void)reloadWallets
{
    shouldShowError = YES;
    [[LWAuthManager instance] requestLykkeWallets];
}

- (void)showDepositPage:(NSIndexPath *)indexPath {
    //LWHistoryPresenter *history = [LWHistoryPresenter new];
    //history.assetId = assetId;
    //history.shouldGoBack = YES;
    //[self.navigationController pushViewController:history animated:YES];

    NSString *assetId = [self assetIdentifyForIndexPath:indexPath];
    LWWalletDepositPresenter *deposit = [LWWalletDepositPresenter new];
    NSString *depositUrl = [LWCache instance].depositUrl;
    NSString *email = [LWKeychainManager instance].login;
    deposit.url = [NSString stringWithFormat:@"%@?Email=%@&AssetId=%@", depositUrl, email, assetId];
    [self.navigationController pushViewController:deposit animated:YES];
}

@end
