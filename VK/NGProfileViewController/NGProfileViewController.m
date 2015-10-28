//
//  NGProfileViewController.m
//  VK
//
//  Created by Naz on 10/20/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGProfileViewController.h"

#import "SCLAlertView.h"
#import "VKSdk.h"
#import "SWRevealViewController.h"
#import "NGServerManager.h"
#import "NGImageViewGallery.h"
#import "UIImageView+AFNetworking.h"

#import "NGGetFriendsObjectData.h"
#import "NGGetWallObjectData.h"
#import "NGGetUserObjectData.h"
#import "NGGetPhotosObjectData.h"
#import "NGGetCommunitiesObjectData.h"
#import "NGPhotoObjectData.h"
#import "NGMusicObjectData.h"
#import "NGLinkWallObjectData.h"
#import "NGMusicWallObjectData.h"
#import "NGWallCellTableViewCell.h"
#import "NGShortInfoTableViewCell.h"

#import "NGFirstCollectionViewCell.h"
#import "NGUserSubscriberCountTableViewCell.h"
#import "NGPhotoProfileCollectionViewCell.h"
#import "NGPhotoProfileTableViewCell.h"

static CGSize CGResizeFixHeight(CGSize size) {
    
    CGFloat targetHeight = 65.0f;
    CGFloat scaleFactor = targetHeight / size.height;
    //CGFloat targetWidth = size.width * scaleFactor;
    int targetWidth = size.width * scaleFactor;
    
    return CGSizeMake(targetWidth, targetHeight);
}


static CGSize CGSizeResizeToHeight(CGSize size, CGFloat height) {
    
    size.width *= height / size.height;
    size.height = height;
    
    return size;
}

static float offset       = 8.f;

static float heightPhoto  = 60.f;
static float heightShared = 33.f;

static float offsetBeforePhoto                = 8.f;
static float offsetBetweenPhotoAndText        = 8.f;
static float offsetBetweenTextAndShared       = 16.f;
static float offsetAfterShared                = 10.f;


static NSInteger allPostWallFilter   = 0;
static NSInteger ownerPostWallFilter = 1;

@interface NGProfileViewController ()<VKSdkDelegate, UITableViewDataSource, UITableViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *allPostsButton;
@property (weak, nonatomic) IBOutlet UIButton *myPostsButton;


@property (strong, nonatomic) NSString *tokenVk;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString* wallFilter;
@property (strong, nonatomic) NSURL *photo_100URL;
@property (strong,nonatomic)  NSMutableArray *imageViewSize;
@property (strong, nonatomic) NGGetUserObjectData *currentUser;
@property (strong, nonatomic) NSMutableArray *postArray;
@property (strong, nonatomic) NSMutableArray *productArray;
@property (strong, nonatomic) NSArray* arrayNumberDataCountres;
@property (strong, nonatomic) NSArray* arrayTextDataCountres;
@property (strong, nonatomic) NSMutableArray* miniaturePhotoArray;
@property (strong, nonatomic) NSMutableArray* pathsArray;
@property (strong, nonatomic) NSMutableArray* arrrayWall;
@property (strong, nonatomic) UICollectionView* collectionViewPhoto;

@property (assign, nonatomic)  BOOL loadingDataOfUser;
@property (assign, nonatomic)  BOOL loadingDataCollPhoto;
@property (assign, nonatomic)  BOOL loadingDataWall;
@property (assign, nonatomic)  BOOL firstTimeAppear;

@end

@implementation NGProfileViewController

static NSString * const shortInfoCellIdentifier = @"cellOne";
static NSString * const reuseIdentifier = @"NGUserSubscriberCountTableViewCell";
static NSString * const  wallIdentifier = @"NGWallCellTableViewCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.tokenVk = [userDefaults objectForKey:@"token"];
    self.userID  = [userDefaults objectForKey:@"userID"];
    self.arrayNumberDataCountres = [NSArray array];
    self.arrayTextDataCountres   = [NSMutableArray array];
    self.miniaturePhotoArray     = [NSMutableArray array];
    self.pathsArray = [NSMutableArray array];
    self.arrrayWall = [NSMutableArray array];
    self.imageViewSize  = [NSMutableArray array];
    self.wallFilter = @"all";
    
    self.allPostsButton.layer.cornerRadius  = 5;
    self.allPostsButton.layer.masksToBounds = YES;
    self.myPostsButton.layer.cornerRadius   = 5;
    self.myPostsButton.layer.masksToBounds  = YES;
    
    self.navigationController.navigationBar.barStyle     = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.3529 green:0.5137 blue:0.6980 alpha:1.000];
    self.navigationController.navigationBar.tintColor    = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
         self.sidebarButton.action = @selector(revealToggle:);
        
    }
    
    [self statusRegister];

    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}


