//
//  LWCountrySelectorPresenter.m
//  LykkeWallet
//
//  Created by Alexander Pukhov on 07.05.16.
//  Copyright © 2016 Lykkex. All rights reserved.
//

#import "LWCountrySelectorPresenter.h"
#import "LWCountryTableViewCell.h"
#import "LWCountryModel.h"
#import "LWAuthManager.h"
#import "UIViewController+Navigation.h"
#import "UIViewController+Loading.h"


@interface LWCountrySelectorPresenter ()/* <UISearchBarDelegate, UISearchDisplayDelegate>*/ {
    NSArray *countries;
    NSArray *sections;
}

@property (nonatomic, strong) NSString *filter;

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;


#pragma mark - Utils

- (NSArray *)countriesBySection:(NSInteger)section;

@end


@implementation LWCountrySelectorPresenter


#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = Localize(@"register.phone.country.title");
    
    countries = [NSArray array];
    sections = [NSArray arrayWithObjects:@"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    [self setBackButton];
 
    NSString *searchText = Localize(@"register.phone.country.placeholder");
    [self.searchBar setKeyboardType:UIKeyboardTypeDefault];
    [self.searchBar setPlaceholder:searchText];
    [self.searchBar setBarStyle:UIBarStyleDefault];
    [self.searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    [self registerCellWithIdentifier:kCountryTableViewCellIdentifier
                             forName:kCountryTableViewCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setLoading:YES];
    
    [[LWAuthManager instance] requestCountyCodes];
}


#pragma mark - LWAuthManagerDelegate

- (void)authManager:(LWAuthManager *)manager didGetCountryCodes:(NSArray *)countryCodes {
    [self setLoading:NO];
    countries = [countryCodes copy];
    [self.tableView reloadData];
}

- (void)authManager:(LWAuthManager *)manager didFailWithReject:(NSDictionary *)reject context:(GDXRESTContext *)context {
    [self showReject:reject response:context.task.response code:context.error.code willNotify:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *items = [self countriesBySection:section];
    NSInteger result = items.count;
    return result;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionHeader = [NSString stringWithFormat:@"  %@", [sections objectAtIndex:section]];
    return sectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCountryTableViewCellIdentifier];
    [self configureCell:cell indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LWCountryTableViewCell *cell = (LWCountryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [self.delegate countrySelected:cell.model.name code:cell.model.identity prefix:cell.model.prefix];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - LWAuthenticatedTablePresenter

- (void)configureCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    LWCountryTableViewCell *itemCell = (LWCountryTableViewCell *)cell;
    NSArray *items = [self countriesBySection:indexPath.section];
    LWCountryModel *model = (LWCountryModel *)[items objectAtIndex:indexPath.row];
    
    if (model && itemCell) {
        itemCell.countryLabel.text = model.name;
        itemCell.codeLabel.text = model.prefix;
        itemCell.model = [model copy];
    }
}

/*
#pragma mark - Searching

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self setFilter:searchText];
    //[self updateSelectedIndexPath];
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope: [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self filterContentForSearchText:nil scope:nil];
}*/


#pragma mark - Utils

- (NSArray *)countriesBySection:(NSInteger)section {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name beginswith[cd] %@", [sections objectAtIndex:section]];
    NSArray *sectionArray = [countries filteredArrayUsingPredicate:predicate];
    return sectionArray;
}

@end
