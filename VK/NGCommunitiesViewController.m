//
//  NGCommunitiesViewController.m
//  VK
//
//  Created by Naz on 10/20/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGCommunitiesViewController.h"

#import "SWRevealViewController.h"
#import "NGCommunitiesTableViewCell.h"
#import "NGServerManager.h"
#import "NGGetCommunitiesObjectData.h"
#import "UIImageView+AFNetworking.h"

@interface NGCommunitiesViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) NSMutableArray* arrayCommunities;
@property (strong, nonatomic) NSString *userID;
@property (assign, nonatomic) BOOL loadingData;
@end

@implementation NGCommunitiesViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     self.userID = [userDefaults objectForKey:@"userID"];
    [self getCommunitiesFromServer];
    
    self.arrayCommunities = [NSMutableArray array];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
         self.sidebarButton.action = @selector(revealToggle:);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) getCommunitiesFromServer{
    
    __weak __typeof(self)weakSelf = self;
    
    self.loadingData = YES;
    
    [[NGServerManager sharedManager] getCommunitiesWithOffset: self.userID
                                                   withOffset:[self.arrayCommunities count]
                                                    withCount:20
                                                onSuccess:^(NSArray *friends) {
                                                    
                                                    
                                                    
                                                    if ([friends count] > 0) {
                                                        
                                                        NSLog(@"Loading");
                                                        
                                                        [weakSelf.arrayCommunities addObjectsFromArray:friends];
                                                        
                                                        NSMutableArray* newPaths = [NSMutableArray array];
                                                        
                                                        for (int i = (int)[weakSelf.arrayCommunities count] - (int)[friends count]; i < [weakSelf.arrayCommunities count]; i++){
                                                            [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                                            
                                                        }
                                                         self.loadingData = NO;
                                                        [self reloadTableViewContent];
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                onFailure:^(NSError *error, NSInteger statusCode) {
                                                    
                                                }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            NSLog(@"scrollViewDidScroll");
            self.loadingData = YES;
            [self getCommunitiesFromServer];
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
    
}

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayCommunities.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"Cell";
    
    if (self.loadingData == NO) {
        
        NGCommunitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if(!cell){
            cell = [[NGCommunitiesTableViewCell alloc] initWithStyle:
                    UITableViewCellStyleSubtitle      reuseIdentifier:identifier];
        }
        
        NGGetCommunitiesObjectData* friend = self.arrayCommunities[indexPath.row];
        
        cell.nameCommunities.text = friend.name;
        cell.modificatorCommunities.text = friend.status;
        
        [cell.avatarCommunities setImageWithURL:friend.imageURL placeholderImage:[UIImage imageNamed:@"pl_man"]];
        
        return cell;
    }
    
    NGCommunitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(!cell){
        cell = [[NGCommunitiesTableViewCell alloc] initWithStyle:
                UITableViewCellStyleDefault      reuseIdentifier:identifier];
    }
    
    cell.nameCommunities.text = @"Loading";
    return cell;
}



- (void)reloadTableViewContent {
   
    if (self.loadingData == NO) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    
}


@end
