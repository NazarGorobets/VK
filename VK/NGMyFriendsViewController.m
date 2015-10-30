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


@interface NGMyFriendsViewController () <UITableViewDelegate, UITableViewDataSource>{

}


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSMutableArray *searchResult;
@property (strong, nonatomic) NSMutableArray *arrayFriends;
@property (strong, nonatomic) NSMutableArray *friends;
@property (strong, nonatomic) NSMutableArray *mutibleArrayFriends;
@property (strong, nonatomic) NSString *sortBy;
@property (strong, nonatomic) NSString *userID;
@property (assign, nonatomic) BOOL loadingData;


@end

@implementation NGMyFriendsViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
     self.arrayFriends = [NSMutableArray array];
     self.mutibleArrayFriends = [NSMutableArray array];
     self.friends = [NSMutableArray array];
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
     mainSegment.selectedSegmentIndex = 0;
    [mainSegment addTarget:self action:@selector(mainSegmentControl:) forControlEvents: UIControlEventValueChanged];
    [viewPtr addSubview:mainSegment];
    
    UIBarButtonItem *control = [[UIBarButtonItem alloc] initWithCustomView:mainSegment];
    NSArray *items = [NSArray arrayWithObjects:control, nil];
    self.toolbarItems = items;
   
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
                                                        [self.mutibleArrayFriends addObjectsFromArray:weakSelf.arrayFriends];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            if (![self.sortBy isEqualToString:@"_isOnline"]){
            self.loadingData = YES;
           [self getFriendsFromServer];
                
            }
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
                    return self.arrayFriends.count;
            
                }
        
            }}

    NSPredicate *bobPredicate = [NSPredicate predicateWithFormat:@"isOnline = 'Online'"];
    
    [self.mutibleArrayFriends filterUsingPredicate:bobPredicate];
    
    return self.mutibleArrayFriends.count;
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
       if ([self.sortBy isEqualToString:@"_isOnline"]){
                
               self.friends = self.mutibleArrayFriends;
        } else self.friends = self.arrayFriends;
        
           NGMyFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
           if(!cell){
               cell = [[NGMyFriendsTableViewCell alloc] initWithStyle:
                       UITableViewCellStyleSubtitle      reuseIdentifier:identifier];
           }
    
           NGGetFriendsObjectData* friend = self.friends[indexPath.row];
    
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
//    if(!cell){
//        cell = [[NGMyFriendsTableViewCell alloc] initWithStyle:
//                UITableViewCellStyleDefault      reuseIdentifier:identifier];
//    }
//    NSMutableArray *friends = self.arrayFriends;
//        NGGetFriendsObjectData* friend = friends[indexPath.row];
//        cell.nameFriend.text = [NSString stringWithFormat:@"%@ %@",friend.firstName, friend.lastName];
       return cell;
}


@end
