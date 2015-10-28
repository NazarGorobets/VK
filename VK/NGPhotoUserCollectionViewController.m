//
//  NGPhotoUserCollectionViewController.m
//  VK
//
//  Created by Naz on 10/26/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import "NGPhotoUserCollectionViewController.h"
#import "NGPhotoObjectData.h"
#import "NGPhotoListCollectionViewCell.h"
#import "NGServerManager.h"
#import "SWRevealViewController.h"
#import "UIImageView+AFNetworking.h"




static CGSize CGResizeFixHeight(CGSize size) {
    
    CGFloat targetHeight = 55.0f;
    CGFloat scaleFactor = (targetHeight / size.height);
    CGFloat targetWidth = size.width * scaleFactor;
    
    return CGSizeMake(targetWidth, targetHeight);
}

@interface NGPhotoUserCollectionViewController (){
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (strong, nonatomic) NSMutableArray* miniaturePhotoArray;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) UICollectionView* collectionViewPhoto;

@property (assign, nonatomic)  BOOL loadingDataCollPhoto;

@end

@implementation NGPhotoUserCollectionViewController

@synthesize collectionView;
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     self.userID = [userDefaults objectForKey:@"userID"];
     self.miniaturePhotoArray     = [NSMutableArray array];
    [self getUserPhotoFromServer];
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        self.sidebarButton.action = @selector(revealToggle:);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)  getUserPhotoFromServer {
    
    __weak __typeof(self)weakSelf = self;
    
    self.loadingDataCollPhoto = YES;
    
    [[NGServerManager sharedManager] getPhotoUserID: self.userID
                                         withOffset:[self.miniaturePhotoArray count]
                                              count:100
                                          onSuccess:^(NSArray *photos) {
                                              
                                              
                                              if ([photos count] > 0) {
                                                  
                                                  NSMutableArray* arrPath = [NSMutableArray array];
                                                  
                                                  for (NSInteger i= [weakSelf.miniaturePhotoArray count]; i<=[photos count]+[weakSelf.miniaturePhotoArray count]-1; i++) {
                                                      
                                                      [arrPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                                  }
                                                  
                                                  [weakSelf.miniaturePhotoArray addObjectsFromArray:photos];
                                                  [weakSelf.collectionViewPhoto insertItemsAtIndexPaths:arrPath];
                                                  
                                                  
                                                    self.loadingDataCollPhoto = NO;
                                                   [self reloadTableViewContent];
                                              }
                                              
                                          } onFailure:^(NSError *error, NSInteger statusCode) {
                                              
                                          }];
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.miniaturePhotoArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NGPhotoListCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    NGPhotoObjectData* photo = self.miniaturePhotoArray[indexPath.row];
    
    __weak NGPhotoListCollectionViewCell *weakCell = cell;
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:photo.photo_130URL];
    
    [cell.image setImageWithURLRequest:request
                          placeholderImage:[UIImage imageNamed:@"user202"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.image.image = image;
                                       
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       
                                   }];

    
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

- (void)reloadTableViewContent {
    
    if (self.loadingDataCollPhoto == NO) {
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            [self.collectionView reloadData];
        });
    }
    
}

#pragma mark - UICollectionViewDelegate


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

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

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"%ld", (long)indexPath.item);
    
}

@end
