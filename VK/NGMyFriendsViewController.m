//
//  NGMyFriendsViewController.m
//  VK
//
//  Created by Naz on 10/20/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGMyFriendsViewController.h"
#import "NGProfileViewController.h"
#import "SWRevealViewController.h"

#import "SCLAlertView.h"
#import "NGServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "NGMyFriendsTableViewCell.h"

#import "NGGetFriendsObjectData.h"
#import "NGGetWallObjectData.h"
#import "NGGetUserObjectData.h"
#import "NGGetPhotosObjectData.h"
#import "NGGetCommunitiesObjectData.h"
#import "NGPhotoObjectData.h"
#import "NGMusicObjectData.h"


@interface NGMyFriendsViewController () <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{

}


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (strong, nonatomic) NSMutableArray* arrayFriends;
@property (strong, nonatomic) NSString *sortBy;
@property (strong, nonatomic) NSString *userID;
@property (assign, nonatomic) BOOL loadingData;


@end

@implementation NGMyFriendsViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.arrayFriends = [NSMutableArray array];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     self.userID = [userDefaults objectForKey:@"userID"];
     self.sortBy = @"_lastName";
     self.searchResult = [NSMutableArray arrayWithCapacity:[self.arrayFriends count]];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
         self.sidebarButton.action = @selector(revealToggle:);
    }
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonCountry",@"Country"),
                                                          NSLocalizedString(@"ScopeButtonCapital",@"Capital")];
    self.searchController.searchBar.delegate = self;
   [self setCustomToolbar];
   [self getFriendsFromServer];

}

#pragma mark - Custom Toolbar

-(void) setCustomToolbar {
    
    UIView *viewPtr = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 44, 10)];
    UISegmentedControl *mainSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"All Friends", @"Online", nil]];
    CGRect myFrame = CGRectMake(- 60.f, - 10.0f, self.view.frame.size.width - 40 , 30.0f);
     mainSegment.frame = myFrame;
    [mainSegment setTintColor:[UIColor grayColor]];
    //self.navigationItem.titleView = mainSegment;
     mainSegment.selectedSegmentIndex = 0;
    [mainSegment addTarget:self action:@selector(mainSegmentControl:) forControlEvents: UIControlEventValueChanged];
    [viewPtr addSubview:mainSegment];
    
    UIBarButtonItem *control = [[UIBarButtonItem alloc] initWithCustomView:mainSegment];
    NSArray *items = [NSArray arrayWithObjects:control, nil];
    self.toolbarItems = items;
   
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.arrayFriends filteredArrayUsingPredicate:resultPredicate]];
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    
    self.navigationController.navigationBar.translucent = YES;
}

-(void)willDismissSearchController:(UISearchController *)searchController
{
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)mainSegmentControl:(UISegmentedControl *)segment
{
    
    if(segment.selectedSegmentIndex == 0)
    {
         self.sortBy = @"_lastName";
        [self reloadTableViewContent];
    }
    else if(segment.selectedSegmentIndex == 1)
    {
         self.sortBy = @"_isOnline";
        [self reloadTableViewContent];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
//    NSString *searchString = searchController.searchBar.text;
//    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
//    [self reloadTableViewContent];
}

#pragma mark - Get Data From Server


-(void) getFriendsFromServer{
    
    __weak __typeof (self) weakSelf = self;
    
    self.loadingData = YES;
    
    [[NGServerManager sharedManager] getFriendsWithOffset:self.userID
                                               withOffset:[self.arrayFriends count]
                                                withCount:100
                                                onSuccess:^(NSArray *friends) {
                                                    
                                                    
                                                    
                                                    if ([friends count] > 0) {
                                                        
                                                        NSLog(@"Loading");
                                                        
                                                        [weakSelf.arrayFriends addObjectsFromArray:friends];
                                                        
                                                        NSMutableArray* newPaths = [NSMutableArray array];
                                                        
                                                        for (int i = (int)[weakSelf.arrayFriends count] - (int)[friends count]; i < [weakSelf.arrayFriends count]; i++){
                                                            [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                                            
                                                        }
                                                      
                                                     self.loadingData = NO;                                                     }
                                                    
                                                    [self reloadTableViewContent];
                                                    
                                                }
                                                onFailure:^(NSError *error, NSInteger statusCode) {
                                                    
                                                }];
}

#pragma mark - Reload Table ViewContent

- (void)reloadTableViewContent {
    
    if (self.loadingData == NO) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:
            [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch)
    {
        CGRect searchBarFrame = self.searchController.searchBar.frame;
        [tableView scrollRectToVisible:searchBarFrame animated:YES];

        return -1;
    }
    else {
        UILocalizedIndexedCollation *currentCollation = [UILocalizedIndexedCollation currentCollation];
        NSLog(@"selected charecter=%ld",(long)[currentCollation sectionForSectionIndexTitleAtIndex:index]);
        return [currentCollation sectionForSectionIndexTitleAtIndex:index - 1];
    }
}



#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            NSLog(@"scrollViewDidScroll");
            self.loadingData = YES;
            [self getFriendsFromServer];
        }
    }
    
    
}



