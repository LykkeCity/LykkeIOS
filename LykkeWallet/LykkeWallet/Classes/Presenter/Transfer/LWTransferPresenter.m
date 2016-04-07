//
//  LWTransferPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 09.03.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWTransferPresenter.h"
#import "LWReceiverPresenter.h"
#import "LWTransferTableViewCell.h"
#import "LWCache.h"


@interface LWTransferPresenter () {
    
}

@property (weak, nonatomic) IBOutlet UIView      *headerView;
@property (weak, nonatomic) IBOutlet UILabel     *selectRecipientLabel;

@end


@implementation LWTransferPresenter


static NSInteger const kNumberOfRows = 7;
static NSString *const RecipientNames[kNumberOfRows] = {
    @"BRITISH AIRWAYS", @"LUFTHANSA", @"AIR CHINA", @"AIR ASTANA", @"AEROFLOT", @"DELTA AIR LINES", @"AIR FRANCE"
};
static NSString *const RecipientIcons[kNumberOfRows] = {
    @"BritishAirwaysIcon", @"LufthansaIcon", @"AirChinaIcon", @"AirAstanaIcon", @"AeroflotIcon", @"DeltaAirLinesIcon", @"AirFranceIcon"
};

static NSString *const RecipientCodes[kNumberOfRows] = {
    @"BA", @"LH", @"CA", @"KC", @"SU", @"DL", @"AF"
};


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = Localize(@"tab.trading");
    
    [self registerCellWithIdentifier:kTransferTableViewCellIdentifier
                                name:kTransferTableViewCell];
    
    [self setHideKeyboardOnTap:NO]; // gesture recognizer deletion
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController && self.navigationItem) {
        self.tabBarController.title = [self.navigationItem.title uppercaseString];
    }
    
#ifdef PROJECT_IATA
    self.headerView.backgroundColor = self.navigationController.navigationBar.barTintColor;
#endif
}


#pragma mark - TKPresenter

- (void)localize {
    self.selectRecipientLabel.text = Localize(@"transfer.recipient");
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTransferTableViewCellIdentifier];
    LWTransferTableViewCell *recipient = (LWTransferTableViewCell *)cell;
    if (recipient == nil)
    {
        recipient = (LWTransferTableViewCell *)[[UITableViewCell alloc]
                                initWithStyle:UITableViewCellStyleDefault
                              reuseIdentifier:kTransferTableViewCellIdentifier];
    }
        
    recipient.recipientLabel.text = RecipientNames[indexPath.row];
    recipient.recipientImageView.image = [UIImage imageNamed:RecipientIcons[indexPath.row]];

    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LWReceiverPresenter *presenter = [LWReceiverPresenter new];
    presenter.recepientId = RecipientCodes[indexPath.row];
    presenter.recepientName = RecipientNames[indexPath.row];
    presenter.recepientImage = RecipientIcons[indexPath.row];
    presenter.selectedAssetId = [LWCache instance].baseAssetId;
    [self.navigationController pushViewController:presenter animated:YES];
}

#ifdef PROJECT_IATA
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#endif

@end
