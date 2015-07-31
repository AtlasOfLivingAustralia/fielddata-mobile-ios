//
//  SpeciesListViewController.m
//  MobileFieldData
//
//  Created by Birks, Matthew (CSIRO IM&T, Yarralumla) on 14/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpeciesListViewController.h"
#import "Species.h"
#import "SpeciesTableCell.h"
#import "SpeciesGroup.h"

@interface SpeciesListViewController () {
    NSArray* speciesToDisplay;
}
@end

@implementation SpeciesListViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        speciesToDisplay = nil;
        fieldDataService = [[FieldDataService alloc]init];
        speciesLoader = [fieldDataService loadSpecies];
                
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style speciesIds:(NSArray*)speciesIds
{
    self = [super initWithStyle:style];
    if (self) {
        speciesToDisplay = speciesIds;
        fieldDataService = [[FieldDataService alloc]init];
        speciesLoader = [fieldDataService loadSpecies:speciesIds searchText:nil];
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Species List";
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,400,38)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;

    for(UIView *subView in searchBar.subviews) {
        if([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
            [(UITextField *)subView setKeyboardAppearance: UIKeyboardAppearanceAlert];
        }
    }
    //[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:searchBar action:@selector(resignFirstResponder)]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[speciesLoader sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    id <NSFetchedResultsSectionInfo> sectionInfo = [[speciesLoader sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    SpeciesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SpeciesTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    Species* species = [speciesLoader objectAtIndexPath:indexPath];
    cell.species = species;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[speciesLoader sections] objectAtIndex:section];
    return [sectionInfo name];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar resignFirstResponder];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark -UISearchBarDelegate

-(void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText
{
    [self doSearch:searchText];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [aSearchBar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
    [aSearchBar setText:@""];
    [self searchBar:aSearchBar textDidChange:@""];
    [aSearchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar*)aSearchBar
{
   [aSearchBar resignFirstResponder];
}

-(void)doSearch:(NSString*)searchText
{
    speciesLoader = [fieldDataService loadSpecies:speciesToDisplay searchText:searchText];
    [self.tableView reloadData];
}

@end
