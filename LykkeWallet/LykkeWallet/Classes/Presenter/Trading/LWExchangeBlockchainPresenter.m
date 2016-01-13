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
#import "LWAssetBlockchainModel.h"
#import "TKButton.h"
#import "LWConstants.h"
#import "LWMath.h"
#import "UIViewController+Loading.h"


@interface LWExchangeBlockchainPresenter () {
    LWAssetBlockchainModel *blockchainModel;
}


#pragma mark - Outlets

@property (weak, nonatomic) IBOutlet TKButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel  *extraTitleLabel;
@property (weak, nonatomic) IBOutlet UIView   *fakeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *extraHeightConstraint;


#pragma mark - Utils

- (NSString *)stringFromData:(NSString *)data;
- (void)updateViewWithOffset:(CGPoint)offset;
- (CGFloat)calculateRowHeightForText:(NSString *)text;
- (NSString *)dataByCellRow:(NSInteger)row;

@end


@implementation LWExchangeBlockchainPresenter


static NSInteger const kDescriptionRows = 10;

static NSString *const DescriptionIdentifiers[kDescriptionRows] = {
    kAssetBlockchainIconTableViewCellIdentifier,
    kAssetBlockchainTableViewCellIdentifier,
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
    
    self.extraTitleLabel.text = Localize(@"exchange.blockchain.title");
    
    [self.tableView
     setBackgroundColor:[UIColor colorWithHexString:kMainGrayElementsColor]];
    
    [self updateViewWithOffset:CGPointMake(0, 0)];
    
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
    blockchainModel = blockchain;
    [self setLoading:NO];
    
    [self.tableView reloadData];
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
    return (blockchainModel == nil) ? 1 : kDescriptionRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const Descriptions[kDescriptionRows] = {
        Localize(@"exchange.blockchain.hash"),
        Localize(@"exchange.blockchain.date"),
        Localize(@"exchange.blockchain.confirm"),
        Localize(@"exchange.blockchain.block"),
        Localize(@"exchange.blockchain.height"),
        Localize(@"exchange.blockchain.sender"),
        Localize(@"exchange.blockchain.asset"),
        Localize(@"exchange.blockchain.quantity"),
        Localize(@"exchange.blockchain.url")
    };
    
    UIColor *dark = [UIColor colorWithHexString:kMainDarkElementsColor];
    UIColor *colored = [UIColor colorWithHexString:kMainElementsColor];
    UIColor *const Colors[kDescriptionRows] = {
        dark,
        dark,
        dark,
        dark,
        dark,
        colored,
        colored,
        dark,
        colored
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
        blockchainCell.titleLabel.text = Descriptions[indexPath.row - 1];
        blockchainCell.detailLabel.text = [self dataByCellRow:indexPath.row - 1];
        blockchainCell.detailLabel.textColor = Colors[indexPath.row - 1];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return kAssetBlockchainIconTableViewCellHeight;
    }
    
    NSString *text = [self dataByCellRow:indexPath.row - 1];
    return [self calculateRowHeightForText:text];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateViewWithOffset:scrollView.contentOffset];
}


#pragma mark - Utils

- (NSString *)stringFromData:(NSString *)data {
    if (data == nil || [data isKindOfClass:[NSNull class]]) {
        return @" - ";
    }
    
    return data;
}

- (void)updateViewWithOffset:(CGPoint)offset {
    int const kBlockchainCellHeight = 245;
    int const kFakeViewHeight = 100;
    if (offset.y >= kBlockchainCellHeight) {
        [self.fakeView setHidden:NO];
        self.extraHeightConstraint.constant = kFakeViewHeight;
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    else {
        [self.fakeView setHidden:YES];
        self.extraHeightConstraint.constant = 0;
        self.tableView.backgroundColor = [UIColor colorWithHexString:kMainGrayElementsColor];
    }
}

- (CGFloat)calculateRowHeightForText:(NSString *)text {
    
    CGFloat const kTopBottomPadding = 8.0;
    CGFloat const kLeftRightPadding = 20.0 * 2.0;
    CGFloat const kTitleWidth = 100.0;
    CGFloat const kDescriptionWidth = self.tableView.frame.size.width - kLeftRightPadding - kTitleWidth;
    
    UIFont *font = [UIFont fontWithName:kFontRegular size:kAssetDetailsFontSize];
    CGSize const size = CGSizeMake(kDescriptionWidth, CGFLOAT_MAX);
    CGRect rect = [text boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:font}
                                     context:nil];
    
    CGFloat const kDefaultRowHeight = 50.0;
    CGFloat const cellHeight = MAX(kDefaultRowHeight, rect.size.height + kTopBottomPadding * 2.0);
    return cellHeight;
}

- (NSString *)dataByCellRow:(NSInteger)row {
    NSString *const values[kDescriptionRows] = {
        [self stringFromData:blockchainModel.identity],
        [self stringFromData:blockchainModel.date],
        [LWMath makeStringByNumber:blockchainModel.confirmations withPrecision:0],
        [self stringFromData:blockchainModel.block],
        [LWMath makeStringByNumber:blockchainModel.height withPrecision:0],
        [self stringFromData:blockchainModel.senderId],
        [self stringFromData:blockchainModel.assetId],
        [LWMath makeStringByNumber:blockchainModel.quantity withPrecision:0],
        [self stringFromData:blockchainModel.url]
    };
    return values[row];
}

@end
