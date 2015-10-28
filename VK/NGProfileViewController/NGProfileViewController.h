//
//  NGProfileViewController.h
//  VK
//
//  Created by Naz on 10/20/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGProfileViewController : UITableViewController
@property (strong, nonatomic) NSString* superUserID;
//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewPhotoCarusel;

@end