#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    NGGetFriendsObjectData  *friend = self.arrayFriends[indexPath.row];
//    NGProfileViewController *userVC = (NGProfileViewController*)[storyboard instantiateViewControllerWithIdentifier:@"     "];
//    
//    userVC.superUserID = friend.userID;
//    
//    
//    [self.navigationController pushViewController:userVC animated:YES];
    
}

#pragma mark - UITableViewDataSource


    //return self.arrayFriends.count;

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([self.sortBy isEqualToString:@"_isOnline"]) {
        return 0;
    }
    return 25.0f;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.sortBy isEqualToString:@"_isOnline"]) {
        
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (![self.sortBy isEqualToString:@"_isOnline"]) {

            if (self.loadingData == NO) {
    
                if (section == 0) {
                    return 5;
                }
                if (section == 1) {
                    return self.arrayFriends.count - 5;
            
                }
        
            }}
    
    return self.arrayFriends.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return @"Important";
    }
    return @"";
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"Cell";
    
    if (self.loadingData == NO) {
        
        if (indexPath.section == 0) {
            
            NSMutableArray *friends = self.arrayFriends;
            if ([self.sortBy isEqualToString:@"_isOnline"]){
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:self.sortBy ascending:YES];
                [friends sortUsingDescriptors:[NSArray arrayWithObject:sort]];
            }
        
    NGMyFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(!cell){
        cell = [[NGMyFriendsTableViewCell alloc] initWithStyle:
                UITableViewCellStyleSubtitle      reuseIdentifier:identifier];
    }

    NGGetFriendsObjectData* friend = friends[indexPath.row];
    
    cell.nameFriend.text       = [NSString stringWithFormat:@"%@ %@",friend.firstName, friend.lastName];

    [cell.avatarFriends setImageWithURL:friend.imageURL placeholderImage:[UIImage imageNamed:@"pl_man"]];
    
        
        if ([friend.isOnline isEqualToString:@"Online"]) {
                cell.imageIsOnline.hidden = NO;
                      } else  if ([friend.isOnline isEqualToString:@"offline"]){
                          cell.imageIsOnline.hidden = YES;
                      
        }
    
    return cell;
        
        }
        
        if (indexPath.section == 1) {
            
            NSMutableArray *friends = self.arrayFriends;
            
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:self.sortBy ascending:YES];
            [friends sortUsingDescriptors:[NSArray arrayWithObject:sort]];
            
            NGMyFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            if(!cell){
                cell = [[NGMyFriendsTableViewCell alloc] initWithStyle:
                        UITableViewCellStyleSubtitle      reuseIdentifier:identifier];
            }
            
            NGGetFriendsObjectData* friend = friends[indexPath.row];
            
            cell.nameFriend.text       = [NSString stringWithFormat:@"%@ %@",friend.firstName, friend.lastName];
            
            [cell.avatarFriends setImageWithURL:friend.imageURL placeholderImage:[UIImage imageNamed:@"pl_man"]];
            
            
            if ([friend.isOnline isEqualToString:@"Online"]) {
                cell.imageIsOnline.hidden = NO;
            } else  if ([friend.isOnline isEqualToString:@"offline"]){
                cell.imageIsOnline.hidden = YES;
                
            }
            
            return cell;
            
            
        }
        
        
        
    }
    
    NGMyFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(!cell){
        cell = [[NGMyFriendsTableViewCell alloc] initWithStyle:
                UITableViewCellStyleDefault      reuseIdentifier:identifier];
    }
    
        cell.nameFriend.text= @"Loading";
        return cell;
}


@end
