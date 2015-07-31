//
//  MasterViewController.m
//  MobileFieldData
//
//  Created by Birks, Matthew (CSIRO IM&T, Yarralumla) on 10/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "LoginViewController.h"
#import "StandaloneSpeciesViewController.h"
#import "FieldDataService.h"
#import "SurveyViewController.h"
#import "SavedRecordsViewController.h"
#import "SurveyDownloadController.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCacheOperation.h"
#import "UIImageView+HighlightedWebCache.h"

#import "FD_Util.h"


@interface MasterViewController () {
    UILabel *tableHeader;

}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        preferences = [[Preferences alloc]init];
        if([FD_Util getBackgroundColor]){
            self.view.backgroundColor = [FD_Util getBackgroundColor];
        }
        
    }
    return self;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)refreshFieldData:(id)sender
{
 
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return surveys.count;
    }
    else if (section ==1) {
        return 2;
    }
    else if (section == 2) {
        return 2;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    NSString *reuseIdentifier = CellIdentifier;
    if (indexPath.section == 0) {
        reuseIdentifier = [NSString stringWithFormat:@"Cell%d", indexPath.row];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self configureCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // If the user hasn't logged in yet display the login page.
    if ([preferences getFieldDataSessionKey] == NULL) {
        [self openLoginPage];
    }
    
    [self loadSurveys];
}

-(void)loadSurveys
{
    FieldDataService* fieldDataService = [[FieldDataService alloc] init];
    surveys = [fieldDataService loadSurveys];
    tableHeader.text = [NSString stringWithFormat:@"Welcome %@", preferences.getUsersName];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        return @"Available Surveys";
    } else {
        return @"";
    }
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  tableView.bounds.size.width, 30)];
    UILabel *labelHeader = [[UILabel alloc] initWithFrame:CGRectMake (0,20,320,20)];
    labelHeader.textColor = [UIColor whiteColor];
    [headerView addSubview:labelHeader];

    if(section == 0)
        labelHeader.text = @"Available Surveys";
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self openSurveyPage:indexPath.row];
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self openSavedRecordsPage];
                break;
            /*case 1:
                [self openWeblink:indexPath];
                break;*/
            case 1:
                [self openSpeciesPage];
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                [self reloadSurveys];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                break;
            case 1:
                [self openLoginPage];
                break;
            default:
                break;
        }
    }
}

-(void)reloadSurveys {
    SurveyDownloadController* controller = [[SurveyDownloadController alloc] initWithView:self.view];
    controller.delegate = self;
    [controller downloadSurveys];
}

-(void)downloadSurveysSuccessful {
    [self loadSurveys];
}

-(void)downloadSurveysFailed {
    
    [self loadSurveys];
}

-(void)openSavedRecordsPage
{
    SavedRecordsViewController *savedRecordsViewController =
        [[SavedRecordsViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:savedRecordsViewController animated:YES];

}

-(void)openSurveyPage:(NSInteger) surveyIndex
{
    if (surveys != Nil && surveys.count != 0) {
        Survey* survey = [surveys objectAtIndex:surveyIndex];
        
        SurveyViewController* surveyViewController = [[SurveyViewController alloc] initWithStyle:UITableViewStylePlain
                                                                                          survey:survey
                                                                                          record:NULL];
        [self.navigationController pushViewController:surveyViewController animated:YES];
    }
    
}

- (void)openSpeciesPage
{
    StandaloneSpeciesViewController *speciesListViewController = [[StandaloneSpeciesViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:speciesListViewController animated:YES];
}

-(void)openWeblink:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
   
/*  NSString* path = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Portal path"];
    NSString *urlString = [NSString stringWithFormat:@"http://root.ala.org.au%@/review/sightings/advancedReview.htm?u=%@", path, [preferences getUserId]];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
 */   
}

- (void)openLoginPage
{
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    if ([preferences getFieldDataSessionKey]) {
        [self presentModalViewController:loginViewController animated:YES];
    } else {
        [self presentModalViewController:loginViewController animated:NO];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        Survey *survey = [surveys objectAtIndex:indexPath.row];
        cell.textLabel.text = survey.name;
        NSString* surveyImagePath = survey.imageUrl;
        if ([surveyImagePath length] > 0) {
            // Omit leading / if present as the url prefix has a trailing /
            if ([surveyImagePath hasPrefix:@"/"]) {
                surveyImagePath = [surveyImagePath substringFromIndex:1];
            }
            NSString* url = [preferences getFieldDataURL];
            url = [url stringByAppendingString:surveyImagePath];
            [cell.imageView sd_setImageWithURL: [NSURL URLWithString:url]
                                     completed: ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                                }];

        }
        else {
            [cell.imageView setImage:nil];
        }
    }
    else if (indexPath.section ==1) {
        switch (indexPath.row) {
    
            case 0:
                cell.textLabel.text = @"Saved Records";
                break;
            /*case 1:
                cell.textLabel.text = @"View My Records Online";
                break;*/
            case 1:
                cell.textLabel.text = @"Species List";
                break;
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Reload Surveys";
                cell.accessoryType = UITableViewCellAccessoryNone;
                break;
            case 1:
                cell.textLabel.text = @"Change Login";
                break;
            default:
                break;
        }
    }
    
    //NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
}

@end
