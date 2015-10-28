//
//  SidebarViewController.h
//  VK
//
//  Created by Naz on 10/20/15.
//  Copyright © 2015 Naz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageUser;
@property (weak, nonatomic) IBOutlet UILabel *nameUser;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
