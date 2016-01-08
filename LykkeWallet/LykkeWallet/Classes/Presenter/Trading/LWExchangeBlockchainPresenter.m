//
//  LWExchangeBlockchainPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 08.01.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWExchangeBlockchainPresenter.h"
#import "LWAssetBlockchainTableViewCell.h"
#import "LWAssetBlockchainIconTableViewCell.h"
#import "TKButton.h"
#import "LWConstants.h"
#import "UIViewController+Loading.h"


@interface LWExchangeBlockchainPresenter () {
    
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet TKButton *closeButton;

@end


@implementation LWExchangeBlockchainPresenter


static NSInteger const kDescriptionRows = 9;

static NSString *const DescriptionIdentifiers[kDescriptionRows] = {
    kAssetBlockchainIconTableViewCellIdentifier,
    kAssetBlockchainTableViewCellIdentifier,
    kAssetBlockchainTableViewCellIdentifier,
    kAssetBlockchainTableViewCellIdentifier,
    kAssetBlockchainTableViewCellIdentifier,
    kAssetBlockchainTableViewCellIdentifier,
    kAssetBlockchainTableViewCellIdentifier,
    kAssetBlockchainTableViewCellIdentifier,
    kAssetBlockchainTableViewCellIdentifier
};


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCellWithIdentifier:kAssetBlockchainIconTableViewCellIdentifier
                                name:kAssetBlockchainIconTableViewCell];
    
    [self registerCellWithIdentifier:kAssetBlockchainTableViewCellIdentifier
                                name:kAssetBlockchainTableViewCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.closeButton setTitle:Localize(@"exchange.blockchain.close")
                      forState:UIControlStateNormal];
    [self.closeButton setGrayPalette];
    
    [self.tableView
     setBackgroundColor:[UIColor colorWithHexString:kMainGrayElementsColor]];
    
    // request blockchain data
    [self setLoading:YES];
    [[LWAuthManager instance] requestBlockchainTransaction:self.orderId];
}


#pragma mark - Actions

- (IBAction)closeClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didGetBlockchainTransaction:(LWAssetBlockchainModel *)blockchain {
    [self setLoading:NO];
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self showReject:reject];
    [self closeClicked:self.closeButton];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kDescriptionRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const DescriptionNames[kDescriptionRows] = {
        Localize(@"1"),
        Localize(@"2"),
        Localize(@"3"),
        Localize(@"4"),
        Localize(@"5"),
        Localize(@"6"),
        Localize(@"7"),
        Localize(@"8"),
        Localize(@"9")
    };
    
    NSString *identifier = DescriptionIdentifiers[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // show cell with icon
    if (indexPath.row == 0) {
        LWAssetBlockchainIconTableViewCell *iconCell = (LWAssetBlockchainIconTableViewCell *)cell;
        iconCell.title.text = Localize(@"exchange.blockchain.title");
    }
    // show information cells
    else {
        LWAssetBlockchainTableViewCell *blockchainCell = (LWAssetBlockchainTableViewCell *)cell;
        blockchainCell.titleLabel.text = DescriptionNames[indexPath.row];
        blockchainCell.detailLabel.text = DescriptionNames[indexPath.row];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kAssetBlockchainIconTableViewCellHeight;
    }
    
    return 50.0;
}

@end