#pragma mark - Check Status User

-(void) statusRegister {

    if (self.tokenVk == nil) {
        
        [VKSdk initializeWithDelegate:self andAppId:@"5113638"];
        
         NSArray *scope = @[@"friends",@"photos",@"audio",@"wall"];
        
        [VKSdk authorize:scope revokeAccess:YES forceOAuth:YES];
        
        if ([VKSdk wakeUpSession])
        {
            
        }
    }
    else {
        
        [self getUserInfo];
        [self getUserPhotoFromServer];
        [self getWallFromServer];
        
    };
}


#pragma mark - GET DATA FROM SERVER -

#pragma mark - Get Info For User

-(void) getUserInfo {
    
    
    /*
     
     Information for:
     
     relation, relatives, counters, common_count, followers_count,
     last_seen, status, schools, education, site, domain,online, photo_100,
     first_name, bdate, city,

     
     */
    
    
    __weak __typeof(self)weakSelf = self;
    
    self.loadingDataOfUser = YES;
    
    [[NGServerManager sharedManager] getUsersInfoUserID:self.userID
                                              onSuccess:^(NGGetUserObjectData *user) {
                                            
                                                      
                                                      typeof(self) strongSelf = weakSelf;

                                                  
                                                   strongSelf.currentUser = user;
                                                  
                                                   strongSelf.navigationItem.title = user.firstName;
                                                
                                                  [self setCounteresForCollectionView];
                                                   self.loadingDataOfUser = NO;
                                                  [self reloadTableViewContent];

                                              }
                                                                 
                                              onFailure:^(NSError *error, NSInteger statusCode) {
                                                  NSLog(@"errpr = %@ statsus %ld",[error localizedDescription],(long)statusCode);
                                              }];
}

#pragma mark - Get Photo For User

-(void)  getUserPhotoFromServer {
    
    __weak __typeof(self)weakSelf = self;
    
    self.loadingDataCollPhoto = YES;
    
    [[NGServerManager sharedManager] getPhotoUserID:self.userID
                                         withOffset:[self.miniaturePhotoArray count]
                                              count:20
                                          onSuccess:^(NSArray *photos) {
                                              
                                            if ([photos count] > 0){
                                              
                                                  
                                            typeof(self) strongSelf = weakSelf;
                                                  
                                             
                                                  
                                                  NSMutableArray* arrPath = [NSMutableArray array];
                                                  
                                                  for (NSInteger i= [strongSelf.miniaturePhotoArray count]; i <= [photos count] + [strongSelf.miniaturePhotoArray count]-1; i++) {
                                                      
                                                      [arrPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                                  }
                                                  
                                                  [strongSelf.miniaturePhotoArray addObjectsFromArray:photos];
                                                  [strongSelf.collectionViewPhoto insertItemsAtIndexPaths:arrPath];
                                                  
                                                  
                                                  self.loadingDataCollPhoto = NO;
                                                 [self reloadTableViewContent];
                                              }
                                              
                                          } onFailure:^(NSError *error, NSInteger statusCode) {
                                              
                                          }];

}

#pragma mark - Get Wall Of User

-(void)  getWallFromServer {
    
    __weak __typeof(self)weakSelf = self;
    
    self.loadingDataWall = YES;
    
    [[NGServerManager sharedManager] getWall:self.userID
                                  withDomain:@""
                                  withFilter:self.wallFilter
                                  withOffset:[self.arrrayWall count]
                                   typeOwner:@"user"
                                       count:20
                                   onSuccess:^(NSArray *posts) {
                                       
                                    
                                       
                                       if ([posts count] > 0) {
                                               
                                               typeof(self) strongSelf = weakSelf;
                                               
                                               NSMutableArray* arrPath = [NSMutableArray array];
                                               
                                               for (NSInteger i = [strongSelf.arrrayWall count]; i<=[posts count]+[strongSelf.arrrayWall count]-1; i++) {
                                                   
                                                   [arrPath addObject:[NSIndexPath indexPathForRow:i inSection:2]];
                                               }
                                               
                                               
                                               [strongSelf.arrrayWall addObjectsFromArray:posts];
                                               
                                               
                                               
                                               for (int i = (int)[strongSelf.arrrayWall count] - (int)[posts count]; i < [strongSelf.arrrayWall count]; i++) {

                                                   CGSize newSize = [strongSelf setFramesToImageViews:nil imageFrames:[[strongSelf.arrrayWall objectAtIndex:i] attachments]
                                                                                      toFitSize:CGSizeMake(self.view.frame.size.width-16, self.view.frame.size.width-16)];
                                                   
                                                   NSLog(@" getWallFromServer newSize = %@",NSStringFromCGSize(newSize));
                                                   [strongSelf.imageViewSize addObject:[NSNumber numberWithFloat:roundf(newSize.height)]];
                                                   
                                               }

                                           
                                            self.loadingDataWall = NO;
                                           [self reloadTableViewContent];
                                       }
                                       
                                       
                                   } onFailure:^(NSError *error, NSInteger statusCode) {
                                       
                                   }];
    
}


#pragma mark - Reload Table View Content

- (void)reloadTableViewContent {
    
    if (self.loadingDataWall == NO && self.loadingDataOfUser == NO && self.loadingDataCollPhoto == NO) {
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self.tableView reloadData];
            
        });
    }
    
}


