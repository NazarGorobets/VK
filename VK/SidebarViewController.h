//
//  SidebarViewController.h
//  VK
//
//  Created by Naz on 10/20/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NGSenderDataDelegate <NSObject>

@required

- (void)dataFromController:(NSString *)name addCount:(NSURL*) photoUrl;

@end

@interface SidebarViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageUser;
@property (weak, nonatomic) IBOutlet UILabel *nameUser;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSURL *imageUs;
@property (strong, nonatomic) NSString *nameUs;

@property (weak, nonatomic) id <NGSenderDataDelegate> delegate;


@end