#pragma mark - VK SDK Delegate

-(void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    
    [self.navigationController presentViewController:controller animated:YES completion:nil];
    
}

-(void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    
    self.tokenVk = newToken.accessToken;
    self.userID = newToken.userId;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:newToken.accessToken forKey:@"token"];
    [defaults setObject:newToken.userId forKey:@"userID"];
    [defaults synchronize];
    
    [self getUserInfo];
    
    
}

-(void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    
}

-(void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    [alert showError:self title:@"Oh!" subTitle:@"Please, authorize" closeButtonTitle:@"OK" duration:0.0f];
    NSLog(@"Error");

    
}

-(void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {

}

#pragma mark - IBAction

- (IBAction)showMoreInfoForUser:(id)sender {
    
    
}

- (IBAction)rightBarItemAction:(id)sender {
    
    UIAlertController * alert = [UIAlertController new];
    
    UIAlertAction* editProfile = [UIAlertAction
                         actionWithTitle:@"Edit Profile"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* copyLink = [UIAlertAction
                             actionWithTitle:@"Copy Link"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    UIAlertAction* openInSafary = [UIAlertAction
                             actionWithTitle:@"Open in Safari"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alert addAction:editProfile];
    [alert addAction:copyLink];
    [alert addAction:openInSafary];
    [alert addAction:cancel];
    
        [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - Counteres For CollectionView

-(void) setCounteresForCollectionView {
    
    
    NSMutableArray* newNumberArray = [NSMutableArray array];
    NSMutableArray* newTextArray   = [NSMutableArray array];
    
    if (self.currentUser.friends) {
        
        [newNumberArray addObject:_currentUser.friends];
        [newTextArray   addObject:@"friends"];
        
    }
    
    if (self.currentUser.followers) {
        
        [newNumberArray addObject:_currentUser.followers];
        [newTextArray   addObject:@"followers"];
        
    }
    
    if (self.currentUser.albums) {
        
        [newNumberArray addObject:_currentUser.albums];
        [newTextArray   addObject:@"albums"];
        
    }
    
    
    if (self.currentUser.audios) {
        
        [newNumberArray addObject:_currentUser.audios];
        [newTextArray   addObject:@"audios"];
        
    }
    
    if (self.currentUser.groups) {
        
        [newNumberArray addObject:_currentUser.groups];
        [newTextArray   addObject:@"groups"];
        
    }
    
    if (self.currentUser.pages) {
        
        [newNumberArray addObject:_currentUser.pages];
        [newTextArray   addObject:@"pages"];
        
    }
    if (self.currentUser.photos) {
        
        [newNumberArray addObject:_currentUser.photos];
        [newTextArray   addObject:@"photos"];
        
    }
    if (self.currentUser.videos) {
        
        [newNumberArray addObject:_currentUser.videos];
        [newTextArray   addObject:@"videos"];
        
    }
    
    
    self.arrayNumberDataCountres = newNumberArray;
    self.arrayTextDataCountres   = newTextArray;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ([UICollectionView isSubclassOfClass:[UIScrollView class]]) {
        
        UICollectionView* collectionView = (UICollectionView*)scrollView;
        
        
        if (collectionView.tag == 200) {
            
            if ((scrollView.contentOffset.x + scrollView.frame.size.width) >= scrollView.contentSize.width) {
                
                
                if (self.loadingDataCollPhoto == NO)
                {
                    
                    
                    NSLog(@"Loading!");
                    
                    self.loadingDataCollPhoto = YES;
                    [self getUserPhotoFromServer];
                }
                
            }
        }
    }
    
    
    
    if ([UITableView isSubclassOfClass:[UIScrollView class]]) {
        
        if (self.tableView.tag == 400) {
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                if (!self.loadingDataWall)
                {
                    self.loadingDataWall = YES;
                    NSLog(@"Loading!");
                    
                    [self getWallFromServer];
                }
            }
            
        }
    }
    
    
}


#pragma mark -  UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    if (collectionView.tag == 100) {
        return [self.arrayNumberDataCountres count];
    }
    
    if (collectionView.tag == 200) {
        
        return [self.miniaturePhotoArray count];
    }
    
    return 0;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 100) {
        
        static NSString *identifier = @"NGUserSubscriberCountTableViewCell";
        NGFirstCollectionViewCell *cell = (NGFirstCollectionViewCell*)
        [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                  forIndexPath:indexPath];
        
        cell.countLabel.text = self.arrayNumberDataCountres[indexPath.row];
        cell.typeCountLabel.text = self.arrayTextDataCountres[indexPath.row];
        
        return cell;
    }
    
    
    if (collectionView.tag == 200) {
        
        NGPhotoProfileCollectionViewCell *cell = (NGPhotoProfileCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"NGPhotoProfileCollectionViewCell" forIndexPath:indexPath];
        
        if (!cell) {
            [collectionView registerNib:[UINib nibWithNibName:@"CVPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"collectionPhotoCell"];
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionPhotoCell" forIndexPath:indexPath];
        }
        
        
        NGPhotoObjectData* photo = self.miniaturePhotoArray[indexPath.row];
        
        
        __weak NGPhotoProfileCollectionViewCell *weakCell = cell;
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:photo.photo_130URL];
        
        [cell.imageCollectionUser setImageWithURLRequest:request
                              placeholderImage:[UIImage imageNamed:@"pl_post2"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           weakCell.imageCollectionUser.image = image;
                                           photo.photo_130image = image;
                                           
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           
                                       }];
        
        
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    
    return nil;
}



#pragma mark - UICollectionViewDelegate


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (collectionView.tag == 100) {
        
        return CGSizeMake(70, 50);
    }
    
    if (collectionView.tag == 200) {
        
        
        NGPhotoObjectData* photo = self.miniaturePhotoArray[indexPath.row];
        
        NSLog(@"-- photo wieght %ld height %d",(long)photo.width, photo.height);
        
        
        if (photo.width == 0 && photo.height == 0) {
            photo.width = 300;
            photo.height = 150;
            
        }
        
        CGSize   oldSize = CGSizeMake(photo.width, photo.height);
        CGSize   newSize = CGResizeFixHeight(oldSize);
        
        NSLog(@"-- neewsize %@",NSStringFromCGSize(newSize));
        return  newSize;
        
    }
    
    return  CGSizeMake(50, 50);
}


#pragma mark - Text Image Configure

- (CGSize)setFramesToImageViews:(NSArray *)imageViews imageFrames:(NSArray *)imageFrames toFitSize:(CGSize)frameSize {
    
    int N = (int)imageFrames.count;
    
    for (int i = 0; i < [imageFrames count]; i++) {
        
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[NGLinkWallObjectData class]]) {
            N = N - 1;
        }
        
        
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[NGMusicWallObjectData class]]) {
            N = N - 1;
        }
    }
    
    if (N == 0) {
        
        float localHeightOffset = 0;
        
        for (int i = 0; i < [imageFrames count]; i++) {
            
            if ([[imageFrames objectAtIndex:i] isKindOfClass:[NGLinkWallObjectData class]]) {
                
                localHeightOffset += 60;
            }
            
            if ([[imageFrames objectAtIndex:i] isKindOfClass:[NGMusicWallObjectData class]]) {
                
                localHeightOffset += 60;
            }
        }
        return CGSizeMake(frameSize.width, localHeightOffset);
    }
    
    
    CGRect newFrames[N];
    
    float ideal_height = MAX(frameSize.height, frameSize.width) / N;
    float seq[N];
    float total_width = 0;
    
    ////
    ////
    ////
    
    for (int i = 0; i < [imageFrames count]; i++) {
        
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[NGPhotoObjectData class]]) {
            NGPhotoObjectData *image = [imageFrames objectAtIndex:i];
            CGSize size = CGSizeMake(image.width, image.height);
            CGSize newSize = CGSizeResizeToHeight(size, ideal_height);
            newFrames[i] = (CGRect) {{0, 0}, newSize};
            seq[i] = newSize.width;
            total_width += seq[i];
        }
    }
    
    int K = (int)roundf(total_width / frameSize.width);
    
    float M[N][K];
    float D[N][K];
    
    for (int i = 0 ; i < N; i++)
        for (int j = 0; j < K; j++)
            D[i][j] = 0;
    
    for (int i = 0; i < K; i++)
        M[0][i] = seq[0];
    
    for (int i = 0; i < N; i++)
        M[i][0] = seq[i] + (i ? M[i-1][0] : 0);
    
    long double cost;
    for (int i = 1; i < N; i++) {
        for (int j = 1; j < K; j++) {
            M[i][j] = INT_MAX;
            
            for (int k = 0; k < i; k++) {
                cost = MAX(M[k][j-1], M[i][0]-M[k][0]);
                if (M[i][j] > cost) {
                    M[i][j] = cost;
                    D[i][j] = k;
                }
            }
        }
    }
    
    int k1 = K-1;
    int n1 = N-1;
    int ranges[N][2];
    
    while (k1 >= 0) {
        
        if (k1>=10) {
            k1=0;
        }
        ranges[k1][0] = D[n1][k1]+1;
        ranges[k1][1] = n1;
        
        n1 = D[n1][k1];
        k1--;
    }
    ranges[0][0] = 0;
    
    float cellDistance = 5;
    
    //float heightOffset = cellDistance, widthOffset;
    float heightOffset = cellDistance, widthOffset;
    
    long double frameWidth;
    for (int i = 0; i < K; i++) {
        float rowWidth = 0;
        frameWidth = frameSize.width - ((ranges[i][1] - ranges[i][0]) + 2) * cellDistance;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            // тута
            rowWidth += (float)ceilf(newFrames[j].size.width);
            
        }
        
        float ratio = frameWidth / rowWidth;
        widthOffset = 0;
        
        for (int j = ranges[i][0]; j <= ranges[i][1]; j++) {
            newFrames[j].size.width *= ratio;
            newFrames[j].size.height *= ratio;
            newFrames[j].origin.x = widthOffset + (j - (ranges[i][0]) + 1) * cellDistance;
            newFrames[j].origin.y = heightOffset;
            
            widthOffset += newFrames[j].size.width;
        }
        heightOffset += newFrames[ranges[i][0]].size.height + cellDistance;
    }
    
    // link's
    
    for (int i = 0; i < [imageFrames count]; i++) {
        
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[NGLinkWallObjectData class]]) {
            
            heightOffset += 60;
        }
        
        if ([[imageFrames objectAtIndex:i] isKindOfClass:[NGMusicWallObjectData class]]) {
            
            heightOffset += 60;
        }
    }
    
    
    return CGSizeMake(frameSize.width, heightOffset);
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1)
        return 10.0f;
    
    return 0.001f;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return  5;
    }
    
    if (section == 1) {
        return 0;
//        return  [self.arrrayWall count];
    }
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.loadingDataWall == NO) {

        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                NGShortInfoTableViewCell *cell = (NGShortInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
                
//                if (!cell) {
//                    cell = [[NGShortInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shortInfoCellIdentifier];
//                }

                [cell.avatarUser setImageWithURL:self.currentUser.photo_100URL placeholderImage:[UIImage imageNamed:@"pl_man"]];
                
                cell.nameUser.text = [NSString stringWithFormat:@"%@ %@",self.currentUser.firstName , self.currentUser.lastName];
                cell.yearAndCityUser.text = self.currentUser.city;
                if (self.currentUser.online == YES) {
                     cell.isOnlineUser.text = @"Online";
                }
                else cell.isOnlineUser.text = @"Offline";
                
                return cell;
                
            }
            
            if (indexPath.row == 1) {
                
                static NSString *simpleTableIdentifier = @"NGUserSubscriberCountTableViewCell";

                
                NGUserSubscriberCountTableViewCell *cell = (NGUserSubscriberCountTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
                
                if (!cell) {
                    cell = [[NGUserSubscriberCountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
                }
                
                [cell.self.collectionViewMember reloadData];
                
                return cell;
                
            }
            if (indexPath.row == 2) {
                
                static NSString *MyIdentifier = @"countPhoto";
                UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
                }
                
                cell.textLabel.text = @"12";
                return cell;
            }
            if (indexPath.row == 3) {
                NGPhotoProfileTableViewCell *cell = (NGPhotoProfileTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NGPhotoProfileTableViewCell"];
                
                if (!cell) {
                    cell = [[NGPhotoProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NGPhotoProfileTableViewCell"];
                }
                
                [self.collectionViewPhotoCarusel reloadData];
                return cell;
            }

        }
        
    if (indexPath.section == 1) {
        
        
        NGWallCellTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:wallIdentifier];
        
        if ([cell viewWithTag: 11]) [[cell viewWithTag: 11] removeFromSuperview];
        if ([cell viewWithTag:222]) [[cell viewWithTag:222] removeFromSuperview];
        if ([cell viewWithTag:555]) [[cell viewWithTag:555] removeFromSuperview];
        
        [cell layoutIfNeeded];
        
        NGGetWallObjectData* wall = self.arrrayWall[indexPath.row];
        
        
        if (wall.user) {
            cell.fullName.text = [NSString stringWithFormat:@"%@ %@",wall.user.firstName, wall.user.lastName];
            [cell.ownerPhoto setImageWithURL:wall.user.photo_100URL placeholderImage:[UIImage imageNamed:@"pl_man"]];
        }
        
        
        cell.textPost.text = wall.text;
        cell.date.text     = wall.date;
        
        
        cell.commentLabel.text = ([wall.comments length]>3) ? ([NSString stringWithFormat:@"%@k",[wall.comments substringToIndex:1]]) : (wall.comments);
        cell.likeLabel.text    = ([wall.likes length]>3)    ? ([NSString stringWithFormat:@"%@k",[wall.likes substringToIndex:1]])    : (wall.likes);
        cell.repostLabel.text  = ([wall.reposts length]>3)  ? ([NSString stringWithFormat:@"%@k",[wall.reposts substringToIndex:1]])  : (wall.reposts);
        
        
        
        [cell.likeButton      addTarget:self action:@selector(addLikeOnPost2:) forControlEvents: UIControlEventTouchUpInside];
        cell.likeButton.tag = indexPath.row;
        
        [cell.repostButton      addTarget:self action:@selector(addRepost:) forControlEvents:UIControlEventTouchUpInside];
        cell.repostButton.tag = indexPath.row;
        
        
        [cell.commentButton addTarget:self action:@selector(showComment:) forControlEvents:UIControlEventTouchUpInside];
        cell.commentButton.tag = indexPath.row;
        [cell.commentButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
        
        if (wall.canLike == NO) {
            cell.likeView.backgroundColor =  [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:0.5];
        }
        
        
        if (wall.canRepost == NO) {
            cell.repostView.backgroundColor =  [UIColor colorWithRed:0.333 green:0.584 blue:0.820 alpha:0.5];
        } else {
            cell.repostView.backgroundColor = [UIColor clearColor];
        }
        
        
        
        
        __weak NGWallCellTableViewCell *weakCell = cell;
        
        NSURL* url = [[NSURL alloc] init];
        if (wall.user.photo_100URL) {
            url = wall.user.photo_100URL;
        }
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        
        [cell.ownerPhoto setImageWithURLRequest:request
                               placeholderImage:nil
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            
                                            weakCell.ownerPhoto.image = image;
                                            
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            
                                        }];
        
        
        
        
        if ([wall.attachments count] > 0) {
            
            if ([cell viewWithTag:11]) [[cell viewWithTag:11] removeFromSuperview];
            if ([cell viewWithTag:222]) [[cell viewWithTag:222] removeFromSuperview];
            if ([cell viewWithTag:555]) [[cell viewWithTag:555] removeFromSuperview];
            
            CGPoint point = CGPointZero;
            
            float sizeText = [self heightLabelOfTextForString:cell.textPost.text fontSize:14.f widthLabel:CGRectGetWidth(self.view.bounds)-2*8];
            
            point = CGPointMake(CGRectGetMinX(cell.ownerPhoto.frame),sizeText+(offsetBeforePhoto + heightPhoto + offsetBetweenPhotoAndText));
            
            CGSize sizeAttachment = CGSizeMake(CGRectGetWidth(self.view.bounds)-2*offset, CGRectGetWidth(self.view.bounds)-2*offset);
            
            NGImageViewGallery *galery = [[NGImageViewGallery alloc]initWithImageArray:wall.attachments startPoint:point withSizeView:sizeAttachment];
            galery.tag = 222;
            [cell addSubview:galery];
            
            ///
//            CGPoint newPoint = CGPointZero;
//            
//            for (id obj in wall.attachments) {
//                
//                if ([obj isKindOfClass:[NGLinkWallObjectData class]]) {
//                    
//                    if (CGRectGetMaxY(galery.frame)>70) {
//                        point = CGPointMake(CGRectGetMinX(cell.ownerPhoto.frame), CGRectGetMaxY(galery.frame));
//                    } else {
//                        point = CGPointMake(CGRectGetMinX(cell.ownerPhoto.frame), CGRectGetMaxY(cell.textPost.frame));
//                        
//                    }
//                    
//                    
//                    ASLink* link = (NGLinkWallObjectData*)obj;
//                    
//                    ASLinkModel* urlView = [[ASLinkModel alloc]initWithFrame:CGRectMake(point.x, point.y,
//                                                                                        self.view.bounds.size.width-16,50)];
//                    
//                    urlView.bounds = CGRectMake(point.x, point.y,  self.view.bounds.size.width-16,50);
//                    urlView.tag = 222;
//                    urlView.titleLabel.text = link.title;
//                    urlView.urlLabel.text   = link.urlString;
//                    
//                    [urlView.openSiteButton     addTarget:self
//                                                   action:@selector(openSiteAction:)
//                                         forControlEvents:UIControlEventTouchUpInside];
//                    
//                    [cell addSubview:urlView];
//                    point.y += 60;
//                    newPoint.y += 60;
//                }
//                
//                
//                if ([obj isKindOfClass:[ASAudio class]]) {
//                    
//                    if (newPoint.y>0) {
//                        
//                    } else {
//                        
//                        if (CGRectGetMaxY(galery.frame)>70) {
//                            point = CGPointMake(CGRectGetMinX(cell.ownerPhoto.frame), CGRectGetMaxY(galery.frame));
//                        } else {
//                            point = CGPointMake(CGRectGetMinX(cell.ownerPhoto.frame), CGRectGetMaxY(cell.textPost.frame));
//                        }
//                    }
//                    
//                    ASAudio* audio = (ASAudio*)obj;
//                    
//                    ASAudioView* audioView = [[ASAudioView alloc]initWithFrame:CGRectMake(point.x, point.y,
//                                                                                          self.view.bounds.size.width-16,50)];
//                    
//                    audioView.bounds = CGRectMake(point.x, point.y,  self.view.bounds.size.width-16,50);
//                    audioView.tag = 555;
//                    
//                    audioView.titleLabel.text = audio.title;
//                    audioView.descriptionLabel.text = audio.artist;
//                    audioView.durationLabel.text  = audio.duration;
//                    
//                    
//                    [cell addSubview:audioView];
//                    point.y += 60;
//                    newPoint.y += 60;
            
//                }
//                
//            }
       }
        return cell;
        
    }
        
    }
    
    static NSString *MyIdentifier = @"cellone";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }

    return cell;
}

- (CGRect)heightTextView:(UITextView *)view {
    
    CGFloat fixedWidth = view.frame.size. width;
    CGSize newSize = [view sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = view.frame;
    if (newSize.height > 200) {
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth),150);
    } else {
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    }
    
    return newFrame;
}



- (CGFloat)heightLabelOfTextForString:(NSString *)aString fontSize:(CGFloat)fontSize widthLabel:(CGFloat)width {
    
    UIFont* font = [UIFont systemFontOfSize:fontSize];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, paragraph, NSParagraphStyleAttributeName,shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [aString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attributes
                                        context:nil];
    
    return rect.size.height;
}

@end




